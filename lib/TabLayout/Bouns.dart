import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:walkagift/Controller/AdController.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';
import 'package:walkagift/FootstepTest.dart';
import 'package:walkagift/GoogleAds.dart';
import 'package:walkagift/ModelClasses/AdswachedcompleteModel.dart';
import 'package:walkagift/ModelClasses/BounsModelClass.dart';
import 'package:walkagift/constant.dart';
class BounsScreen extends StatefulWidget {
  int totalfootsteps;
   BounsScreen({super.key,required this.totalfootsteps});
  @override
  State<BounsScreen> createState() => _BounsScreenState();
}
class _BounsScreenState extends State<BounsScreen> {
  int _current = 0;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  bool _isLoadingAd = false;
  final AdController adController = Get.put(AdController());
  // void _loadRewardedAd() {
  //   setState(() {
  //     _isLoadingAd = true;
  //   });
  //
  //   RewardedAd.load(
  //     adUnitId: AdMobService.rewardedAdUnitId!,
  //     request: AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           _rewardedAd = ad;
  //           _isRewardedAdReady = true;
  //           _isLoadingAd = false;
  //         });
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             setState(() {
  //               // _rewardedAd = null;
  //               _isRewardedAdReady=false;
  //             }
  //             );
  //             // _isRewardedAdReady=true;
  //             _loadRewardedAd();
  //           },
  //         );
  //
  //         // setState(() {
  //         //   _rewardedAd = ad;
  //         // });
  //       },
  //       onAdFailedToLoad: (err) {
  //         setState(() {
  //           _isRewardedAdReady = false;
  //           _isLoadingAd = false;
  //         });
  //       },
  //     ),
  //   );
  // }
  var val;
  // printData(allitesmid)async{
  //   if (uidauth.currentUser!. != null) {
  //     try {
  //       // Query Firestore for user data
  //           await firebaseFirestore.collection('BonscompleteAdd').doc(allitesmid).snapshots().
  //           map((event) {
  //
  //           });
  //       var selecteduseridget;
  //       // Check if user data exists
  //       if (userData.exists) {
  //         print("userrrrrrrrrrr $userData");
  //         setState(() {
  //           selecteduseridget = userData['uid'];
  //         });
  //         if(selecteduseridget==auth.currentUser!.uid) {
  //           setState(() {
  //             _watchCount = 0;
  //             _watchCount = userData['watchCount'];
  //             // }
  //             //
  //           });
  //         }
  //         else{
  //           setState(() {
  //             _watchCount=0;
  //           });
  //         }
  //         // userdatavalue.add({
  //         //   "adsId":userData[''],
  //         //   "":""
  //         // });
  //         // User data exists, you can access it using userData.data()
  //         print('User data: ${userData.data()}');
  //       } else {
  //         setState(() {
  //           _watchCount=0;
  //         });
  //
  //         // User data does not exist
  //         print('User data does not exist');
  //       }
  //     } catch (e) {
  //       // Handle errors
  //       print('Error fetching user data: $e');
  //     }
  //   } else {
  //     // User is not signed in
  //     print('User is not signed in');
  //   }
  // }
  void _checkDateAndDeleteAds() async {
    // DateTime now = DateTime.now();
    // DateTime today = DateTime(now.year, now.month, now.day);
    DateTime today = DateTime(_serverTime!.year, _serverTime!.month, _serverTime!.day);
    QuerySnapshot<Map<String, dynamic>> watchedAdsSnapshot = await firebaseFirestore
        .collection('BonscompleteAdd')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in watchedAdsSnapshot.docs) {
      DateTime? lastWatched = (doc.data()['lastdatewatched'] as Timestamp?)?.toDate();

      if (lastWatched != null && lastWatched.isBefore(today)) {
          await firebaseFirestore.collection('BonscompleteAdd')
              .doc(doc.id)
              .delete();
      }
    }
  }
initState(){
    super.initState();
  // printData();
    adController.loadRewardedAd() ;


    // print('server time date :${FieldValue.serverTimestamp() as Timestamp}');
  //   _loadRewardedAd();
  print(val);
print('object');
    fetchServerDateAndCheckAds();
}
  void fetchServerDateAndCheckAds() async {
     fetchServerDate();
    _checkDateAndDeleteAds();
  }
  DateTime? _serverTime;
  void fetchServerDate() async{

      FirebaseFirestore.instance.collection('serverTime').doc('dateis').get().then((doc) {
        if (doc.exists) {
          Timestamp? timestamp = doc.data()?['serverTimeField'] as Timestamp?;
          if (timestamp != null) {
            setState(() {
              _serverTime = timestamp.toDate();
            });

            print('This is server time object that you find: $_serverTime');
            // _checkDateAndDeleteAds();
          }

        }
      }).catchError((error) {
        print('Error fetching document: $error');
      });


}
  List<Map> userdatavalue=[];
  int _watchCount=0;
  // int _watchCount = 0;
  DateTime? _lastWatched;
  Future<void> fetchUserData(String allitesmid) async {
    _lastWatched = null;
    if (auth.currentUser!.uid != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userData = await firebaseFirestore.collection('adswatchedComplete').doc(allitesmid).get();
        if (userData.exists) {
          setState(() {
            _watchCount = userData.data()?['watchCount'] ?? 0;
            _lastWatched = (userData.data()?['lastWatched'] as Timestamp?)?.toDate();
          });
        } else {
          setState(() {
            _watchCount = 0;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('User is not signed in');
    }
  }
  void _handleAdWatched(BounsModelClass allitesm) async {
    // DateTime now = DateTime.now();
    // DateTime today = DateTime(now.year, now.month, now.day);
    DateTime today = DateTime(_serverTime!.year, _serverTime!.month, _serverTime!.day);
    // Fetch the server time to compare with local time
    // DocumentSnapshot<Map<String, dynamic>> serverTimeSnapshot = await firebaseFirestore.collection('serverTime').doc('currentTime').get();
    // Timestamp? serverTimeStamp = serverTimeSnapshot.data()?['timestamp'];
    DateTime serverTime = _serverTime! ;
    if (allitesm.regular_select == 1) {
      if (_lastWatched != null) {
        DateTime lastWatchedDate = DateTime(_lastWatched!.year, _lastWatched!.month, _lastWatched!.day);
        if (lastWatchedDate == today) {
          print("You can only watch one ad per day.");
          return;
        } else if (serverTime.difference(lastWatchedDate).inDays > 1) {
          setState(() {
            _watchCount = 1;
          });
        } else {
          setState(() {
            _watchCount++;
          });
        }
      } else {
        setState(() {
          _watchCount = 1;
        });
      }
      setState(() {
        _lastWatched = _serverTime;
      });
    } else {
      setState(() {
        _watchCount++;
      });
    }

    FirebaseCrud firebaseCrud = new FirebaseCrud();
    firebaseCrud.saveAdWatch(
      uid: auth.currentUser!.uid,
      ads_id: allitesm.id!,
      watchCount: _watchCount,
      lastWatched: _lastWatched,
      regularwatch: allitesm.regular_select,
    );
    if (_watchCount == allitesm.totalrewords) {
      await FirebaseCrud().updateUserPoints(pointsToAdd: int.parse(allitesm.pointsget!));
      // _watchCount = 0;
      Navigator.pop(context);
      showCusimAlertDialog(allitesm);
    }
    else {
      Navigator.pop(context);
      showCusimAlertDialog(allitesm);
    }
    setState(() {});
  }

  void _showAd(BounsModelClass allitesm) {
    _rewardedAd?.show(onUserEarnedReward: (_, reward) {
      _handleAdWatched(allitesm);
    });
  }

  void _showFootStepsDialog(BounsModelClass items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Need ${items.pathneed} footsteps for watching ads"),
        content: Text("Ad lock until you increase your footsteps from ${items.pathneed}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showAlreadyWatchedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ad Already Watched"),
        content: Text("You can only watch one ad per day. Please come back tomorrow."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  showCusimAlertDialog(BounsModelClass allitesm) async {
    DateTime now = DateTime.now();

    Timer(Duration(seconds: 1), () {
      if (_watchCount == allitesm.totalrewords) {
        FirebaseCrud().savecompleteAdsWatched(
          uid: auth.currentUser!.uid,
          ads_id: allitesm.id!,
          pointget: allitesm.pointsget,
        );
        FirebaseCrud().updateUserPoints(pointsToAdd:allitesm.pointsget!);
        showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              child: Container(
                width: 300, // Customize the width as needed
                height: 350, // Customize the height as needed
                child: StatefulBuilder(
                  builder: (context, setStateB) {
                    setStateB(() {
                      progressbarbool = false;
                    });
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Image.asset(
                          "assets/lotryopen.png",
                          height: 90,
                          width: 90,
                        ),
                        SizedBox(height: 10), // Add space between elements
                        Center(child: const Text("Task Completed")),
                        SizedBox(height: 10), // Add space between elements
                        Center(child: const Text("You Have Received This Reward")),
                        SizedBox(height: 10), // Add space between elements
                        MaterialButton(
                          color: Colors.blueGrey,
                          onPressed: () {
                            setStateB(() {
                              progressbarbool = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );

        _watchCount=0;
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return StatefulBuilder(
              builder: (context, setstate) {
                setstate(() {
                  progressbarbool = false;
                });
                return AlertDialog(
                  title: Column(
                    children: [
                      Text(allitesm.title!),
                      Image.asset('assets/advertising.png'),
                    ],
                  ),
                  content: Container(
                    height: 200,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 180,
                          child: Center(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: allitesm.totalrewords,
                              itemBuilder: (context, items) {
                                return items < _watchCount
                                    ? Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(width: 1, color: Colors.black),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.check),
                                  ),
                                )
                                    : Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.black),
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          "$_watchCount/${allitesm.totalrewords} Videos watched",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        Obx(() => adController.isLoadingAd.value
                            ? CircularProgressIndicator()
                            : MaterialButton(
                          color: Colors.blueGrey,
                          child: Text("Watch Ad"),
                          onPressed: () {
                            setState(() {
                              progressbarbool = false;
                            });
                            DateTime now = DateTime.now();
                            // DateTime today = DateTime(now.year, now.month, now.day);
                            DateTime today = DateTime(_serverTime!.year, _serverTime!.month, _serverTime!.day);
                            if (_lastWatched != null && DateTime(_lastWatched!.year, _lastWatched!.month, _lastWatched!.day) == today) {
                              _showAlreadyWatchedDialog();
                            } else {
                              if (adController.isRewardedAdReady.value) {
                                adController.showAd(() {
                                  _handleAdWatched(allitesm);
                                });
                              }
                            }
                          },
                        )),
                        Text(
                          "Win ${allitesm.pointsget} Points",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          progressbarbool = false;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("OK", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            );
          },
        );
      }
    });
  }
  bool progressbarbool=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff567a93),
        // foregroundColor: Color(0xff567a93),
        elevation: 0.0,
        title: const Text("Rewards"),
        centerTitle: true,
      ),
      body:  Column(
        children: [
          Expanded(
            child: GetX<MyControllers>(
                init:Get.put<MyControllers>(MyControllers()),
                builder:(MyControllers controllers){
                  return Column(
                    children: [
                      // Container(
                      //   height: MediaQuery.of(context).size.height*0.23,
                      //   color: const Color(0xffD9EBF6),
                      //   child: CarouselSlider(
                      //     items: controllers.bounsDataList.map((item) =>
                      //         Container(
                      //           // color: Get.theme.cardColor,
                      //           width: MediaQuery.of(context).size.width,
                      //           height:  MediaQuery.of(context).size.height,
                      //           decoration: const BoxDecoration(
                      //             // borderRadius: BorderRadius.circular(40)
                      //           ),
                      //           child: InkWell(
                      //             onTap: (){
                      //               // Get.to(Booking(image: _foundUsers[_current]["image"],
                      //               //   servicename:  _foundUsers[_current]['name'],
                      //               //   shortDes: _foundUsers[_current]['shortDes'],
                      //               //   reviwes: _foundUsers[_current]['reviews'],
                      //               //   mainservicename: _foundUsers[_current]['mainservice'],
                      //               //   howitwork: _foundUsers[_current]['Howitworks'],
                      //               //   serviceCharges: _foundUsers[_current]["service_charges"],
                      //               //   serviceRequirDuration:_foundUsers[_current]["repair_time_requir"] ,
                      //               //   extraTex: _foundUsers[_current]["tax"],
                      //               // ));
                      //             },
                      //             child: Container(
                      //               decoration: BoxDecoration(
                      //                   image: DecorationImage(
                      //                       fit: BoxFit.cover,
                      //                       //     colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      //                       image: NetworkImage(item.adsimage!)
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
                      //             _current = index;
                      //           });
                      //         }
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controllers.bounsDataList.length,
                          itemBuilder: (context, items) {
                            final allitesm = controllers.bounsDataList[items];
                            // Check if the current item is already present in BonscompleteAdd collection
                            return StreamBuilder<DocumentSnapshot>(
                              stream: firebaseFirestore.collection('BonscompleteAdd').doc(allitesm.id!+auth.currentUser!.uid).snapshots(),
                              builder: (context, snapshot) {
                                // if (snapshot.connectionState == ConnectionState.waiting) {
                                //   return Text("data");  // While waiting for data, return a loading indicator
                                // }
                                // if (snapshot.hasError) {
                                //   return Text('Error: ${snapshot.error}'); // If there's an error, display an error message
                                // }
                                //
                                // // If the document exists in BonscompleteAdd collection, don't display the item
                                // if (snapshot.hasData && snapshot.data!.exists) {
                                //   return Text('data is');
                                //  }
                                final isComplete = snapshot.hasData && snapshot.data!.exists;
                                return isComplete ? SizedBox() :
                                // Otherwise, display the item
                                InkWell(
                                  onTap: () {
                                    if(allitesm.pathneed!<=widget.totalfootsteps) {
                                      //   _loadRewardedAd();
                                      fetchUserData(auth.currentUser!.uid+allitesm.id!);
                                      setState(() {
                                        progressbarbool = true;
                                      });
                                      showCusimAlertDialog(allitesm);
                                      // _showDialogWithProgress(
                                      //     allitesm);
                                    }
                                    else
                                    {
                                    _showFootStepsDialog(allitesm);
                                    }
                                    },
                                  child: BounsCard(allitesm: allitesm, steps: widget.totalfootsteps,)
                                );
                              },
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
      )

    );
  }
}
class BounsCard extends StatelessWidget {
  final BounsModelClass allitesm;
  int steps;
   BounsCard({Key? key, required this.allitesm,required this.steps}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5,
        // color: Color(0xff567a93),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(allitesm.adsimage!)),
                ),
                width: double.infinity,
              child:allitesm.pathneed!<=steps?null:Icon(Icons.lock,size: 45,)
              ),

              Column(
                children: [
                  Text(
                    allitesm.title!,
                    style: const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 24,fontWeight: FontWeight.w900),
                  ),
                  Text(
                    allitesm.subTitle!,
                    style: const TextStyle(overflow: TextOverflow.ellipsis,fontSize: 18,fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
