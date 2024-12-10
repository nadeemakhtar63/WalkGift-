
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:walkagift/SelectedGiftDetails.dart';
class GiftScreen extends StatefulWidget {
  int totalfootsteps;
   GiftScreen({super.key,required this.totalfootsteps});
  @override
  State<GiftScreen> createState() => _GiftScreenState();
}
class _GiftScreenState extends State<GiftScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff567a93) ,
        title: Text("Gifts"),
        centerTitle: true,
      ),
      // backgroundColor:  Color(0xff567a93),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GetX<MyControllers>(
            init:Get.put<MyControllers>(MyControllers()),
            builder:(MyControllers controllers){
              return Column(
                children: [
                  // Container(
                  //   // padding: EdgeInsets.only(top: 40),
                  //   height: MediaQuery.of(context).size.height*0.23,
                  //   color: const Color(0xffD9EBF6),
                  //   child: CarouselSlider(
                  //     items: controllers.GiftsProductsget.map((item) =>
                  //         Container(
                  //           // color: Get.theme.cardColor,
                  //           width: MediaQuery.of(context).size.width,
                  //           height:  MediaQuery.of(context).size.height,
                  //           decoration: const BoxDecoration(
                  //             // borderRadius: BorderRadius.circular(40)
                  //           ),
                  //           child: InkWell(
                  //             onTap: (){
                  //               Get.to(()=>SlectedGiftDetails(
                  //                 productId: item.id!,
                  //                 mypoints: 0,
                  //                 pointsproducts: int.parse(item.pointsget!),
                  //                 ProductDeatils: item.descryption!,
                  //                 productImage:item.adsimage!,
                  //                 productname: item.title!,
                  //               ));
                  //             },
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                   image: DecorationImage(
                  //                       fit: BoxFit.cover,
                  //                       //     colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  //                     image: NetworkImage(item.adsimage!)
                  //                     // image: NetworkImage(item.adsimage!)
                  //                   )
                  //               ),
                  //               // color: Color(0xff00ffcc),
                  //               // elevation: 0,
                  //               // child: Stack(
                  //               //   children: [
                  //               //     // Padding(
                  //               //     //   padding: EdgeInsets.only(top: 20),
                  //               //     //   child: Positioned(
                  //               //     //     left: 10,
                  //               //     //     child: Container(
                  //               //     //         child: Text("GARDENING SERVICES")
                  //               //     //     ),
                  //               //     //   ),
                  //               //     // ),
                  //               //     // Positioned(
                  //               //     //   top: 40,
                  //               //     //   left: 10,
                  //               //     //   child: Container(
                  //               //     //
                  //               //     //       child: Text("Lorem ipsum dolor sit amet,\n consectetur adipiscing elit. Ut eget\n felis pharetra, bibendum eros eu")
                  //               //     //   ),
                  //               //     // ),
                  //               //     // Container(
                  //               //     //     color: Colors.blue,
                  //               //     //     child: Text("data is very")),
                  //               //     Align(
                  //               //         alignment: Alignment.centerRight,
                  //               //         child: Image.network(_foundUsers[_current]["image"],)),
                  //               //   ],
                  //               // ),
                  //             ),
                  //           ),
                  //         ),
                  //     ).toList(),
                  //     options: CarouselOptions(
                  //         height: MediaQuery.of(context).size.height,
                  //         aspectRatio: 16 / 9,
                  //         viewportFraction: 1.0,
                  //         initialPage: 0,
                  //         enableInfiniteScroll: true,
                  //         reverse: false,
                  //         autoPlay: true,
                  //         autoPlayInterval: const Duration(seconds: 3),
                  //         autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  //         autoPlayCurve: Curves.fastOutSlowIn,
                  //         enlargeCenterPage: true,
                  //         //  onPageChanged: callbackFunction,
                  //         scrollDirection: Axis.horizontal,
                  //         onPageChanged: (index, reason) {
                  //           setState(() {
                  //             // _current = index;
                  //           });
                  //         }
                  //     ),
                  //   ),
                  // ),
                       Expanded(
                      // height: MediaQuery.of(context).size.height*0.65,
                         child: GridView.custom(
                           physics: ScrollPhysics(),
                          gridDelegate: SliverStairedGridDelegate(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            startCrossAxisDirectionReversed: true,
                            pattern: [
                              StairedGridTile(0.5, 0.8),
                              StairedGridTile(0.5, 3 / 5),
                              StairedGridTile(1.0, 10 / 6),
                            ],
                          ),
                          childrenDelegate: SliverChildBuilderDelegate(
                            childCount: controllers.GiftsProductsget.length,
                                (context,index) => InkWell(
                                  onTap: (){
                                    if((controllers.GiftsProductsget[index].totalrewords!)<=0)
                                      {
                                        Get.snackbar("Products or Out of Stock", "Product is not available");
                                      }
                                    else {
                                      Get.to(() =>
                                          SlectedGiftDetails(
                                            productId: controllers
                                                .GiftsProductsget[index].id!,
                                            productquantity: controllers
                                                .GiftsProductsget[index].totalrewords,
                                            pointsproducts: int.parse(
                                                controllers
                                                    .GiftsProductsget[index]
                                                    .pointsget!),
                                            ProductDeatils: controllers
                                                .GiftsProductsget[index]
                                                .descryption!,
                                            productImage: controllers
                                                .GiftsProductsget[index]
                                                .adsimage!,
                                            productname: controllers
                                                .GiftsProductsget[index].title!,
                                          )
                                      );
                                    }
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1,color: Colors.black),
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5)),
                                        // image:controllers.GiftsProductsget[index].totalrewords!<=0? DecorationImage(
                                        //     image:AssetImage('assets/out_of_stock.png')):null
                                        // color:   Color(0xff8cabc0),
                                        // color:   Color(0xff155f75),
                                      ),
                                      // color: Colors.blueGrey,
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Card(
                                              elevation:5,
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1,color: Color(0xffbecfd8)),
                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5),
                                                    bottomLeft: Radius.circular(5)),
                                                    // color:   Color(0xff8cabc0),
                                                  color:   Color(0xff155f75),
                                                ),
                                                child: Text(controllers.GiftsProductsget[index]
                                                    .title!, style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500),),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Card(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              elevation: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                    // color:  Color(0xff567a93),
                                                    image: DecorationImage(
                                                        image: NetworkImage(controllers.GiftsProductsget[index].adsimage!),
                                                        fit: BoxFit.cover)
                                                ),
                                                child:  controllers.GiftsProductsget[index].totalrewords!<=0?
                                               Image.asset('assets/out_of_stock.png'):Container(),
                                                // child: Column(
                                                //   children: [
                                                //     Align(
                                                //       alignment: Alignment.topRight,
                                                //       child: Card(
                                                //         elevation: 10,
                                                //         child: Container(
                                                //
                                                //           padding: EdgeInsets.all(5),
                                                //           decoration: BoxDecoration(
                                                //             borderRadius: BorderRadius.circular(5),
                                                //             color: Colors.teal
                                                //           ),
                                                //           child: Text(controllers.GiftsProductsget[index]
                                                //               .title!, style: TextStyle(
                                                //               color: Colors.white,
                                                //               fontSize: 11,
                                                //               fontWeight: FontWeight.w500),),
                                                //         ),
                                                //       ),
                                                //     ),
                                                //
                                                //   ],
                                                // ),
                                                // child: ListTile(title: Text("abc"))
                                              ),
                                            ),
                                          ),
                                          // Text(controllers.GiftsProductsget[index].title!,style: TextStyle(fontSize: 16,fontWeight:
                                          // FontWeight.w900),),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(controllers.GiftsProductsget[index].subTitle!,style:
                                            TextStyle(fontSize: 16,fontWeight:FontWeight.w900),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                               ),
                           ),
                         ),
                       )
                ]
            );
              // );
            }
        ),
      ),
    );
  }
}
