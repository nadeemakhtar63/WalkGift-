import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:walkagift/ModelClasses/AdswachedcompleteModel.dart';
import 'package:walkagift/ModelClasses/BounsModelClass.dart';
import 'package:walkagift/ModelClasses/FAQModelClas.dart';
import 'package:walkagift/ModelClasses/GiftProductsModelClass.dart';
import 'package:walkagift/ModelClasses/PlaceOrderModelClass.dart';
import 'package:walkagift/ModelClasses/ProfileModel.dart';
import 'package:walkagift/ModelClasses/annoucementModelClass.dart';
import 'package:walkagift/TabLayout.dart';
import 'package:walkagift/constant.dart';
class FirebaseCrud{
  static Stream<List<GeftProductModelClass>> GiftProductGetFun(){
    return firebaseFirestore.collection("giftProducts").orderBy('timefram', descending: true).snapshots().map((QuerySnapshot snapshot)
    {
      List<GeftProductModelClass> bounsdataList=[];
      for(var i in snapshot.docs){
        final bounses=GeftProductModelClass.fromDoccumentSnapSHot(snapshot: i);
        bounsdataList.add(bounses);
      }
      return bounsdataList;
    });
  }
  static Stream<List<AciveOrderModel>> ActiveOrderFun() {
    if (auth.currentUser == null) {
      // If the user is not authenticated, return an empty list.
      return Stream.value([]);
    }

    return firebaseFirestore
        .collection("orderPlaced")
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      if (query.docs.isEmpty) {
        // If no documents are found, return an empty list.
        return [];
      }

      List<AciveOrderModel> catagory = [];
      for (var todo in query.docs) {
        final catogorymodel = AciveOrderModel.fromDocumentSnapshot(documentSnapshot: todo);
        catagory.add(catogorymodel);
      }
      return catagory;
    });
  }

static Stream<List<BounsModelClass>> AllbounsGetFun(){
return firebaseFirestore.collection("annoucements").orderBy('pathneed', descending: false).snapshots().map((QuerySnapshot snapshot)
{
List<BounsModelClass> bounsdataList=[];
for(var i in snapshot.docs){
final bounses=BounsModelClass.fromDoccumentSnapSHot(snapshot: i);
bounsdataList.add(bounses);

}
return bounsdataList;
});
}
// static Stream<List<ProfileModelClass>> ProfileGetFun(){
//   return firebaseFirestore.collection("users").where("uid",isEqualTo: auth.currentUser!.uid).snapshots().map((QuerySnapshot snapshot)
//   {
//     List<ProfileModelClass> bounsdataList=[];
//     for(var i in snapshot.docs){
//       final bounses=ProfileModelClass.fromDocumentSnapshot(snapshot: i);
//       bounsdataList.add(bounses);
//
//     }
//     return bounsdataList;
//   });
// }
  static Stream<List<FAQModelClass>> getAllFAQS(){
    return firebaseFirestore.collection("faq").snapshots().map((QuerySnapshot snapshot)
    {
      List<FAQModelClass> allFaqList=[];
      for(var i in snapshot.docs) {
        final faqs=FAQModelClass.fromDocumentSnapShoot(snapshot: i);
        allFaqList.add(faqs);
      }
      return allFaqList;
    });
  }
//annoucement function
  static Stream<List<AnnoucementDisplayModel>> AnnoucmentAdsCompleteFun(){
    return firebaseFirestore.collection("imageAnnouceShow").snapshots().map((QuerySnapshot snapshot)
    {
      List<AnnoucementDisplayModel> bounsdataList=[];
      for(var i in snapshot.docs){
        final bounses=AnnoucementDisplayModel.fromDoccumentSnapSHot(snapshot: i);
        bounsdataList.add(bounses);
      }
      return bounsdataList;
    });
  }



