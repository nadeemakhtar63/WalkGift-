import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';

class ContectScreen extends StatefulWidget {
  const ContectScreen({super.key});

  @override
  State<ContectScreen> createState() => _ContectScreenState();
}

class _ContectScreenState extends State<ContectScreen> {
  late TextEditingController titleController=new TextEditingController();
  late TextEditingController messageController=new TextEditingController();
  late TextEditingController contectController=new TextEditingController();
  bool titlevalidate=false;
  bool messagevalidate=false;
  bool contectvalidate=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor:  Color(0xff567a93),
      appBar: AppBar(
        backgroundColor:  Color(0xff567a93),
        title: Text("Contect Screen"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

                    controller: titleController,
                    // keyboardType: TextInputType.multiline,
                    // textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.edit),
                      filled: true,
                      // fillColor: Color(0xff567a93),
                      errorText: titlevalidate?"*Title":null,
                      hintText: 'Title of Message',
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
           //           color: Color(0xff567a93),
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.45,
                  decoration: BoxDecoration(
                    // color:  Color(0xff567a93),
                    border: Border.all(color: Color(0xff567a93)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(

                    controller: messageController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 45,
                    decoration: InputDecoration(
                      filled: true,
                      // fillColor: Color(0xff567a93),
                      errorText: messagevalidate?"*Enter Message":null,
                      hintText: 'Enter your message',
                      // prefixIcon: Icon(Icons.message_outlined, color: Colors.blue,),
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
              onTap: (){
                if(titleController.text.isEmpty||messageController.text.isEmpty||contectController.text.isEmpty)
                  {
                   setState(() {
                     contectController.text.isEmpty?contectvalidate=true:contectvalidate=false;
                     titleController.text.isEmpty?titlevalidate=true:titlevalidate=false;
                     messageController.text.isEmpty?messagevalidate=true:messagevalidate=false;
                   });
                  }
                else{
                  FirebaseCrud().saveUserMessage(title: titleController.text,messages: messageController.text,phoneNumber:contectController.text);
                  Navigator.pop(context);
                  Get.snackbar("","Message Sent Successfully");
                }

              },
              child: Card(
                color:Color(0xff567a93),
                elevation: 10.0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color:Color(0xff567a93),
                      borderRadius: BorderRadius.circular(20)
                  ),

                  width: MediaQuery.of(context).size.width*0.4,
                  child: Center(child: Text("Send Message",style: TextStyle(fontWeight: FontWeight.w900),),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
