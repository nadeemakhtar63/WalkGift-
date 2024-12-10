// import 'package:flutter/material.dart';
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_fit/google_fit.dart';
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   GoogleFit googleFit = GoogleFit();
//   int _totalSteps = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     initGoogleFit();
//   }
//   Future<void> requestPermissions() async {
//     await [
//       Permission.activityRecognition,
//       Permission.sensors,
//     ].request();
//   }
//   Future<void> initGoogleFit() async {
//     await requestPermissions();
//     // bool isAuthorized = await googleFit.authorize();
//     // if (isAuthorized) {
//       fetchStepData();
//     // }
//   }
//
//   Future<void> fetchStepData() async {
//     DateTime now = DateTime.now();
//     DateTime startOfDay = DateTime(now.year, now.month, now.day);
//     DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//
//     List<StepCount> stepCounts = await googleFit.getSteps(startOfDay, endOfDay);
//     int totalSteps = stepCounts.fold(0, (sum, item) => sum + item.count);
//
//     setState(() {
//       _totalSteps = totalSteps;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Google Fit Step Count'),
//         ),
//         body: Center(
//           child: Text('Total Steps: $_totalSteps'),
//         ),
//       ),
//     );
//   }
// }
