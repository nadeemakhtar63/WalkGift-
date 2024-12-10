import 'package:cloud_firestore/cloud_firestore.dart';

class GeftProductModelClass{
  String? title;
  String? subTitle;
  String? pointsget;
  String? adsimage;
  int? totalrewords;
  String? descryption;
  String? id;
  GeftProductModelClass(this.title, this.subTitle, this.adsimage, this.totalrewords, this.id,this.descryption,this.pointsget);
  GeftProductModelClass.fromDoccumentSnapSHot({required DocumentSnapshot snapshot}){
    id=snapshot.id;
    pointsget=snapshot['pointswin'];
    title=snapshot['title'];
    subTitle=snapshot['subtitle'];
    descryption=snapshot['description'];
    adsimage=snapshot['image'];
    totalrewords=snapshot['trewords'];
  }
}