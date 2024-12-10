import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:http/http.dart' as http;
import 'package:walkagift/SplashScreen.dart';
import 'package:walkagift/TabLayout.dart';
import 'package:walkagift/constant.dart';

class SplashScreenMain extends StatefulWidget {
  @override
  State<SplashScreenMain> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenMain> {
  @override
  void initState() {
    super.initState();

    initialize();
  }
  Future<void> initialize() async {
   await FirebaseFirestore.instance.collection('serverTime').doc('dateis').set({
      'serverTimeField': FieldValue.serverTimestamp(),
    });
    await requestPermission();
    await userTokenUpdate();
    await updateUserSteps();
    navigateToNextScreen();
    // sendPushNotification(token, body, title)
  }

  Future<void> fetchGoogleFitData(GoogleSignInAccount googleSignInAccount) async {
    final int maxRetries = 5;
    int retryCount = 0;
    bool success = false;

    while (retryCount < maxRetries && !success) {
      try {
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
        final authenticatedHttpClient = authenticatedClient(client, credentials);
        final fitnessApi = FitnessApi(authenticatedHttpClient);
        final dataSources = await fitnessApi.users.dataSources.list('me');
        DataSource? stepsDataSource;
        try {
          stepsDataSource = dataSources.dataSource!.firstWhere(
                  (ds) => ds.dataType?.name == 'com.google.step_count.delta');
        } catch (e) {
          print('No step data source found.');
          continue;
        }

        if (stepsDataSource == null) {
          print('No step data source found.');
          continue;
        }
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds
        final dataSets = await fitnessApi.users.dataSources.datasets.get(
          'me',
          stepsDataSource.dataStreamId!,
          '${startOfDay}-${endOfDay}',
        );
        int totalSteps = 0;
        if (dataSets.point != null) {
          for (var point in dataSets.point!) {
            totalSteps += point.value!.first.intVal ?? 0;
          }
        } else {
          print('No data points found.');
          continue;
        }
        print('Total steps: $totalSteps');
        await FirebaseFirestore.instance.collection('steps').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'uid': googleSignInAccount.id,
          'steps': totalSteps,
          'timestamp': DateTime.now(),
        }, SetOptions(merge: true));

        authenticatedHttpClient.close();
        client.close();
        success = true; // Data fetched and updated successfully
      } catch (e) {
        print('Error fetching Google Fit data: $e');
        retryCount++;
        await Future.delayed(Duration(seconds: 2)); // Wait before retrying
      }
    }
  }

  Future<void> updateUserSteps() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signInSilently();
      if (googleSignInAccount != null) {
        await fetchGoogleFitData(googleSignInAccount);
      } else {
        print('Google Sign-In account is null.');
      }
    } catch (e) {
      print('Error updating user steps: $e');
    }
  }
  Future<void> userTokenUpdate() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
        'token': token,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user token: $e');
    }
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied and did not grant any permission");
    }
  }
  savetoken(user)async{
    if (user != null) {
      print('uid is= ${auth.currentUser!.uid}');
      String? token=await FirebaseMessaging.instance.getToken();
      firebaseFirestore.collection("users").doc(auth.currentUser!.uid).update({
        'token':token
      }
        //SetOptions(merge: true)
      ).then((value) => {
        print('my token$token'),
        // Get.to(HomeScreen());
        Timer(Duration(seconds: 2), () => Get.offAll(() => TabLayouts())),
        // Get.snackbar("WELCOME", "WELCOME TO BEST SERVICE PROVIDER SYSTEM")
      });
    }
  }
  void navigateToNextScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Timer(Duration(seconds: 3), () => Get.offAll(() => SplashScreen()));
    } else {
      savetoken(user);
      // Timer(Duration(seconds: 3), () => Get.offAll(() => TabLayouts()));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xffbecfd8),
              Color(0xff6a91a9),
              Color(0xff567a93),
              Color(0xff8cabc0),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 180,
              child: Image(image: AssetImage("assets/logo.png")),
            ),
            Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
