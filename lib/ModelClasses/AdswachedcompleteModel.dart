import 'package:cloud_firestore/cloud_firestore.dart';

class AdsWatchCompleteModel{
  String? ad_id;
  String? uid;
  int? watchCount;
  String? id;
  AdsWatchCompleteModel(this.ad_id, this.uid, this.watchCount);
  AdsWatchCompleteModel.fromdocumentSnap({required DocumentSnapshot snapshot}){
    id=snapshot.id;
    ad_id=snapshot['ad_id'];
    uid=snapshot["uid"];
  }
}