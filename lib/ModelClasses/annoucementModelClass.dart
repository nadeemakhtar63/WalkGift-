import 'package:cloud_firestore/cloud_firestore.dart';

class AnnoucementDisplayModel{
  String? id;
  String? adsImage;
  Timestamp? timeDate;
  AnnoucementDisplayModel(this.id, this.adsImage, this.timeDate);
  AnnoucementDisplayModel.fromDoccumentSnapSHot({required DocumentSnapshot snapshot}){
    id=snapshot.id;
    adsImage=snapshot['image'];
    timeDate=snapshot['timefram'];
  }
}
