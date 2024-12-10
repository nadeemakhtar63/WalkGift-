import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:walkagift/ProcessOrder.dart';
import 'package:walkagift/constant.dart';

class SlectedGiftDetails extends StatefulWidget {
  String productname;
  String productImage;
  String ProductDeatils;
  String productId;
  int pointsproducts;
  int? productquantity;

   SlectedGiftDetails({super.key,required this.productquantity,required this.pointsproducts,
  required this.ProductDeatils,required this.productImage
  ,required this.productname,required this.productId});

  @override
  State<SlectedGiftDetails> createState() => _SlectedGiftDetailsState();
}

class _SlectedGiftDetailsState extends State<SlectedGiftDetails> {
  initState(){
    super.initState();
    userdataGet();
  }
  late String name,image='',token,address='',contectno='';
  double previousPoints=0;
  int myorders=0;
  userdataGet()async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .where('uid', isEqualTo: auth.currentUser!.uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Get the reference to the first document (assuming there's only one match)
      DocumentReference userRef = querySnapshot.docs.first.reference;
      setState(() {
        previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
        name=(querySnapshot.docs.first.data() as Map<String, dynamic>)['name'] ?? '';
        image=(querySnapshot.docs.first.data() as Map<String, dynamic>)['userimage'] ?? '';
        token=(querySnapshot.docs.first.data() as Map<String, dynamic>)['token'] ?? '';
        contectno=(querySnapshot.docs.first.data() as Map<String, dynamic>)['phoneNumber'] ?? '';
        address=(querySnapshot.docs.first.data() as Map<String, dynamic>)['address'] ?? '';
        myorders=(querySnapshot.docs.first.data() as Map<String, dynamic>)['myorders'] ?? '';
      });
      print(image);
      // print('Points updated successfully! New total points: $newPoints');
    } else {
      print('User document not found for current user');
    }
    // }
    // catch (e) {
    // print('Error updating points: $e');
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0xff567a93),
        backgroundColor: Colors.transparent,
        title: Text(widget.productname),
        centerTitle: true,
        elevation: 0.0,
      ),
floatingActionButton: previousPoints>=widget.pointsproducts?FloatingActionButton.extended(
  backgroundColor: Color(0xff567a93),
  onPressed: (){
    Get.to(() =>
        ProcessOrder(
          previousOreder: myorders,
          token:token,
          contectno:contectno,
          productId: widget.productId,
          userImage: image,
          username: name,
          numberofProducts:widget.productquantity,
          address: address,
          productImage: widget.productname,
          productname: widget.productname,
          ProductDeatils:widget.ProductDeatils,
          mypoints: previousPoints,
          pointsproducts:widget.pointsproducts,));
  }, label: const Text("Process Order",style: TextStyle(color: Colors.white,fontSize: 16),),
    icon: Icon(Icons.add_shopping_cart_sharp,color: Colors.white,),):SizedBox(),
      body: Column(
        children: [
      Container(
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff567a93),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight:  Radius.circular(20)),
          image: DecorationImage(image: NetworkImage(widget.productImage),fit: BoxFit.cover)
        ),
      ),
      Expanded(child:
      Column(
        children: [
          SizedBox(height: 30,),
          Text(widget.productname,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900),),
          ListTile(
          trailing: InkWell(

              onTap: (){
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        icon: Column(
                          children: [
                            Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close))),
                            // Image.asset("assets/lotryopen.png"),
                          ],
                        ),
                        title: const Text(
                            "Your CPK low",style: TextStyle(color: Colors.red),),
                        content: Text(
                            "Your CPK points are low from ${widget.pointsproducts} increase it."),
                        actions: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: Color(0xff567a93),
                            onPressed: () {
                            Navigator.pop(context);
                          }, child: Text("Increase",style: TextStyle(color: Colors.white),),),

                          MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: Color(0xff567a93),
                            onPressed: () {
                            Navigator.pop(context);
                          }, child: Text("Okay",style: TextStyle(color: Colors.white),),),
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      );
                    });
              },

            child: Container(
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff567a93)
              ),
              child: Center(child: Text('WGC ${widget.pointsproducts.toString()}',style: TextStyle(color: Colors.white,fontSize: 12),),),
            ),
          ),

            title:Text("Stock Avalible") ,
            leading:Icon(Icons.production_quantity_limits),

            // ,  Icon(Icons.production_quantity_limits)
          ),
          Text("Description",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w900),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.ProductDeatils),
          ),
        ],
      ))
        ],
      ),
    );
  }
}
