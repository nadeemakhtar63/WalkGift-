import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:walkagift/ContectSCreen.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:walkagift/FAQScreen.dart';
import 'package:walkagift/ModelClasses/ProfileModel.dart';
import 'package:walkagift/SettingScreen/ProfileScreen.dart';
import 'package:walkagift/TabLayout.dart';
import 'package:walkagift/TabLayout/Bouns.dart';
import 'package:walkagift/TabLayout/Reword.dart';
import 'package:walkagift/constant.dart';
import 'package:share_plus/share_plus.dart';
class ProfileScreen extends StatefulWidget {
  int totalfootsteps;
   ProfileScreen({super.key,required this.totalfootsteps});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MyControllers userController = Get.put(MyControllers());
  //  String name='',image='',email='',address="";
  // double previousPoints=0;
  int myorders=0;
  initState(){
    super.initState();
    nameController = TextEditingController(text: '');
    userController.fetchUserData();
    // userdataGet();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = userController.userModel.value;
      if (user != null) {
        nameController.text = user.name ?? '';
        // emailController.text = user.email ?? '';
        nameController.text = user.address ?? '';
      }
    });
  }
  // userdataGet()async{
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: auth.currentUser!.uid).get();
  //   if (querySnapshot.docs.isNotEmpty) {
  //     // Get the reference to the first document (assuming there's only one match)
  //     DocumentReference userRef = querySnapshot.docs.first.reference;
  //     setState(() {
  //       previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
  //       name=(querySnapshot.docs.first.data() as Map<String, dynamic>)['name'] ?? '';
  //       email=(querySnapshot.docs.first.data() as Map<String, dynamic>)['email'] ?? '';
  //       image=(querySnapshot.docs.first.data() as Map<String, dynamic>)['userimage'] ?? '';
  //       address=(querySnapshot.docs.first.data() as Map<String, dynamic>)['address'] ?? '';
  //       myorders=(querySnapshot.docs.first.data() as Map<String, dynamic>)['myorders'] ?? '';
  //     });
  //     print(image);
  //     // print('Points updated successfully! New total points: $newPoints');
  //   } else {
  //     print('User document not found for current user');
  //   }
  //   // }
  //   // catch (e) {
  //   // print('Error updating points: $e');
  //   // }
  // }
  late TextEditingController nameController;
  bool adresvalidate=false;
  bool updatesucessbool=false;
  @override
  Widget build(BuildContext context) {

    // nameController=TextEditingController(text: userController.u);
    return Scaffold(
        // backgroundColor: Color(0xff567a93),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff567a93),
        elevation: 0.0,
        leading: IconButton(
            onPressed: (){
              Get.offAll(()=>TabLayouts());
            },
            icon:Icon(Icons.arrow_back)),
      ),
      body:Obx(() {
        final user = userController.userModel.value;
        return user != null
            ? Column(
          children: [
            Card(
              elevation: 2,
              // color:Color(0xff567a93),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  // color:Color(0xff567a93),
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.9,
                child: ListTile(
                  title: Text(user.name!??""),
                  subtitle: Text(user.points==null?"0":user.points!.toStringAsFixed(3),
                    style: TextStyle(fontSize: 18),),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children:
                  //   [
                  //     // Image(image: AssetImage("assets/goldinimage.png"),height: 35,width: 35,),
                  //     Text(previousPoints.toStringAsFixed(3),style: TextStyle(fontSize: 18),),
                  //   ],
                  // ),
                  leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                          ? NetworkImage(user.profileImage!)
                          : null,
                    child: user.profileImage == null || user.profileImage!.isEmpty
                        ? Icon(Icons.person)
                        : null,
                  ),

                  // trailing: Image(image: AssetImage("assets/goldinimage.png"),height: 45,width: 45,)
                ),
              ),
            ),
            Container(
              height: 90,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.run_circle_outlined),
                          Text('Steps\n${widget.totalfootsteps}')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('assets/coins.png',height: 35,width: 35,),
                          // Icon(Icons.signal_cellular_connected_no_internet_4_bar_sharp),
                          Text('WGC\n${user.points==null?"0":user.points!.toStringAsFixed(3)}')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart_sharp),
                          Text('Orders', style: TextStyle(fontSize: 11),),
                          Text(user.myOrders.toString(),
                            style: TextStyle(fontSize: 11),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child:
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                          UserProfileScreen(
                            // points: previousPoints,
                            // name: name,
                            // email: email,
                            // address:address,
                            // // uid: '',
                            // image: image,
                          )
                      );
                    },
                    child: Card(
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text("Profile"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp)
                            // Card(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            //   elevation: 2,
                            //   child: Container(
                            //     height: 45,
                            //     width: 45,
                            //     decoration: BoxDecoration(
                            //         // borderRadius: BorderRadius.circular(30),
                            //         color: Color(0xff567a93)
                            //     ),
                            //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() =>
                          RewordScreen(totalfootsteps: widget.totalfootsteps,));
                    },
                    child: Card(
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.add_shopping_cart_sharp),
                              title: Text("Orders"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp)
                            // Card(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            //   elevation: 2,
                            //   child: Container(
                            //     height: 45,
                            //     width: 45,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30),
                            //         color: Color(0xff567a93)
                            //     ),
                            //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true, // Important for full-screen scrollable content
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.9,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                          size: 45,
                                        ),
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
                                              errorText: adresvalidate
                                                  ? "*Required Corrior Address"
                                                  : null,
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          updatesucessbool = true;
                                        });
                                        if (nameController.text.isEmpty) {
                                          adresvalidate = nameController.text.isEmpty;
                                        } else {
                                          firebaseFirestore
                                              .collection("users")
                                              .doc(auth.currentUser!.uid)
                                              .update({
                                            'address': nameController.text
                                          }).whenComplete(() {
                                            Get.snackbar(
                                              "Address Updated",
                                              "User Address Updated",
                                            );
                                          });
                                          final updatedUser = UserModel(
                                            address: nameController.text,
                                            email: user.email,
                                            name: user.name,
                                            points: user.points,
                                            profileImage: user.profileImage,
                                            myOrders: user.myOrders,
                                          );
                                          userController.userModel.value = updatedUser;
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Card(
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 1,
                      // color: Color(0xff567a93),
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Address"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp)
                            // Card(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            //   elevation: 2,
                            //   child: Container(
                            //     height: 45,
                            //     width: 45,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30),
                            //         color: Color(0xff567a93)
                            //     ),
                            //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Card(
                  //   // color: Color(0xff567a93),
                  //   elevation: 1,
                  //   child: Container(
                  //     height: 70,
                  //     child: Center(
                  //       child: ListTile(
                  //         leading: Icon(Icons.data_thresholding_sharp),
                  //         title: Text("Data"),
                  //         trailing: Icon(Icons.arrow_forward_ios_sharp)
                  //         // Card(
                  //         //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                  //         //   elevation: 2,
                  //         //   child: Container(
                  //         //     height: 45,
                  //         //     width: 45,
                  //         //
                  //         //     decoration: BoxDecoration(
                  //         //         borderRadius: BorderRadius.circular(30),
                  //         //         color: Color(0xff567a93)
                  //         //     ),
                  //         //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                  //         //   ),
                  //         // ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Share.share('share app with your friends: https://play.google.com/com.example.walk_gift');
                    },
                    child: Card(
                      elevation: 1,
                      // color: Color(0xff567a93),
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.share),
                              title: Text("Invite Friends"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp)
                            // Card(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            //   elevation: 2,
                            //   child: Container(
                            //     height: 45,
                            //     width: 45,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30),
                            //         color:Color(0xff567a93)
                            //     ),
                            //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                            //   ),
                            // ),
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
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.question_mark),
                              title: Text("FAQs"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp)
                            // Card(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            //   elevation: 2,
                            //   child: Container(
                            //     height: 45,
                            //     width: 45,
                            //
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30),
                            //         color:Color(0xff567a93)
                            //     ),
                            //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                            //   ),
                            // ),
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
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.contact_mail_outlined),
                              title: Text("Contact Us"),
                              trailing: Icon(Icons.arrow_forward_ios_sharp)
                            // Card(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            //   elevation: 2,
                            //   child: Container(
                            //     height: 45,
                            //     width: 45,
                            //
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(30),
                            //         color: Color(0xff567a93)
                            //     ),
                            //     child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ) : Container();
      }
      )
    );
  }
}
