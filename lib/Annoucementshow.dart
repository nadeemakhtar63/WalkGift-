import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';
import 'package:walkagift/TabLayout/HomeScreen.dart';

class AnnoucementShow extends StatefulWidget {
  const AnnoucementShow({super.key});

  @override
  State<AnnoucementShow> createState() => _AnnoucementShowState();
}

class _AnnoucementShowState extends State<AnnoucementShow> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(),
      body:       Expanded(
        child: GetX<MyControllers>(
            init:Get.put<MyControllers>(MyControllers()),
            builder:(MyControllers controllers){
              return ListView.builder(
                itemCount: controllers.annoucementgeter.length,
                itemBuilder: (context, items) {
                  final allitesm = controllers.annoucementgeter[items];
                  // adImage=controllers.annoucementgeter[0].adsImage!;
                  // Check if the current item is already present in BonscompleteAdd collection
                  return  InkWell(
                      onTap: () {
                        AlertDialog(
                            content: Image.network(allitesm.adsImage!,fit: BoxFit.cover,
                              // height:MediaQuery.of(context).size.height*0.7,
                            )
                        );
                      },
                      child: BounsCard(allitesm: allitesm)
                  );
                },
              );
              // return ListView.builder(
              //   // shrinkWrap: true,
              //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //   //   crossAxisCount: 2,
              //   //   crossAxisSpacing: 3.0,
              //   //   mainAxisSpacing: 5.0,
              //   // ),
              //     itemCount: controllers.bounsDataList.length,
              //     itemBuilder: (context,items){
              //     final allitesm=controllers.bounsDataList[items];
              //     return InkWell(
              //       onTap: (){
              //         // Get.to(()=>BounsScreen());
              //       },
              //       child: Stack(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(top: 8.0),
              //             child: Card(
              //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //               // child: Container(
              //               //   width: double.infinity,
              //               //   decoration: BoxDecoration(
              //               //
              //               //     image: DecorationImage(image:  NetworkImage(allitesm.adsimage!),fit: BoxFit.cover)
              //               //   ),
              //               //   height: 130,
              //             // child:
              //             // Container(
              //             //   color: Colors.blueGrey.withOpacity(0.5),
              //             //   child: Center(
              //             //     child:Image(image: AssetImage('assets/playIcon.png'),height: 45,width: 45,) ,
              //             //   ),
              //             // ),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.end,
              //                   crossAxisAlignment: CrossAxisAlignment.end,
              //                   children: [
              //                Column(
              //                       children: [
              //
              //                         Container(
              //                           width: double.infinity,
              //                           decoration: BoxDecoration(
              //                               borderRadius: BorderRadius.circular(10),
              //                               image: DecorationImage(image:  NetworkImage(allitesm.adsimage!),fit: BoxFit.cover)
              //                           ),
              //                           height: 90,
              //                         ),
              //                         Align(
              //                             alignment: Alignment.center,
              //                             child: Text(allitesm.title!,style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 16,fontWeight: FontWeight.w900),)),
              //                         Align(
              //                             alignment: Alignment.center,
              //                             child: Text(allitesm.subTitle!,style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 14,fontWeight: FontWeight.w400),))
              //                       ],
              //                     ),
              //
              //                   ]
              //                 ),
              //               ),
              //             ),
              //           // ),
              //           // Positioned(
              //           //   top: -10,
              //           //     left: 0,
              //           //     right: 0,
              //           //     child: Image(image: AssetImage('assets/playIcon.png'),height: 45,width: 45,)),
              //           // Column(
              //           //   mainAxisAlignment: MainAxisAlignment.end,
              //           //   crossAxisAlignment: CrossAxisAlignment.end,
              //           //   children: [
              //           //     Container(
              //           //       child: Column(
              //           //         children: [
              //           // Positioned(
              //           //     bottom: 0,
              //           // left: 0,
              //           // right: 0,
              //           // child: Column(
              //           //   children: [
              //           //     Text(allitesm.title!,style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 16,fontWeight: FontWeight.w900),),
              //           //     Text(allitesm.subTitle!,style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 14,fontWeight: FontWeight.w400),)
              //           //   ],
              //           // ))
              //                 // ],
              //                 // ),
              //               // ),
              //           //   ],
              //           // ),
              //         ],
              //       ),
              //     );
              //     },
              // );
            }

        ),
      )
    );
  }
}
