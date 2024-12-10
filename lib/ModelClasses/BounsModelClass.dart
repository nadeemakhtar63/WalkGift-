import 'package:cloud_firestore/cloud_firestore.dart';

class BounsModelClass{
  String? title;
  int? pathneed;
  int? regular_select;
  String? subTitle;
  String? pointsget;
  String? adsimage;
  int? totalrewords;
  String? descryption;
  String? id;
  BounsModelClass(this.title, this.subTitle, this.adsimage, this.totalrewords, this.id,this.descryption,this.pointsget,this.pathneed,this.regular_select);
  BounsModelClass.fromDoccumentSnapSHot({required DocumentSnapshot snapshot}){
  id=snapshot.id;
  pointsget=snapshot['pointswin'];
  regular_select=snapshot['regular_select'];
  title=snapshot['title'];
  subTitle=snapshot['subTitle'];
  descryption=snapshot['descryption'];
  adsimage=snapshot['image'];
  totalrewords=snapshot['trewords'];
  pathneed=snapshot['pathneed'];
  }
}