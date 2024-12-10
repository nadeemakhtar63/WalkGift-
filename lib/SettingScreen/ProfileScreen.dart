import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';

import '../ModelClasses/ProfileModel.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserProfileScreen> {
  final MyControllers userController = Get.put(MyControllers());
  late TextEditingController addressInputController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController contectController;
  bool nameBool = false, emailBool = false, addressBool = false, btnProgressBar = false;
  bool contectvalidate=false;
  @override
  void initState() {
    super.initState();
    // phoneNumber
    // Initialize the TextEditingController with empty values initially
    addressInputController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    contectController=new TextEditingController();
    addressInputController.text='';
    // Set the initial values from the user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = userController.userModel.value;
      if (user != null) {
        nameController.text = user.name ?? '';
        emailController.text = user.email ?? '';
        contectController.text=user.phoneNumber??"";
        addressInputController.text = user.address ?? '';
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    addressInputController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff567a93),
        elevation: 0.0,
      ),
      body: Obx(() {
        final user = userController.userModel.value;

        if (user == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(user.profileImage??""),
                    ),
                  ),
                  Text(user.name!??""),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 90,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset('assets/coins.png',height: 35,width: 35,),
                                  // Icon(Icons.coins),
                                  Text('WGC\n ${user.points==null?"0":user.points!.toStringAsFixed(3)}')
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.add_shopping_cart_sharp),
                                  Text('Orders'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          width: double.infinity,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              filled: true,
                              errorText: nameBool ? "*Name" : null,
                              hintText: 'Username',
                              hintStyle: const TextStyle(
                                  color: Color(0xffFF7D00)),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          width: double.infinity,
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              filled: true,
                              errorText: emailBool ? "*Required email" : null,
                              hintText: 'Email required',
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        child: Container(
                          width: double.infinity,
                          // height: MediaQuery.of(context).size.height*0.14,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff567a93)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            controller: contectController,
                            keyboardType: TextInputType.phone,
                            // textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 1,

                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              filled: true,
                              // fillColor: Color(0xff567a93),
                              errorText: contectvalidate?"*required Mobile Number for contact":null,
                              hintText: 'Mobile Number',
                              // prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,),
                              hintStyle: const TextStyle(color: Color(0xffFF7D00)),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 1,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: addressInputController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            filled: true,
                            errorText: addressBool ? "*Required address" : null,
                            hintText: 'e.g. city address, street address, house no',
                            hintStyle: TextStyle(color: Color(0xffFF7D00)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (nameController.text.isEmpty || emailController.text.isEmpty || addressInputController.text.isEmpty||contectController.text.isEmpty) {
                          setState(() {
                            contectController.text.isEmpty?contectvalidate=true:contectvalidate=false;
                            nameController.text.isEmpty ? nameBool = true : nameBool = false;
                            emailController.text.isEmpty ? emailBool = true : emailBool = false;
                            addressInputController.text.isEmpty ? addressBool = true : addressBool = false;
                          });
                        } else {
                          bool res = await FirebaseCrud().updateProfile( // Make sure UID is not null
                            name: nameController.text,
                            email: emailController.text,
                            contectNum: contectController.text,
                            address: addressInputController.text,

                          );
                          if (res) {
                            final updatedUser = UserModel(
                              name: nameController.text,
                              email: emailController.text,
                              phoneNumber:'${contectController.text}',
                              address: addressInputController.text,
                              points: user.points,
                              profileImage: user.profileImage,
                              myOrders: user.myOrders
                              // other fields as well...
                            );
                            userController.userModel.value = updatedUser;
                            setState(() {
                              btnProgressBar = false;
                            });
                            // Optionally, show a success message or refresh the data
                          } else {
                            // Handle the failure case, maybe show an error message
                          }
                        }
                      },
                      child: Card(
                        elevation: 1.0,
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
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
                    )

                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
