import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';
import 'package:walkagift/ModelClasses/annoucementModelClass.dart';

class AnnoucemntsDisplay extends StatefulWidget {
  const AnnoucemntsDisplay({super.key});

  @override
  State<AnnoucemntsDisplay> createState() => _AnnoucemntsDisplayState();
}

class _AnnoucemntsDisplayState extends State<AnnoucemntsDisplay> {
  File? _image;
  bool btnCheckbool = false;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        // backgroundColor: Color(0xff567a93),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xff567a93),
          onPressed: (){
           // Get.to(()=>AddnewAnnoucement());
            // Get.to(()=>
            // ProcessOrder(
            //   token:token,
            //   productId: widget.productId,
            //   userImage: image,
            //   username: name,
            //   productImage: widget.productname,
            //   productname: widget.productname,
            //   ProductDeatils:widget.ProductDeatils,
            //   mypoints: previousPoints,
            //   pointsproducts:widget.pointsproducts,)
            // );
          }, label: const Text("Add New Announcement",style: TextStyle(color: Colors.white,fontSize: 16),),
          icon: Icon(Icons.add,color: Colors.white,),),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor:Color(0xff567a93),
          title: const Text("Announcement"),
          centerTitle: true,
        ),
        body:  Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GetX<MyControllers>(
                      init:Get.put<MyControllers>(MyControllers()),
                      builder:(MyControllers controllers){
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: controllers.annoucementgeter.length,
                                itemBuilder: (context, items) {
                                  final allitesm = controllers.annoucementgeter[items];
                                  // Check if the current item is already present in BonscompleteAdd collection
                                  return  InkWell(
                                      onTap: () {

                                      },
                                      child: BounsCard(allitesm: allitesm)
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                ),
              ],
            ),
          ],
        )

    );
    //   Scaffold(
    // appBar: AppBar(),
    //   body:
    //   // Column(
    //   //   children: [
    //   //     // _image.isNull?
    //   //     Expanded(
    //   //       child: Padding(
    //   //         padding: const EdgeInsets.all(8.0),
    //   //         child: GetX<MyControllers>(
    //   //               init:Get.put<MyControllers>(MyControllers()),
    //   //             builder:(MyControllers controllers){
    //   //             return controllers.annoucementgeter.length==0?Column(
    //   //               mainAxisAlignment: MainAxisAlignment.center,
    //   //               crossAxisAlignment: CrossAxisAlignment.center,
    //   //               children: [
    //   //                 Align(
    //   //                     alignment: Alignment.center,
    //   //                     child: CircularProgressIndicator()),
    //   //               ],
    //   //             ): InkWell(
    //   //
    //   //             onTap: () {
    //   //
    //   //             },
    //   //             child: Card(
    //   //             elevation: 20,
    //   //             child: Container(
    //   //
    //   //             decoration: BoxDecoration(
    //   //             image: DecorationImage(image: NetworkImage(controllers.annoucementgeter[0].adsImage!),fit: BoxFit.cover)
    //   //             ),
    //   //             child: Align(
    //   //             alignment: Alignment.topRight,
    //   //             child:  PopupMenuButton(
    //   //             // color: Colors.transparent,
    //   //             elevation: 0.0,
    //   //             icon: Container(
    //   //             color: Colors.red,
    //   //             child: Icon(Icons.more_horiz,color: Colors.white)), // add this line
    //   //             itemBuilder: (_) => <PopupMenuItem<String>>[
    //   //             new PopupMenuItem<String>(
    //   //             child: Container(
    //   //             // decoration: BoxDecoration(
    //   //             //   borderRadius: BorderRadius.circular(5),
    //   //             //   border: Border.all(color: Colors.black12)
    //   //             // ),
    //   //             //   width: 120,
    //   //             // height: 15,
    //   //             // height: 30,
    //   //             child: ListTile(
    //   //             leading: Icon(Icons.delete),
    //   //             title: Text("Delete"),
    //   //             )), value: 'Delete'),
    //   //
    //   //             ],
    //   //             onSelected: (index) async {
    //   //             switch (index) {
    //   //             case 'Delete':
    //   //             FirebaseCrud c=new FirebaseCrud();
    //   //             c.deleteAdAnnouc(itemid: controllers.annoucementgeter[0].id!);
    //   //             break;
    //   //             }
    //   //             })
    //   //             // IconButton(
    //   //             //   onPressed: (){
    //   //             //
    //   //             //   },
    //   //             //   icon:Icon(Icons.more_horiz_outlined,size:35,color: Colors.white,)),
    //   //             ),
    //   //             ),
    //   //             )
    //   //             );
    //   //             },
    //   //             ),
    //   //       )):
    //   //     Card(
    //   //       elevation: 2,
    //   //       child: Container(
    //   //         width:  MediaQuery.of(context).size.height*0.8,
    //   //         height: MediaQuery.of(context).size.height*0.3,
    //   //         decoration:BoxDecoration(
    //   //           image: DecorationImage(image: FileImage(_image!),fit: BoxFit.cover)
    //   //         ),
    //   //       ),
    //   //     ),
    //   //     InkWell(
    //   //       onTap: (){
    //   // if (_image == null) {
    //   //   Get.snackbar("Image Not Select", "Choose Ad Image");
    //   // }
    //   // else {
    //   //
    //   // }
    //   //       },
    //   //       child:
    //   //       // _image.isNull? InkWell(
    //   //       // onTap: (){
    //   //       //   pickAndCheckImageSize();
    //   //       // },
    //   //       //
    //   //       //   child: Card(
    //   //       //     color:Color(0xff567a93),
    //   //       //     elevation: 10.0,
    //   //       //     child: Container(
    //   //       //       height: 45,
    //   //       //       decoration: BoxDecoration(
    //   //       //           color:Color(0xff567a93),
    //   //       //           borderRadius: BorderRadius.circular(20)
    //   //       //       ),
    //   //       //
    //   //       //       width: MediaQuery.of(context).size.width*0.4,
    //   //       //       child: Center(child: Text("Select Image",style: TextStyle(fontWeight: FontWeight.w900),),),
    //   //       //     ),
    //   //       //   ),
    //   //       // ):
    //   //       InkWell(
    //   //         onTap: (){
    //   //           setState(() {
    //   //             btnCheckbool=true;
    //   //           });
    //   //         bool response=  FirebaseCrud().imageAnnouceadShow(imageis: _image, context: context);
    //   //         setState(() {
    //   //           btnCheckbool=response;
    //   //         });
    //   //
    //   //         },
    //   //         child:btnCheckbool?CircularProgressIndicator(): Card(
    //   //           color:Color(0xff567a93),
    //   //           elevation: 10.0,
    //   //           child: Container(
    //   //             height: 45,
    //   //             decoration: BoxDecoration(
    //   //                 color:Color(0xff567a93),
    //   //                 borderRadius: BorderRadius.circular(20)
    //   //             ),
    //   //
    //   //             width: MediaQuery.of(context).size.width*0.4,
    //   //             child: Center(child: Text("Upload",style: TextStyle(fontWeight: FontWeight.w900),),),
    //   //           ),
    //   //         ),
    //   //       ),
    //   //     ),
    //   //   ],
    //   // ),
    // );
  }
}
  class BounsCard extends StatelessWidget {
    final AnnoucementDisplayModel allitesm;

    const BounsCard({Key? key, required this.allitesm}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Container(
        child: Card(
          elevation: 5,
          // color: Color(0xff567a93),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(allitesm.adsImage!),
                      fit: BoxFit.cover),
                ),
                width: double.infinity,
                // child: Align(
                //     alignment: Alignment.topRight,
                //     child: PopupMenuButton(
                //       // color: Colors.transparent,
                //         elevation: 0.0,
                //         icon: Container(
                //             color: Colors.red,
                //             child: Icon(Icons.more_horiz, color: Colors.white)),
                //         // add this line
                //         itemBuilder: (_) =>
                //         <PopupMenuItem<String>>[
                //           new PopupMenuItem<String>(
                //               child: Container(
                //                 // decoration: BoxDecoration(
                //                 //   borderRadius: BorderRadius.circular(5),
                //                 //   border: Border.all(color: Colors.black12)
                //                 // ),
                //                 //   width: 120,
                //                 // height: 15,
                //                 // height: 30,
                //                   child: ListTile(
                //                     leading: Icon(Icons.delete),
                //                     title: Text("Delete"),
                //                   )), value: 'Delete'),
                //           // new PopupMenuItem<String>(
                //           //     child: Container(
                //           //       // decoration: BoxDecoration(
                //           //       //   borderRadius: BorderRadius.circular(5),
                //           //       //   border: Border.all(color: Colors.black12)
                //           //       // ),
                //           //       //   width: 120,
                //           //       // height: 15,
                //           //       // height: 30,
                //           //         child: ListTile(
                //           //           leading: Icon(Icons.edit),
                //           //           title: Text("Edit"),
                //           //         )), value: 'Edit'),
                //
                //         ],
                //         onSelected: (index) async {
                //           switch (index) {
                //             case 'Delete':
                //               FirebaseCrud c = new FirebaseCrud();
                //               c.deleteAd(itemid: allitesm.id!);
                //               break;
                //             case 'Edit':
                //               break;
                //           }
                //         })
                //   // IconButton(
                //   //   onPressed: (){
                //   //
                //   //   },
                //   //   icon:Icon(Icons.more_horiz_outlined,size:35,color: Colors.white,)),
                // ),
              ),
              // Column(
              // children: [
              // Text(
              // allitesm.title!,
              // style: const TextStyle(overflow: TextOverflow.ellipsis),
              // ),
              // Text(
              // allitesm.subTitle!,
              // style: const TextStyle(overflow: TextOverflow.ellipsis),
              // ),
              // ],
              // ),
            ],
          ),
        ),
      );
    }
  }
