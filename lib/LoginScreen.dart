import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walkagift/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _LoginscreenState();
}
bool termandConditioncheckbox=false,btnbool=false;

class _LoginscreenState extends State<login> {
  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    child:Image(image: AssetImage("assets/logo.png")),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Log In Now",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),),
                  Text("Please Login to Continue using over App",style: TextStyle(color: Colors.white),),
                  InkWell(
                    onTap: () {
                      if (termandConditioncheckbox) {
                        signInWithGoogle();
                        setState(() {
                          btnbool = true;
                        });
                      }
                      else {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                icon: Image.asset("assets/logo.png"),
                                title: Text(
                                    "Please Accept Terms and Conditions"),
                                content: Text(
                                    "Before Continue please Accept Term and Conditons first"),
                                actions: [
                                  MaterialButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text("OK"),),
                                ],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              );
                            });
                      };
                    },
                    child: btnbool?CircularProgressIndicator(color: Colors.white ,):Container(
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
                          Text("Google SignIn",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Checkbox(value: termandConditioncheckbox,
                          onChanged: (v){
                            setState(() {
                              termandConditioncheckbox=v!;
                            });
                          }),
                      RichText(
                        text: TextSpan(
                          recognizer: TapGestureRecognizer()..onTap=()=>
                              _openLink('https://docs.google.com/document/d/1MRHLEF1NfNmd0isE9d3V2XVXlRgH4iTZS_8NiYZXFJs/edit?usp=drivesdk'),
                          text: 'I agree to the term and condition',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(
                                text: '&',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo)),
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap=()=>
                                  _openLink('https://docs.google.com/document/d/1RX8XgoJ31ebAL150F1vIl9M8kezqBKFFjYU2Wj8EAUs/edit?usp=drivesdk'),
                              text: 'Privacy Policy!',style: TextStyle(color: Colors.green),),
                          ],
                        ),
                      ),
                      // Text("I agree to the term and condition & Privecy Policy",style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Text("version 1.1.0",style: TextStyle(color: Colors.white),)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
