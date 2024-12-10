import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:walkagift/constant.dart';

class RewordScreen extends StatefulWidget {
  int totalfootsteps;
   RewordScreen({super.key,required this.totalfootsteps});
  @override
  State<RewordScreen> createState() => _RewordScreenState();
}
class _RewordScreenState extends State<RewordScreen> {
  bool orderAccepetdbtnbool=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff567a93) ,
        title: Text("Orders"),
        centerTitle: true,
      ),
      // backgroundColor: Color(0xff567a93),
      body: GetX<MyControllers>(
          init:Get.put<MyControllers>(MyControllers()),
          builder:(MyControllers todoController) {
            print(todoController.activeOrdergeter.length);

            return ListView.builder(
              // scrollDirection: Axis.horizontal,
                itemCount: todoController.activeOrdergeter.length,
                itemBuilder: (BuildContext context, int index) {
                  print(todoController.activeOrdergeter[index].statue);
                  print(todoController.activeOrdergeter[index].DocumentId);
                  print(todoController.activeOrdergeter[index].userId);
                  // print(auth.currentUser!.uid);
                  final _todoModel = todoController.activeOrdergeter[index];
                  if (_todoModel.isNull) {
                    return Text("No Order yet",style:TextStyle(color: Colors.black),);
                  }
                  // return Card(
                  //   child: Column(
                  //     children: [
                  //       Text(_todoModel.username)
                  //     ],
                  //   ),
                  // );
                  else {
                    return FutureBuilder(
                        future: firebaseFirestore.collection('giftProducts')
                            .doc(
                            _todoModel.productId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // return Container(
                            //     width: 30,
                            //     height: 30,
                            //     child: CircularProgressIndicator()); // Show a loading indicator while fetching data
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Text(
                                'No data found'); // Handle case when no data is found
                          }
                          // Extract product details from snapshot
                          if (snapshot.data != null) {
                            final productData = snapshot.data!.data();
                            if (productData != null) {
                              final productName = productData!['title'];
                              final productImageUrl = productData['image'];
                              print(
                                  'object  ...sss ${productData!['title']}'); // Assuming 'image' is the field containing the image URL
                              //   return Card(
                              //     elevation: 10,
                              //     child: Row(
                              //       children: [
                              //         Image.network(
                              //           productImageUrl,
                              //           height: 100, // Adjust as needed
                              //           width: 100, // Adjust as needed
                              //         ),
                              //         Text(productName),
                              //       ],
                              //     ),
                              //   );
                              // });
                              return InkWell(
                                onTap: () {
                                  //  Get.to(SubServices(idkey: _todoModel.DocumentId,));
                                },
                                child: Card(
                                    elevation: 5,
                                    // color: Color(0xff567a93),
                                    child: Container(
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.50,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.60,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.30,
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width * 0.4,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              productImageUrl),
                                                          fit: BoxFit.cover
                                                      ),
                                                      //color: Color(int.parse(_todoModel.colorr)),
                                                      borderRadius: BorderRadius
                                                          .circular(10)
                                                  ),
                                                ),
                                                SizedBox(height: 20,),
                                                Container(
                                                  child: Text(productName,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight
                                                            .w300),),
                                                ),
                                              ],
                                            ),
                                            // Image.network(_todoModel.Datepic,height: 100,width: 100,),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceAround,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(productName,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight
                                                          .w300),),
                                                Row(
                                                  children: [
                                                    Text("Status",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .w700),),
                                                    SizedBox(width: 20,),
                                                    Text(_todoModel.statue=='process'?"In Process":_todoModel.statue=='accepted'?
                                                      "With courier company":_todoModel.statue,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w900,
                                                          color: Colors.blue),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [

                                                    SizedBox(width: 20,),
                                                    Card(
                                                      elevation: 5,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(10)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showBottomSheet(
                                                              context: context,
                                                              builder: (_){
                                                                return Container(
                                                                  height: MediaQuery.of(context).size.height*0.8,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children:[
                                                                          Expanded(child: Container()),
                                                                          IconButton(onPressed: (){
                                                                            Navigator.pop(context);
                                                                          }, icon:Icon(Icons.cancel_outlined,color: Colors.red,))
                                                                        ]
                                                                      ),
                                                                      Divider(),
                                                                      // ListTile(
                                                                      //   title: Text("companyname"),
                                                                      //   trailing:Text(_todoModel.companyname) ,
                                                                      // ),
                                                                      ListTile(
                                                                        title: Text("Product"),
                                                                        trailing:Text(_todoModel.productName) ,
                                                                      ),

                                                                      ListTile(
                                                                        title: Text("Order Status"),
                                                                        trailing:Text(_todoModel.statue=='process'?"In Process":_todoModel.statue=='accepted'?
                                                                        "With courier company":_todoModel.statue,) ,
                                                                      ),
                                                                      ListTile(
                                                                        title: Text("Courier Company"),
                                                                        trailing:Text(_todoModel.companyname) ,
                                                                      ),
                                                                      ListTile(
                                                                        title: Text("Tracking Number"),
                                                                        trailing:Text(_todoModel.trackingnumber) ,
                                                                      ),
                                                                      // _todoModel.statue=='accepted'?
                                                                      // InkWell(
                                                                      //   onTap: (){
                                                                      //     Navigator.pop(context);
                                                                      //     setState(() {
                                                                      //       orderAccepetdbtnbool=true;
                                                                      //     });
                                                                      //     firebaseFirestore.collection('orderPlaced').doc(_todoModel.DocumentId).update({
                                                                      //       "statue":"received",
                                                                      //       // "companyname":detailsAdd.text,
                                                                      //       // "tracking number":trackingNumberController.text,
                                                                      //       "dateTime":DateTime.now()
                                                                      //     }).whenComplete(() {
                                                                      //       Get.snackbar("response", 'Updated');
                                                                      //
                                                                      //       // show
                                                                      //       // detailsAdd.clear();
                                                                      //       setState(() {
                                                                      //         orderAccepetdbtnbool=false;
                                                                      //       });
                                                                      //
                                                                      //     });
                                                                      //   },
                                                                      //   child: Container(
                                                                      //     height: 30,
                                                                      //     width: 140,
                                                                      //     decoration: BoxDecoration(
                                                                      //       color: Color(0xff567a93),
                                                                      //       // image: DecorationImage(
                                                                      //       //     image: NetworkImage(_todoModel.serviceImage),
                                                                      //       //     fit: BoxFit.cover
                                                                      //       // ),
                                                                      //       // color: Color(int.parse(_todoModel.colorr)),
                                                                      //         borderRadius: BorderRadius
                                                                      //             .circular(10)
                                                                      //     ),
                                                                      //     child: Center(
                                                                      //       child: Text(
                                                                      //         "Received Know",
                                                                      //         style: TextStyle(
                                                                      //             color: Colors
                                                                      //                 .white,
                                                                      //             fontWeight: FontWeight
                                                                      //                 .w700),),
                                                                      //     ),
                                                                      //   ),
                                                                      // ):Container()
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                          // Get.to(
                                                          // OrderStatues(
                                                          //   DocumentId:_todoModel.DocumentId ,
                                                          //   serviceImage:_todoModel.serviceImage ,
                                                          //   serviceName:_todoModel.serviceName ,
                                                          //   serviceid: _todoModel.serviceid,
                                                          //   adminDescription:_todoModel.adminDescription ,
                                                          //   technisionId:_todoModel.technisionId ,
                                                          //   userId: _todoModel.userId,
                                                          //   dateofcompleting: _todoModel.dateofcompleting,
                                                          //   bookingid:_todoModel.bookingid ,
                                                          //
                                                          //   // servicename: _todoModel.serviceName,
                                                          //   // seviceCharges: _todoModel.statues,
                                                          //   // serviceDuration:_todoModel.TimeFrame,
                                                          //   // ServiceText: _todoModel.serviceName,
                                                          //   // serviceImage: _todoModel.serviceImage
                                                          // )
                                                          // );
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 90,
                                                          decoration: BoxDecoration(
                                                            // color: Color(0xff567a93),
                                                            // image: DecorationImage(
                                                            //     image: NetworkImage(_todoModel.serviceImage),
                                                            //     fit: BoxFit.cover
                                                            // ),
                                                            //color: Color(int.parse(_todoModel.colorr)),
                                                              borderRadius: BorderRadius
                                                                  .circular(10)
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "Details",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .w700),),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    )
                                ),
                              );
                            }
                            else {
                              return Text("");
                            }
                          }
                          else {
                            return Column(
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.indigoAccent,)
                              ],
                            );
                          }
                        }
                    );
                  }
                }
            );
          }
      )
    );
  }
}
