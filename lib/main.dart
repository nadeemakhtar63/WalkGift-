import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:walkagift/SplashMain.dart';
import 'package:walkagift/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await  Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDJRVKr8-CZjJZTkvoBefp4cqFxA84EkcI", // paste your api key here
          appId: "1:590332897481:android:70ece925fcb7a352b5c518", //paste your app id here
          messagingSenderId: "590332897481", //paste your messagingSenderId here
          projectId: "walk-gift", //paste your project id here
          storageBucket: "walk-gift.appspot.com"
      )
  );
  await MobileAds.instance.initialize();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Listneing to the foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(
      new GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenMain(),));
}

void showNotification(String title, String body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'abcd',
    'channel name',
    importance: Importance.max,
    priority: Priority.high,
  );
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
}
