import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';
import 'package:walkagift/ModelClasses/AdswachedcompleteModel.dart';
import 'package:walkagift/ModelClasses/BounsModelClass.dart';
import 'package:walkagift/ModelClasses/FAQModelClas.dart';
import 'package:walkagift/ModelClasses/GiftProductsModelClass.dart';
import 'package:walkagift/ModelClasses/PlaceOrderModelClass.dart';
import 'package:walkagift/ModelClasses/ProfileModel.dart';
import 'package:walkagift/ModelClasses/annoucementModelClass.dart';
import 'package:http/http.dart' as http;
import 'package:walkagift/constant.dart';
class MyControllers extends GetxController {
  // var steps = 0.obs;
  // final GoogleSignIn googleSignIn = GoogleSignIn(
  //   scopes: [
  //     FitnessApi.fitnessActivityReadScope,
  //     FitnessApi.fitnessActivityWriteScope,
  //   ],
  // );
  var userModel = Rxn<UserModel>();
  Rx<List<BounsModelClass>> bounsList = Rx<List<BounsModelClass>>([]);
  Rx<List<AdsWatchCompleteModel>> adsWatchList = Rx<
      List<AdsWatchCompleteModel>>([]);

// Rx<List<ProfileModelClass>> profileList=Rx<List<ProfileModelClass>>([]);
  List<BounsModelClass> get bounsDataList => bounsList.value;

  List<AdsWatchCompleteModel> get adsWatchListget => adsWatchList.value;

// List<ProfileModelClass> get profileListget=>profileList.value;

  Rx<List<GeftProductModelClass>> GiftsProducts = Rx<
      List<GeftProductModelClass>>([]);

  List<GeftProductModelClass> get GiftsProductsget => GiftsProducts.value;

  Rx<List<AciveOrderModel>> activeorderList = Rx<List<AciveOrderModel>>([]);

  List<AciveOrderModel> get activeOrdergeter => activeorderList.value;

  Rx<List<AnnoucementDisplayModel>> annoucementList = Rx<
      List<AnnoucementDisplayModel>>([]);

  List<AnnoucementDisplayModel> get annoucementgeter => annoucementList.value;

  Rx<List<FAQModelClass>> FAQList = Rx<List<FAQModelClass>>([]);

  List<FAQModelClass> get FAQListgeter => FAQList.value;

  @override
  void onReady() {
    bounsList.bindStream(FirebaseCrud.AllbounsGetFun());
    // adsWatchList.bindStream(FirebaseCrud.AdsWatchCompleteFun());
    FAQList.bindStream(FirebaseCrud.getAllFAQS());
    // profileList.bindStream(FirebaseCrud.ProfileGetFun());
    annoucementList.bindStream(FirebaseCrud.AnnoucmentAdsCompleteFun());
    GiftsProducts.bindStream(FirebaseCrud.GiftProductGetFun());
    activeorderList.bindStream(FirebaseCrud.ActiveOrderFun());
    _checkDateAndDeleteAds();
    fetchUserData();
//
  }

  void fetchUserData() async {
    try {
      // String userId = 'your_user_id'; // Replace with actual user ID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  // Future<void> fetchGoogleFitData(GoogleSignInAccount googleSignInAccount) async {
  //   final authHeaders = await googleSignInAccount.authHeaders;
  //   final credentials = AccessCredentials(
  //     AccessToken(
  //       'Bearer',
  //       authHeaders['Authorization']!.split(' ').last,
  //       DateTime.now().toUtc().add(Duration(hours: 1)),
  //     ),
  //     null,
  //     ['https://www.googleapis.com/auth/fitness.activity.read'],
  //   );
  //
  //   final client = http.Client();
  //   final authenticatedHttpClient = authenticatedClient(
  //     client,
  //     credentials,
  //   );
  //
  //   final fitnessApi = FitnessApi(authenticatedHttpClient);
  //   final dataSources = await fitnessApi.users.dataSources.list('me');
  //
  //   final stepsDataSource = dataSources.dataSource!.firstWhere(
  //         (ds) => ds.dataType?.name == 'com.google.step_count.delta',
  //   );
  //
  //   final now = DateTime.now();
  //   final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds
  //   final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds
  //
  //   final dataSets = await fitnessApi.users.dataSources.datasets.get(
  //     'me',
  //     stepsDataSource.dataStreamId!,
  //     '${startOfDay}-${endOfDay}',
  //   );
  //
  //   int totalSteps = 0;
  //   for (var point in dataSets.point!) {
  //     totalSteps += point.value!.first.intVal ?? 0;
  //   }
  //
  //   steps.value = totalSteps;
  //
  //   await FirebaseFirestore.instance.collection('steps').doc(FirebaseAuth.instance.currentUser!.uid).update({
  //     'uid': googleSignInAccount.id,
  //     'steps': totalSteps,
  //     'timestamp': DateTime.now(),
  //   });
  //
  //   authenticatedHttpClient.close();
  //   client.close();
  // }
  //
  // void updateUserSteps() async {
  //   final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signInSilently();
  //   if (googleSignInAccount != null) {
  //     await fetchGoogleFitData(googleSignInAccount);
  //   }
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   updateUserSteps();
  // }
  Future<void> _checkDateAndDeleteAds() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    QuerySnapshot<
        Map<String, dynamic>> watchedAdsSnapshot = await FirebaseFirestore
        .instance
        .collection('BonscompleteAdd')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in watchedAdsSnapshot.docs) {
          DateTime? lastWatched = (doc.data()['lastdatewatched'] as Timestamp?)
          ?.toDate();
      if (lastWatched != null && lastWatched.isBefore(today)) {
        await FirebaseFirestore.instance.collection('BonscompleteAdd').doc(
            doc.id).delete();
      }
    }
  }
}