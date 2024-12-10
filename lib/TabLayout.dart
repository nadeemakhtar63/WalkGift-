import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:walkagift/ContectSCreen.dart';
import 'package:walkagift/FAQScreen.dart';
import 'package:walkagift/FootstepTest.dart';
import 'package:walkagift/GiftsScreen.dart';
// import 'package:walkagift/HealthCard.dart';
import 'package:walkagift/SettingScreen/ProfileScreen.dart';
import 'package:walkagift/TabLayout/Bouns.dart';
import 'package:walkagift/TabLayout/HomeScreen.dart';
import 'package:walkagift/TabLayout/Profile.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:walkagift/TabLayout/Reword.dart';
import 'package:walkagift/constant.dart';
import 'package:get/get.dart';
import 'package:walkagift/Controller/Controllers.dart';

class TabLayouts extends StatefulWidget {
  final gamename, gImage;
  const TabLayouts({Key? key, this.gamename, this.gImage}) : super(key: key);
  @override
  State<TabLayouts> createState() => _HomeNavState();
}
class _HomeNavState extends State<TabLayouts> {
  // final MyControllers stepsController = Get.put(MyControllers());
  String imageads = '';
  int steps = 0;
  double previousPoints = 0;
  bool isAdmin = true;
  late TextEditingController nameController;
  bool adresvalidate = false;
  late String name = "", image = '', email = '', address = '',token='';
  int _selectedIndex = 2;

