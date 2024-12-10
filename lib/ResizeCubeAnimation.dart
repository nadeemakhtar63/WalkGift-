// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';
//
// class ResizeCubeAnimation extends StatelessWidget {
//   const ResizeCubeAnimation({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // PlayAnimationBuilder plays animation once
//     return PlayAnimationBuilder<double>(
//       tween: Tween(begin: 100.0, end: 200.0), // 100.0 to 200.0
//       duration: const Duration(seconds: 1), // for 1 second
//       builder: (context, value, _) {
//         return Container(
//           width: value, // use animated value
//           height: value,
//           color: Colors.blue,
//         );
//       },
//       onCompleted: () {
//         // do something ...
//       },
//     );
//   }
// }