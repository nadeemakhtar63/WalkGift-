import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AciveOrderModel{
  late String DocumentId;
  late  String username;
  late String productId;
  late String productName;
  late String useraddress;
  late String userId;
  late String companyname;
  late String trackingnumber;
  late var dateTime;
  // late String companyname;
  // late String createdDate;
  late String statue;
  // late Timestamp dateTime;
  AciveOrderModel(
      this.DocumentId,
      this.username,
      this.productId,
      this.productName,
      this.useraddress,
      this.userId,
      this.companyname,
      this.trackingnumber,
      // this.createdDate,
      this.dateTime,
      this.statue);
  AciveOrderModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot})
  {
    DocumentId=documentSnapshot.id;
    companyname=documentSnapshot['companyname'];
  dateTime=documentSnapshot['dateTime'];
    username=documentSnapshot["username"];
    productId=documentSnapshot["productId"];
    trackingnumber=documentSnapshot['trackingnumber'];
    productName=documentSnapshot['productName'];
    useraddress=documentSnapshot["useraddress"];
    userId=documentSnapshot["userId"];
    // createdDate=documentSnapshot["createdDate"];
    statue=documentSnapshot["statue"];
  }
}