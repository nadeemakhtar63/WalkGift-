import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ModelClasses/BounsModelClass.dart';
import 'constant.dart';

class AdService {
  Future<DateTime> _getServerTime() async {
    final response = await http.get(Uri.parse('https://your-time-server.com/api/current-time'));
    if (response.statusCode == 200) {
      final serverTime = jsonDecode(response.body)['currentTime'];
      return DateTime.parse(serverTime);
    } else {
      throw Exception('Failed to fetch server time');
    }
  }

  Future<void> _checkDateAndUpdateAds() async {
    DateTime serverTime = await _getServerTime();
    DateTime today = DateTime(serverTime.year, serverTime.month, serverTime.day);

    QuerySnapshot<Map<String, dynamic>> watchedAdsSnapshot = await firebaseFirestore
        .collection('adswatchedComplete')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in watchedAdsSnapshot.docs) {
      DateTime? lastWatched = (doc.data()['lastWatched'] as Timestamp?)?.toDate();
      if (lastWatched != null) {
        DateTime lastWatchedDate = DateTime(lastWatched.year, lastWatched.month, lastWatched.day);
        if (lastWatchedDate.isBefore(today) && serverTime.difference(lastWatchedDate).inDays > 1) {
          await firebaseFirestore.collection('adswatchedComplete').doc(doc.id).delete();
        }
      }
    }
  }

  // Future<void> handleAdWatched(BounsModelClass allitesm) async {
  //   DateTime serverTime = await _getServerTime();
  //   DateTime today = DateTime(serverTime.year, serverTime.month, serverTime.day);
  //
  //   // Fetch user data and compare with server time as before
  //   // ...
  //
  //   // Update lastWatched with server time
  //   // ...
  // }
}
