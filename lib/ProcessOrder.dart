import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';
import 'package:walkagift/TabLayout.dart';
import 'package:walkagift/constant.dart';
import 'package:http/http.dart' as http;
class ProcessOrder extends StatefulWidget {
  String userImage;
  String username;
  String productname;
  String productId;
  String contectno;
  String productImage;
  String ProductDeatils;
  String address;
  String token;
  int? pointsproducts;
  int? numberofProducts,previousOreder;
  double mypoints;
   ProcessOrder({super.key,required this.pointsproducts,required this.contectno,
     required this.productImage,required this.productname,required this.previousOreder,
     required this.ProductDeatils,required this.mypoints,
   required this.username,required this.userImage,required this.productId,required this.token,required this.address,required this.numberofProducts});

  @override
  State<ProcessOrder> createState() => _ProcessOrderState();
}
class _ProcessOrderState extends State<ProcessOrder> {
  bool adresvalidate=false,_isLoading=false,contectbool=false;
  late TextEditingController AdressInputController=new TextEditingController(text: widget.address);
  late TextEditingController nameController=new TextEditingController(text:widget.username);
  late TextEditingController contectController=new TextEditingController(text: widget.contectno);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff567a93),please
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff567a93),
        title: Text(widget.productname),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                color: Color(0xff567a93),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height*0.14,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff5c7a8f)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style:TextStyle(color: Colors.white),
                    controller: nameController,
                    // keyboardType: TextInputType.multiline,
                    // textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      errorText: adresvalidate?"*Required Name":null,
                      hintText: 'add name here',

                      // prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,),
                      hintStyle: const TextStyle(color: Color(0xffffffff)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 1,
                color: Color(0xff567a93),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height*0.14,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff5c7a8f)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style:TextStyle(color: Colors.white),
                    controller: contectController,

                    keyboardType: TextInputType.phone,
                    // textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      errorText: contectbool?"*Required Phone No":null,
                      hintText: 'add Phone No',

                      // prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,),
                      hintStyle: const TextStyle(color: Color(0xffffffff)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                color: Color(0xff567a93),
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.14,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff7794a8)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    controller: AdressInputController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 4,
                    style:TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      errorText: adresvalidate?"*Required Corrior  Address":null,
                      hintText: 'e.g. city address,street address,house no',
                      // prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,),
                      // hintStyle: TextStyle(color: Color(0xff090000)),
                      hintStyle: const TextStyle(color: Color(0xffffffff)),

                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Card(
                  color: Color(0xff567a93),
                  elevation: 1,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width*0.4,
                    // color: Colors.deepPurple,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Points Used",style: TextStyle(color: Colors.white),),
                        Text(widget.pointsproducts.toString(),style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: Color(0xff567a93),
                  elevation: 1,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width*0.4,
                    // color: Colors.deepPurple,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("My Points",style: TextStyle(color: Colors.white),),
                      Text(widget.mypoints!.toStringAsFixed(3),style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  ),
                ),
              ],
            ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Please provide your complete address so that we can send you ,"
            " your earned gift from Walk Gift. Wishing you good health and happiness.",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18),),
              ),
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              height: 60,
              child:_isLoading?Column(
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()),
                ],
              ): Card(
                  elevation: 1,
                  color:Color(0xff567a93),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                      onTap: () {
                        // if(horlypayboool==false)
                        // {
                        if (AdressInputController.text.isEmpty
                          || contectController.text.isEmpty)
                          // || whatneedInputController.text.isEmpty)
                            {
                          setState((){
                            AdressInputController.text.isEmpty ?
                            adresvalidate = true : adresvalidate = false;
                            contectController.text.isEmpty ?
                            contectbool = true : contectbool = false;
                            // whatneedInputController.text.isEmpty ?
                            // whyneedvalidate = true : whyneedvalidate = false;
                          });
                        }
                        else {
                          setState(()
                          {
                            _isLoading = true;
                          });
                          FirebaseCrud b = new FirebaseCrud();
                          b.placeOrder(
                              phoneNumber:contectController.text.toString(),
                              token: widget.token,
                              previuseOrder: widget.previousOreder,
                              numberofProducts: widget.numberofProducts,
                              context: context,
                              userName: widget.username,
                              adress: AdressInputController.text,
                              productId: widget.productId,
                              productName: widget.productname,
                              productpoints: widget.pointsproducts
                          ).then((value) =>
                          {
                            // print('print is $value'),
                            // if(value == "sucess"){
                            //   _displayDialog(context),
                            //   setState(() {
                            //     Navigator.pop(context),
                                _isLoading = false,
                              // }),
                              // if(widget.images!=null)
                              //   {
                              // b.Bookservice(
                              //     adres: AdressInputController.text,
                              //     datepic: timingConstraintInputController.text,
                              //     morning: chooseMorning,
                              //     evening: choosEvening,
                              //     afternon: chooseAfterNoon,
                              //     timing_about_des: timingConstraintInputController.text,
                              //     which_service_want: whatneedInputController.text,
                              //     // serviceName: ,
                              //     servicesnum: _counter,
                              //     images: imaging,
                              //     scharges: 0,
                              //     stax: 0,
                              //     sduration: "",
                              //     seviceimage: ''
                              // ).then((value) =>
                              // {
                              //   print('print is $value'),
                              //   if(value == "sucess"){
                              //     _displayDialog(context),
                              //     setState(() {
                              //       _isLoading = false;
                              //     }),
                              //     // Get.to(()=>ConfirmBooking(servicepi: widget.serviceImage,adres: AdressInputController.text, afternon:"", datepic:"",
                              //     //   evening:"", morning:"",timing_about_des: timingConstraintInputController.text,
                              //     //   which_service_want: whatneedInputController.text,serviceName: widget.servicename,
                              //     //   servicesnum: _counter,images: imaging, scharges:widget.seviceCharges,
                              //     //   stax: widget.ServiceText,
                              //     //   sduration: widget.serviceDuration,));
                              //   }
                              //   // }
                              //   // else{
                              //   //   if(AdressInputController.text.isEmpty||timingConstraintInputController.text.isEmpty||
                              //   //       whatneedInputController.text.isEmpty||dateController.text.isEmpty)
                              //   //   {
                              //   //     setState(() {
                              //   //       AdressInputController.text.isEmpty?adresvalidate=true:adresvalidate=false;
                              //   //       timingConstraintInputController.text.isEmpty?timdesvalide=true:timevalidate=false;
                              //   //       whatneedInputController.text.isEmpty?whyneedvalidate=true:whyneedvalidate=false;
                              //   //       dateController.text.isEmpty?horlypayboool=true:contractbool=false;
                              //   //     });
                              //   //   }
                              //   //   // else if(chooseMorning=="" || choosEvening=="" || chooseAfterNoon=="")
                              //   //   // {
                              //   //   // Get.snackbar("Pick Frame", "Pick Frame one or More");
                              //   //   // }
                              //   //   else
                              //   //   {
                              //   //     // Get.to(()=>ConfirmBooking(servicepi:widget.serviceImage,adres: AdressInputController.text, afternon: chooseAfterNoon,
                              //   //     //   datepic: dateController.text, evening: choosEvening, morning: chooseMorning
                              //   //     //   ,timing_about_des: timingConstraintInputController.text,
                              //   //     //   which_service_want: whatneedInputController.text,
                              //   //     //   serviceName: widget.servicename,servicesnum: _counter,
                              //   //     //   images: imaging,
                              //   //     //   scharges:widget.seviceCharges,
                              //   //     //   stax: widget.ServiceText,
                              //   //     //   sduration: widget.serviceDuration,
                              //   //     // ));
                              //   //   }
                              //   // }
                              //
                              // });
                            // }
                          },
                            sendPushNotification(widget.token, "Order Placed", "Your Order Placed Successfully"),
                          );
                        }
                      },
                    child:Container(
                      width: MediaQuery.of(context).size.width*0.6,
                      height: 60,
                      child: const Center(
                        child: Text("Place Order",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.white),),
                      ),
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Text('Order Submitted',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
            content: const SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Order Submitted Successfully,admin can response to your order soon',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'please check details of order in order modules home page',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )

                ],
              ),
            ),
            actions: <Widget>[
              // new MaterialButton(
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   color: Colors.blueAccent,
              //   child: new Text('Back to OrderPage',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
              //   onPressed: () async{
              //     try
              //     {
              //       // Get.to(()=>OrderTabs());
              //       Navigator.pushReplacement(context, new MaterialPageRoute(builder:(context)=>TabLayouts()));
              //       // Navigator.of(context).pop();
              //     }
              //     catch(firebaseAuthException)
              //     {
              //       Get.snackbar("Alert".tr, "$firebaseAuthException");
              //     }
              //   },
              // ),
               MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color:Color(0xff567a93),
                child: new Text('Back to HomePage',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
                onPressed:()async{
                  try
                  {
                    // Get.to(()=>TabLayouts());
                    Navigator.pushReplacement(context, new MaterialPageRoute(builder:(context)=>TabLayouts()));
                  }
                  catch(firebaseAuthException)
                  {
                    Get.snackbar("Alert".tr, "$firebaseAuthException");
                  }
                },
              ),
            ],
          );
        });
  }
  // void sendPushNotification(String? token,String body,String title)async
  // {
  //   print("Your Givin Token is$token");
  //   try {
  //     final response=   await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'content-type': 'application/json',
  //         'Authorization': 'key=AAAAiXKVKMk:APA91bH53DuBtqsBTh6We9IMQjrC7e5Z8kSsuy2l_f8X9wWGsGNeMx8HxM6Tb2zy0y4_XGFNv3Xr5ClcF4rrmvvt5Iw7yR13l0PsyM--WFH3qRmQFQ_fuWhwFoPtlPTLHxc-0NSnQ6zN'
  //       },
  //       body: jsonEncode(
  //           <String, dynamic>{
  //             'priority': 'high',
  //             'data': <String, dynamic>{
  //               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //               'status': 'done',
  //               'body': body,
  //               'title': title
  //             },
  //             "notification":<String,dynamic>{
  //               "title":title,
  //               "body":body,
  //               "android_channel_id":"abcd"
  //             },
  //             "to":token
  //           }
  //           ),
  //     );
  //     if (response.statusCode == 200) {
  //       print('test ok push CFM');
  //       // return true;
  //     } else {
  //       print(' CFM error');
  //       print(response.statusCode);
  //       // return false;
  //     }
  //   }
  //   catch(firebaseAuthException)
  //   {
  //     print('reasun for why notification${firebaseAuthException.toString()}');
  //   }
  // }
}
