import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walkagift/constant.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walkagift/constant.dart';
class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});
  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}
bool termandConditioncheckbox=false,btnbool=false;

class _WelcomScreenState extends State<WelcomScreen> {
  final Uri _url = Uri.parse('https://docs.google.com/document/d/1MRHLEF1NfNmd0isE9d3V2XVXlRgH4iTZS_8NiYZXFJs/edit');
  String _version = '1.0.1';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }
  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }
  // final MyControllers stepsController = Get.put(MyControllers());
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
         gradient:LinearGradient(
           begin: Alignment.topRight,
           end: Alignment.bottomLeft,
             colors: [
               Color(0xff6a91a9),
               Color(0xff567a93),
         ])
        ),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.6,
                child:Image.asset("assets/google_signin.png",)
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     CircleAvatar(
                //       radius: 60,
                //       child:Image(image: AssetImage("assets/logo.png")),
                //     ),
                //   ],
                // ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Log In Now",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),),
                    Text("Please Login to Continue",style: TextStyle(color: Colors.white),),
                     InkWell(
                      onTap:(){
                        if (termandConditioncheckbox)
                        {
                          signInWithGoogle();
                          setState((){
                            btnbool = true;
                          });
                        }
                        else {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  icon: Image.asset("assets/logo.png"),
                                  title: Text("Please Accept Terms and Conditions"),
                                  content: Text("Before Continuing Please Accept Terms and Conditions and Agree To The Privacy Policy"),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                      Navigator.pop(context);
                                    }, child: Text("OK"),),
                                  ],
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                                );
                              });
                          };
                        },
                      child: btnbool?CircularProgressIndicator(color: Colors.white ,):
                      Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1,color: Colors.white),
                          color:
                            Color(0xff567a93),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 45,
                                width: 45,
                                child: Image.asset("assets/googlelogo.png")),
                                Text("Continue with Google",style:
                                TextStyle(fontSize: 18,fontWeight: FontWeight.w900,
                                    color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Checkbox(
                            value: termandConditioncheckbox,
                            onChanged: (v){
                              setState((){
                                termandConditioncheckbox=v!;
                              });
                             }),
                        Expanded(
                          child:RichText(
                            text: TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(fontSize: 14, color: Colors.white,fontStyle: FontStyle.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap=()=>
                                        _openLink('https://docs.google.com/document/d/1MRHLEF1NfNmd0isE9d3V2XVXlRgH4iTZS_8NiYZXFJs/edit?usp=drivesdk'),
                                    text: 'term and condition',
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 14,fontStyle: FontStyle.italic)),
                                TextSpan(
                                    text: '&',
                                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 14)),

                                TextSpan(
                                  recognizer: TapGestureRecognizer()..onTap=()=>
                                      _openLink('https://docs.google.com/document/d/1RX8XgoJ31ebAL150F1vIl9M8kezqBKFFjYU2Wj8EAUs/edit?usp=drivesdk'),
                                  text: 'Privacy Policy!',style: TextStyle(color: Colors.indigo,fontSize: 14,fontStyle: FontStyle.italic),),
                              ],
                            ),
                          ),
                          // InkWell(
                          //     onTap:(){
                          //       _launchUrl();
                          //     },
                          //     child: Text("I agree to the Terms and Conditions & Privacy Policy ",
                          //       style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,decoration:TextDecoration.underline),)),
                        ),
                      ],
                    ),
                    Text('version: ${_version.toString()}',style: TextStyle(color: Colors.white,fontSize: 12),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