static Stream<List<AdsWatchCompleteModel>> AdsWatchCompleteFun(){
  return firebaseFirestore.collection("adswatchedComplete").snapshots().map((QuerySnapshot snapshot)
  {
    List<AdsWatchCompleteModel> bounsdataList=[];
    for(var i in snapshot.docs){
      final bounses=AdsWatchCompleteModel.fromdocumentSnap(snapshot: i);
      bounsdataList.add(bounses);

    }
    return bounsdataList;
  });
}
  Future<void> updateUserConvertedSteps({required double pointsToAdd,required stepsConvert,required totalSteps,required context}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
      .where('uid', isEqualTo: auth.currentUser!.uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the first document (assuming there's only one match)
        DocumentReference userRef = querySnapshot.docs.first.reference;
        // Get the previous points
        double previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
        int conertedsteps = (querySnapshot.docs.first.data() as Map<String, dynamic>)['conertedsteps'] ?? 0;
        // Calculate the new total points
        double newPoints = previousPoints + pointsToAdd;
        // Query the user collection to find the document where uid matches
        firebaseFirestore.collection("stepsConverteing").doc(
            auth.currentUser!.uid).set({
          'stepsConvert': stepsConvert,
          'totalSteps': totalSteps,
          'points': pointsToAdd,
          'uid':auth.currentUser!.uid,
          "dateTime": Timestamp.fromDate(DateTime.now())
        }).whenComplete(() =>
        firebaseFirestore.collection('users').doc(auth.currentUser!.uid).update({'points': newPoints, 'conertedsteps':conertedsteps+totalSteps})
         .whenComplete(() {
          showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                insetPadding: EdgeInsets.all(20), // To provide padding from screen edges
                child: Container(
                  width: 300, // Specify the desired width
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AlertDialog(
                        title: Column(
                          children: [
                            Text(
                              "Your $stepsConvert Steps are converted successfully",
                              style: TextStyle(fontWeight: FontWeight.w900,fontSize: 11),
                            ),
                            SizedBox(height: 10),
                            Image.asset('assets/lotryopen.png', width: 60, height: 90),
                          ],
                        ),
                        content: Text("You Gained = $pointsToAdd Point"),
                        actions: [
                          MaterialButton(
                            color: Colors.blueGrey,
                            onPressed: () {
                              Get.off(() => TabLayouts());
                              Navigator.pop(context);
                            },
                            child: Text("Claim"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        }
            // Get.snackbar("Steps Converted","Your Steps Converted Successfully")
        )
        );
      }
    } catch (e) {
      print('Error updating points: $e');
    }
  }
  Future<void> updateUserPoints({required  pointsToAdd}) async {
    try {
      // Query the user collection to find the document where uid matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').
      where('uid', isEqualTo: auth.currentUser!.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the first document (assuming there's only one match)
        DocumentReference userRef = querySnapshot.docs.first.reference;

        // Get the previous points
        double previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;

        // Calculate the new total points
        double newPoints = previousPoints + double.parse(pointsToAdd);

        // Update the points field in the document
        await userRef.update({
          'points': newPoints,
        });

        print('Points updated successfully! New total points: $newPoints');
      } else {
        print('User document not found for current user');
      }
    } catch (e) {
      print('Error updating points: $e');
    }
  }
  Future<String> detectUserPoints({required int pointsToAdd,required context}) async {
    String  response="";
    try {
      // Query the user collection to find the document where uid matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: auth.currentUser!.uid).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the first document (assuming there's only one match)
        DocumentReference userRef = querySnapshot.docs.first.reference;
        // Get the previous points
        double previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
        // Calculate the new total points
        double newPoints = previousPoints - (pointsToAdd.toDouble());
        // Update the points field in the document
        await userRef.update({
          'points': newPoints,
        })   .then((value) => {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_){
                return AlertDialog(
                  title: Text('Your Order Has Been Placed Successfully'),
                  content: Text("We Will Notify You Once It Is Processed."),
                  actions: [
                    MaterialButton(onPressed: (){
                      Get.offAll(()=>TabLayouts());
                    },
                    child: Text("BACK TO HOME"),
                    )
                  ],
                );
              }),
          print('response return '),
          response="sucess",
          // Get.snackbar("Order Placed","Successfully Place This Order "),
          // Get.to(()=>TabLayouts())
        }).catchError((error){
          response="error";
        });;

        print('Points updated successfully! New total points: $newPoints');
      } else {
        print('User document not found for current user');
      }
    } catch (e) {
      print('Error updating points: $e');
    }
    return response;
  }
placeOrder({required phoneNumber,required token,required previuseOrder,required String userName,required String adress,required context,
  required String productId,required String productName,required productpoints,required numberofProducts})async{
  int numofnewproduct=numberofProducts-1;
    bool res;
   firebaseFirestore.collection("orderPlaced").add({
      'username':userName,
     'phoneNumber':phoneNumber,
      'productId':productId,
      'productName':productName,
      'useraddress':adress,
      'userId':auth.currentUser!.uid,
      'createdDate':DateTime.now(),
      'dateTime':null,
      'trackingnumber':'',
      'companyname':'',
      'statue':'Pending'
    }).then((value) => {
      print("my logo is $token"),
     adminplaceOrder(userName),
      sendPushNotification(token, "Thanks for Ordering", "We inform further process please wait"),
   firebaseFirestore.collection('giftProducts').doc(productId).update({'trewords':numofnewproduct}).then((value) =>
   detectUserPoints(pointsToAdd: productpoints,context: context)),
     firebaseFirestore.collection("users").doc(auth.currentUser!.uid).update({
     'myorders':previuseOrder+1
   })
      // res=false;
    });
}
  adminplaceOrder(userName)async{
    try {
      // Query the user collection to find the document where uid matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('adminuser').get();
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the first document (assuming there's only one match)
        DocumentReference userRef = querySnapshot.docs.first.reference;
        // Get the previous points
        String token = (querySnapshot.docs.first.data() as Map<String, dynamic>)['token'] ?? '';
        // Update the points field in the document
        sendPushNotification(token, "New Order Placed", "New order placed by $userName user");
        // print('Points updated successfully! New total points: $newPoints');
      } else {
        print('User document not found for current user');
      }
    } catch (e) {
      print('Error updating points: $e');
    }
  }
// update_giftProducts({required numberofProducts,required productId}){
//     firebaseFirestore.collection('giftProducts').doc(productId).update({'trewords':numberofProducts});
// }
saveAdWatch({required String uid, required String ads_id,required watchCount,required lastWatched,required regularwatch})
{
  firebaseFirestore.collection("adswatchedComplete").doc(uid+ads_id).set({
    "uid":uid,
    "ad_id":ads_id,
    "regularwatch":regularwatch,
    // "watchCount":watchedcount,
    'watchCount': watchCount,
    'lastWatched': lastWatched,
  });
  // .add({
  // "uid":uid,
  //   "ad_id":ads_id,
  //   "watchCount":watchedcount
  // });
}
  savecompleteAdsWatched({required String uid, required String ads_id,required pointget})async{
    firebaseFirestore.collection("BonscompleteAdd").doc(ads_id+uid).set({
      "uid":uid,
      "ad_id":ads_id,
      "pointget":pointget,
      'lastdatewatched':DateTime.now(),
    });
    await FirebaseFirestore.instance.collection('adswatchedComplete').doc(uid+ads_id).delete();
  }
  saveUserMessage({required title,required messages,required phoneNumber})
  {
    firebaseFirestore.collection("messages").doc(auth.currentUser!.uid).set({
      "uid": auth.currentUser!.uid,
      'mobileno':phoneNumber,
      "timeStamp":Timestamp.now(),
      "title":title,
      "messages": messages
    });
  }
  updateProfile({required name,required email,required address,context,contectNum}){
    bool response=true;
    firebaseFirestore.collection('users').doc(auth.currentUser!.uid).update({
      'address':address,
      'email':email,
      'phoneNumber':contectNum,
      'name':name,
      // 'email':des
      // 'address':heading,
      // 'email':des
    }).whenComplete(() {
      response= false;
      Get.snackbar("Profile Updated", "Profile Updated Successfully");
      Get.to(TabLayouts());
      // Navigator.pop(context);
    });
    return response;
  }
}