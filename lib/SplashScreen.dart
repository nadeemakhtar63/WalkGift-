import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:walkagift/GiftsScreen.dart';
import 'package:walkagift/TabLayout.dart';
import 'package:walkagift/welcomscreen.dart';
import 'package:walkagift/Controller/Controllers.dart';
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final MyControllers stepsController = Get.put(MyControllers());
  // String dotCoderLogo = 'https://raw.githubusercontent.com/OsamaQureshi796/MealMonkey/main/assets/dotcoder.png';
  @override
  void initState() {
    // requestPermission();
    // initInfo();
    // getToken();
    // TODO: implement initState
    super.initState();
  }
  void requestPermission()async{
    FirebaseMessaging messaging=FirebaseMessaging.instance;
    NotificationSettings settings=await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );
    print("permission");
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("user garanted permission");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
    {
      print("user garanted provisional permission");
    }
    else
    {
      print("user denied and not grant any  permission");
    }
  }
  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    // if(user.isNull){
    //   Timer(Duration(seconds: 5),()=> Get.offAll(()=>WelcomScreen()));
    //
    // }else{
    //   Timer(Duration(seconds: 5),()=> Get.offAll(()=>TabLayouts()));
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.8,
            decoration: BoxDecoration(
              image: DecorationImage(image:AssetImage('assets/welcomscreen.png',),fit: BoxFit.cover),
            ),
          ), 
          Expanded(
            child: Column(
              children: [
                Text("Welcome To Walk Gift",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900,color: Colors.black),),
            
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    onTap: (){
                      Get.to(WelcomScreen());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1,color: Colors.white10),
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      child: Center(child: Text("Sign Up",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.black),)),
                    ),
                  ),
                ),
                // InkWell(
                //     onTap: (){
                //       // Get.to(()=>login());
                //     },
                //     child: Text("Already have an account",style: TextStyle(color: Color(0xff567a93),fontSize: 18),)),
                //   Text("FCM by DOTCODER")
            //
              ],
            ),
          ),
        ],
      ),
    );
  }
}
