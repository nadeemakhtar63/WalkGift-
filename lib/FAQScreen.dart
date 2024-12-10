import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:walkagift/Controller/Controllers.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("FAQ"),
        centerTitle: true,
        foregroundColor: Color(0xff567a93),
      ),
      body: GetX<MyControllers>(
          init:Get.put<MyControllers>(MyControllers()),
          builder:(MyControllers controllers){
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: controllers.FAQListgeter.length,
                    itemBuilder: (context, items) {
                      final allitesm = controllers.FAQListgeter[items];
                      // Check if the current item is already present in BonscompleteAdd collection
                      return  InkWell(
                        onTap: () {

                        },
                        child:ExpansionTile(
                          title: Text(allitesm.heading!=null?allitesm.heading!:"",style: TextStyle(
                              fontSize: 18,fontWeight: FontWeight.w900
                          ),),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(child: Text(allitesm.description!=null?allitesm.description!:"")),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
      ),
    );
  }
}
