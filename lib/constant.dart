import 'dart:convert';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walkagift/TabLayout.dart';
import 'package:http/http.dart' as http;
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
// final GoogleSignIn googleSignIn = GoogleSignIn();
List<Map> countriesName=
[
  {
    "name":"English".tr,
    "image":"assets/countries/eng.png",
    "check":false,
  },
  {
    "name":"Spanish".tr,
    "image":"assets/countries/spansh.png",
    "check":false,
  },
  {
    "name":"French".tr,
    "image":"assets/countries/frensh.png",
    "check":false,
  },
  {
    "name":"India".tr,
    "image":"assets/countries/india.png",
    "check":false,
  },
  {
    "name":"Portuguese".tr,
    "image":"assets/countries/portgos.png",
    "check":false,
  },
  {
    "name":"German".tr,
    "image":"assets/countries/german.png",
    "check":false,
  }

];
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/fitness.activity.read',
    'https://www.googleapis.com/auth/fitness.activity.write',
    FitnessApi.fitnessActivityReadScope,
    FitnessApi.fitnessActivityWriteScope,
  ],
  // scopes: [
  // 'nadeemakhtar5353@gmail.com'
  // // for basic profile info
  //   'https://www.googleapis.com/auth/fitness.activity.read',  // for accessing user's profile data
  // ],
);
// Save data to shared preferences
void _saveData({required String accessToken,required String idToken}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('idToken', idToken);
}
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
  // final authHeaders = await googleSignInAccount.authHeaders;
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final  authResult = await auth.signInWithCredential(credential);
  _saveData(accessToken: googleSignInAuthentication.accessToken!, idToken: authResult!.additionalUserInfo!.authorizationCode.toString());
  final  user = authResult.user;
  String? token=await FirebaseMessaging.instance.getToken();
  final User? currentUser = await auth.currentUser;
  // assert(!user!.isAnonymous);
  // assert(await user!.getIdToken() != null);
  if(authResult.additionalUserInfo!.isNewUser){
  //
  //
  // if(currentUser!.uid==user!.uid)
  //   {
      firebaseFirestore.collection("users").doc(auth.currentUser!.uid).set({
        "name":googleSignInAccount.displayName,
        "userimage":googleSignInAccount.photoUrl,
        "email":googleSignInAccount.email,
        "uid":auth.currentUser!.uid,
        "points":0,
        'address':'',
        'phoneNumber':auth.currentUser!.phoneNumber!,
        'conertedsteps':0,
        'dailysteps':0,
        'token':token,
        'myorders':0
      }).whenComplete(() {
         fetchGoogleFitData(googleSignInAccount);

      }
      );

    }
  else{
    firebaseFirestore.collection("users").doc(auth.currentUser!.uid).update({
      'token':token
    });
    await fetchGoogleFitData(googleSignInAccount);
    // Get.to(TabLayouts());
  }

  // Fetch Google Fit data after sign-in

  // assert(user!.uid == currentUser!.uid);
  return 'signInWithGoogle succeeded: $user';
}

Future<void> fetchGoogleFitData(GoogleSignInAccount googleSignInAccount) async {
  final authHeaders = await googleSignInAccount.authHeaders;
  final credentials = AccessCredentials(
    AccessToken(
      'Bearer',
      authHeaders['Authorization']!.split(' ').last,
      DateTime.now().toUtc().add(Duration(hours: 1)),
    ),
    null,
    ['https://www.googleapis.com/auth/fitness.activity.read'],
  );

  final client = http.Client();
  final authenticatedHttpClient = authenticatedClient(
    client,
    credentials,
  );

  final fitnessApi = FitnessApi(authenticatedHttpClient);
  final dataSources = await fitnessApi.users.dataSources.list('me');

  final stepsDataSource = dataSources.dataSource!.firstWhere(
        (ds) => ds.dataType?.name == 'com.google.step_count.delta',
  );

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds

  final dataSets = await fitnessApi.users.dataSources.datasets.get(
    'me',
    stepsDataSource.dataStreamId!,
    '${startOfDay}-${endOfDay}',
  );

  int totalSteps = 0;

  // Process and store data
  for (var point in dataSets.point!) {
    totalSteps += point.value!.first.intVal ?? 0;
  }

  await firebaseFirestore.collection('steps').doc(auth.currentUser!.uid).set({
    'uid': googleSignInAccount.id,
    'steps': totalSteps,
    'timestamp': DateTime.now(),
  }).whenComplete(() =>  Get.to(TabLayouts()));

  // Close the client
  authenticatedHttpClient.close();
  client.close();
}
Future<void> updateStepsData(GoogleSignInAccount googleSignInAccount) async {
  final authHeaders = await googleSignInAccount.authHeaders;
  final credentials = AccessCredentials(
    AccessToken(
      'Bearer',
      authHeaders['Authorization']!.split(' ').last,
      DateTime.now().toUtc().add(Duration(hours: 1)),
    ),
    null,
    ['https://www.googleapis.com/auth/fitness.activity.read'],
  );

  final client = http.Client();
  final authenticatedHttpClient = authenticatedClient(
    client,
    credentials,
  );

  final fitnessApi = FitnessApi(authenticatedHttpClient);
  final dataSources = await fitnessApi.users.dataSources.list('me');

  final stepsDataSource = dataSources.dataSource!.firstWhere(
        (ds) => ds.dataType?.name == 'com.google.step_count.delta',
  );

  final now = DateTime.now().millisecondsSinceEpoch * 1000000;  // Convert to nanoseconds
  final oneWeekAgo = now - (7 * 24 * 60 * 60 * 1000000000); // 7 days in nanoseconds

  final dataSets = await fitnessApi.users.dataSources.datasets.get(
    'me',
    stepsDataSource.dataStreamId!,
    '${oneWeekAgo}-${now}',
  );

  int totalSteps = 0;
  for (var point in dataSets.point!) {
    totalSteps += point.value!.first.intVal ?? 0;
  }

  await firebaseFirestore.collection("users").doc(auth.currentUser!.uid).update({
    'conertedsteps': totalSteps,
    'lastUpdated': FieldValue.serverTimestamp(), // Optional: track the last update time
  });

  // Close the client
  authenticatedHttpClient.close();
  client.close();
}

 sendPushNotification(String? token,String body,String title)async
{
  print("Your Givin Token is");
  try {

    final response=   await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'content-type': 'application/json',
        'Authorization': 'key=AAAAiXKVKMk:APA91bH53DuBtqsBTh6We9IMQjrC7e5Z8kSsuy2l_f8X9wWGsGNeMx8HxM6Tb2zy0y4_XGFNv3Xr5ClcF4rrmvvt5Iw7yR13l0PsyM--WFH3qRmQFQ_fuWhwFoPtlPTLHxc-0NSnQ6zN'
      },
      body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            "notification":<String,dynamic>{
              "title":title,
              "body":body,
              "android_channel_id":"abcd"
            },
            "to":token
          }),
    );
    if (response.statusCode == 200) {
      print('test ok push CFM');
      // return true;
    } else {
      print(' CFM error');
      print(response.statusCode);
      // return false;
    }
  }
  catch(firebaseAuthException)
  {
    print('reasun for why notification${firebaseAuthException.toString()}');
  }
}