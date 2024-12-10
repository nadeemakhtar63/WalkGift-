// import 'package:health/health.dart';
// import 'package:walkagift/ModelClasses/FootSteps.dart';
//
// class HealthRepository {
//   // final health = HealthFactory();
//   Future<List<FootSteps>> getFootSteep() async {
//     bool requested = await Health().requestAuthorization([HealthDataType.STEPS]);
//     if (requested) {
//       var now = DateTime.now();
//       List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
//           startTime: now.subtract(Duration(days: 1)), endTime: now,
//           types:[HealthDataType.STEPS, HealthDataType.BLOOD_GLUCOSE]);
//       return healthData.map((e) {
//         var b = e;
//         return FootSteps(
//           double.parse(b.value.toString()),
//           b.unitString,
//           b.dateFrom,
//           b.dateTo,
//         );
//       }).toList();
//     }
//     return [];
//   }
// }