  Future<int> getfootsteps() async {
    int userSteps = 0;
    if (auth.currentUser?.uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userData =
        await firebaseFirestore.collection('steps').doc(auth.currentUser!.uid).get();
        if (userData.exists) {
          userSteps = userData.data()?['steps'] ?? 0;
          // Get.snackbar("Valuesl footsteps", userSteps.toString());
        } else {
          print('User data does not exist');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('User is not signed in');
    }
    return userSteps;
  }

  Future<void> userdataGet() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: auth.currentUser!.uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference userRef = querySnapshot.docs.first.reference;
      setState(() {
        previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
        name = (querySnapshot.docs.first.data() as Map<String, dynamic>)['name'] ?? '';
        email = (querySnapshot.docs.first.data() as Map<String, dynamic>)['email'] ?? '';
        image = (querySnapshot.docs.first.data() as Map<String, dynamic>)['userimage'] ?? '';
        address = (querySnapshot.docs.first.data() as Map<String, dynamic>)['address'] ?? '';
        token = (querySnapshot.docs.first.data() as Map<String, dynamic>)['token'] ?? '';
      });
      print('token is: $token');

    } else {
      print('User document not found for current user');
    }
  }
  String adImage="";
  void showConfirmDialog(BuildContext context, String errorMessage) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          content: Text(
            errorMessage,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Accept',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                exit(0);
              },
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        );
      },
    );
  }
  Future<void> getImageAnnoucement() async {
    sendPushNotification(token, 'body', 'title');
    try {
      // Retrieve the last document from the 'imageAnnouceShow' collection
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('imageAnnouceShow')
          .orderBy('timefram', descending: true) // Assuming there's a timestamp field to get the last uploaded image
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          adImage = querySnapshot.docs.first.data()['image'] ?? '';
          print(adImage);
        });

        if (adImage.isNotEmpty) {
          Timer(Duration(seconds: 2), () => showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Row(
                    children: [
                      Expanded(child: Container()),
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          icon: Icon(Icons.cancel_outlined,color: Colors.red,))
                    ],
                  ),
                  content: Image.network(adImage, fit: BoxFit.cover),
                );
              }
          ));
        }
      } else {
        print('No image announcements found.');
      }
    } catch (e) {
      print('Error getting image announcement: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    userdataGet();
    getImageAnnoucement();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getfootsteps(), // Fetch steps
      builder: (context, snapshot) {
        // While waiting for the future to complete, show a progress indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          steps = snapshot.data ?? 0; // Assign the fetched steps
          return Scaffold(
            drawer: Drawer(
              backgroundColor: Color(0xff567a93),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Color(0xff567a93),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(image),
                        ),
                        Text(name)
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(UserProfileScreen(
                                // points: previousPoints,
                                // name: name,
                                // email: email,
                                // address: address,
                                // image: image,
                              ));
                            },
                            child: Card(
                              color: Color(0xff567a93),
                              elevation: 1,
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Profile"),
                                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => BounsScreen(totalfootsteps: steps));
                            },
                            child: Card(
                              color: Color(0xff567a93),
                              elevation: 1,
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.add_shopping_cart_sharp),
                                    title: Text("Orders"),
                                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Color(0xff567a93).withOpacity(0.1),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height * 0.5,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 45),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 5,
                                            child: Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context).size.height * 0.14,
                                              decoration: BoxDecoration(
                                                color: Color(0xff567a93),
                                                border: Border.all(color: Colors.blue),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: TextField(
                                                controller: nameController,
                                                keyboardType: TextInputType.multiline,
                                                textInputAction: TextInputAction.newline,
                                                minLines: 1,
                                                maxLines: 4,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Color(0xff567a93),
                                                  errorText: adresvalidate ? "*Required Correct Address" : null,
                                                  hintText: 'e.g. city address, street address, house no',
                                                  hintStyle: TextStyle(color: Color(0xffFF7D00)),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Color(0xff567a93),
                                          elevation: 10.0,
                                          child: Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              color: Color(0xff567a93),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Center(
                                              child: Text(
                                                "UPDATE",
                                                style: TextStyle(fontWeight: FontWeight.w900),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 1,
                              color: Color(0xff567a93),
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.location_on),
                                    title: Text("Address"),
                                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            color: Color(0xff567a93),
                            elevation: 1,
                            child: Container(
                              height: 70,
                              child: Center(
                                child: ListTile(
                                  leading: Icon(Icons.data_thresholding_sharp),
                                  title: Text("Data"),
                                  trailing: Icon(Icons.arrow_forward_ios_sharp),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Share.share('share app with your friends: https://play.google.com/com.example.walk_gift');
                            },
                            child: Card(
                              elevation: 1,
                              color: Color(0xff567a93),
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.share),
                                    title: Text("Invite Friends"),
                                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => FAQScreen());
                            },
                            child: Card(
                              color: Color(0xff567a93),
                              elevation: 1,
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.question_mark),
                                    title: Text("FAQs"),
                                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ContectScreen());
                            },
                            child: Card(
                              color: Color(0xff567a93),
                              elevation: 1,
                              child: Container(
                                height: 70,
                                child: Center(
                                  child: ListTile(
                                    leading: Icon(Icons.contact_mail_outlined),
                                    title: Text("Contact Us"),
                                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                showConfirmDialog(context, 'Close the app?');
                return false;
              },
              child: Center(
                child: getWidgetOptions().elementAt(_selectedIndex),
              ),
            ),
            bottomNavigationBar: ConvexAppBar(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xffbecfd8),
                  Color(0xff6a91a9),
                  Color(0xff567a93),
                  Color(0xff8cabc0),
                ],
              ),
              height: 60,
              items: [
                TabItem(icon: Icons.gif_box_outlined, title: 'Gifts'),
                TabItem(icon: Icons.add_card, title: 'Rewards'),
                TabItem(icon: Icons.home, title: 'Home'),
                TabItem(icon: Icons.add_shopping_cart_sharp, title: 'Orders'),
                TabItem(icon: Icons.people, title: 'Profile'),
              ],
              backgroundColor: Color(0xff567a93),
              elevation: 0,
              shadowColor: Color(0xff6a91a9),
              initialActiveIndex: _selectedIndex,
              onTap: (int i) {
                setState((){
                  _selectedIndex = i;
                });
              },
            ),
          );
        }
      },
    );
  }
  List<Widget> getWidgetOptions() {
    return [
      GiftScreen(totalfootsteps: steps),
      BounsScreen(totalfootsteps: steps),
      HomeScreen(totalfootsteps: steps),
      RewordScreen(totalfootsteps: steps),
      ProfileScreen(totalfootsteps: steps),
    ];
  }
}
