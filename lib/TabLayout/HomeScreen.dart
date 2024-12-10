
import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:walkagift/Annoucementshow.dart';
import 'package:walkagift/ContectSCreen.dart';
import 'package:walkagift/Controller/AddController.dart';
import 'package:walkagift/Controller/Controllers.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:walkagift/FAQScreen.dart';
import 'package:walkagift/FirebaseCRUD/FirebaseCrud.dart';
import 'package:walkagift/GoogleAds.dart';
import 'package:walkagift/ModelClasses/ProfileModel.dart';
import 'package:walkagift/ModelClasses/annoucementModelClass.dart';
import 'package:walkagift/SettingScreen/ProfileScreen.dart';
import 'package:walkagift/TabLayout/Bouns.dart';
import 'package:walkagift/TabLayout/Reword.dart';
import 'package:walkagift/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Controller/AdController.dart';
class HomeScreen extends StatefulWidget {
  int totalfootsteps;
   HomeScreen({super.key,required this.totalfootsteps});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>   with SingleTickerProviderStateMixin {
var dateTime,points,totalSteps;
  int stepsConvert=0;
final AdController adController = Get.put(AdController());
  // final MyControllers stepsController = Get.find();
  double energyBar = 10;
  double tads=0;
  double advalue=0;
  double oneadValue=0;
  // int steps = 0;
  double percentage=0;
  bool enableconversion=false;
Future<void> saveValueToSharedPreferences(double totalAds) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('totalAds', totalAds);
  print('These values are printed in save preference $totalAds');
}
Future<double> getValueFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('totalAds') ?? 0;
}
Future<void> saveDateToSharedPreferences(String date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastDate', date);
}
Future<String> getDateFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('lastDate') ?? '';
}
void resetTotalAdsIfDateChanged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lastDate = prefs.getString('lastDate') ?? '';
  String currentDate = DateTime.now().toIso8601String().substring(0, 10);
  if (lastDate != currentDate) {
    await saveValueToSharedPreferences(0);
    await saveDateToSharedPreferences(currentDate);
  }
}
fetchtodayConvertedStepds()async
{
  // QuerySnapshot querySnapshot =
  DocumentSnapshot document = await FirebaseFirestore.instance
      .collection('stepsConverteing')
      .doc(auth.currentUser!.uid)
      .get();
  // .where('uid', isEqualTo: auth.currentUser!.uid).get();
  if (document.exists) {
    print("inside order screen");
    // Get the reference to the first document (assuming there's only one match)
    // DocumentReference userRef = querySnapshot.docs.first.reference;
    setState(() {
      dateTime = (document['dateTime'] as Timestamp).toDate()?? 0;
      print('User document not found for current user$dateTime');
      if(dateTime.day==DateTime.now().day) {
        // print(object)
        points = document['points'] ?? '';
        // steps=(querySnapshot.docs.first.data() as Map<String, dynamic>)['mysteps'] ?? '';
        stepsConvert = document['stepsConvert'] ?? '';
        totalSteps = document['totalSteps'] ?? '';
        // address=(querySnapshot.docs.first.data() as Map<String, dynamic>)['address'] ?? '';
      }
    });
    // print(image);
    // print('Points updated successfully! New total points: $newPoints');
  } else {

  }
}
Future<void> fetchGoogleFitData(GoogleSignInAccount googleSignInAccount) async {
  final int maxRetries = 5;
  int retryCount = 0;
  bool success = false;
print(',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
  while (retryCount < maxRetries && !success) {
    try {
      final authHeaders = await googleSignInAccount.authHeaders;
      final credentials = AccessCredentials(
        AccessToken(
          'Bearer',
          authHeaders['Authorization']!.split(' ').last,
          DateTime.now().toUtc().add(Duration(hours: 1)),
        ),
        null,
        ['https://www.googleapis.com/auth/fitness.activity.read'],
      );

      final client = http.Client();
      final authenticatedHttpClient = authenticatedClient(client, credentials);
      final fitnessApi = FitnessApi(authenticatedHttpClient);

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day)
          .millisecondsSinceEpoch *
          1000000; // Convert to nanoseconds
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch * 1000000; // Convert to nanoseconds
      final dataSources = await fitnessApi.users.dataSources.list('me');
      DataSource? stepsDataSource = dataSources.dataSource?.firstWhere(
              (ds) => ds.dataType?.name == 'com.google.step_count.delta',
          orElse: () => DataSource());
      if (stepsDataSource!.dataStreamId == null) {
        print('No step data source found.');
        continue;
      }

      if (stepsDataSource == null) {
        print('No step data source found.');
        continue;
      }

      final dataSets = await fitnessApi.users.dataSources.datasets.get(
        'me',
        stepsDataSource.dataStreamId!,
        '${startOfDay}-${endOfDay}',
      );

      int totalSteps = 0;
      if (dataSets.point != null) {
        for (var point in dataSets.point!) {
          setState(() {
            totalSteps += point.value!.first.intVal ?? 0;
            print('jnu ');
          });
        }
        setState(() {
          widget.totalfootsteps = totalSteps > 10000 ? 10000 : totalSteps;
        });
        await FirebaseFirestore.instance
            .collection('steps')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(
          {
            'uid': googleSignInAccount.id,
            'steps': totalSteps,
            'timestamp': DateTime.now(),
          },
          SetOptions(merge: true),
        );
      } else {
        print('No data points found.');
      }

      authenticatedHttpClient.close();
      client.close();
      success = true;
    } catch (e) {
      print('Error fetching Google Fit data: $e');
 //     retryCount++;
   //   await Future.delayed(Duration(seconds: 2)); // Wait before retrying
    }
  }
}


Future<void> updateUserSteps() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signInSilently();
    if (googleSignInAccount != null) {
      await fetchGoogleFitData(googleSignInAccount);
    } else {
      print('Google Sign-In account is null.');
    }
  } catch (e) {
    print('Error updating user steps: $e');
  }
}
void showadsforconvert()async {
  _rewardedAd?.show(
      onUserEarnedReward: (_, reward) {
        // fetchUserData(allitesm.id!!);
        setState(() {
          convertStepsDialog();
          // enerybar=enerybar+20;
          // advalue = advalue + oneadValue;
          // tads--;
          // poerenergy = poerenergy + 20;
        });
      });

}
void convertStepsDialog(){
  showDialog(context: context, builder: (_) {
    return AlertDialog(
      title: Container(
        // height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Convert Steps'),
            Container(
                height: 50,
                width: 50,
                child: Image.asset('assets/goldinimage.png',height: 60,width: 40,))
          ],
        ),
      ),
      content: Container(
          height: 30,
          child: Center(child: Text("${widget.totalfootsteps-stepsConvert}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),))),
      actions: [
        MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.blueGrey,
          onPressed: () {
            double points = 0.0;
            int stepsToConvert = 0;
            setState(() {
              energyBar = 0;
              stepsToConvert = widget.totalfootsteps > 10000 ? 10000 : widget.totalfootsteps-stepsConvert;
              // stepsToConvert=  stepsToConvert-stepsConvert;
            });
            // if (stepsToConvert < 1000) {
            //   setState(() {
            //     energyBar = 1;
            //   });
            //   // showDialog(
            //   //     context: context, builder: (_) {
            //   //   return AlertDialog(
            //   //     title: Text("Steps not Convert"),
            //   //     content: Text(
            //   //         "Steps not convert because minimum steps required 1000 for conversion"),
            //   //   );
            //   // });
            // // }
            // if (stepsToConvert <= 1000) {
            //   setState(() {
            //     energyBar = 1;
            //   });
            // }
            //  if (stepsToConvert <= 2000) {
            //   setState(() {
            //     energyBar = 2;
            //   });
            // }
            // // else if (stepsToConvert <= 3000) {
            // //   setState(() {
            // //     energyBar = 3;
            // //   });
            // // }
            // else if (stepsToConvert > 2000 && stepsToConvert <= 4000) {
            //   setState(() {
            //     energyBar = 4;
            //   });
            // }
            // else if (stepsToConvert>4000 &&stepsToConvert <= 5000) {
            //   setState(() {
            //     energyBar = 5;
            //   });
            // }
            // else if (stepsToConvert>500 && stepsToConvert <= 6000) {
            //   setState(() {
            //     energyBar = 6;
            //   });
            // }
            // else if (stepsToConvert>6000 && stepsToConvert <= 7000) {
            //   setState(() {
            //     energyBar = 7;
            //   });
            // }
            // else if (stepsToConvert>7000 && stepsToConvert <= 8000) {
            //   setState(() {
            //     energyBar = 8;
            //   });
            // }
            // else if (stepsToConvert>8000 && stepsToConvert <= 9000) {
            //   setState(() {
            //     energyBar = 9;
            //   });
            // }
            // else if (stepsToConvert>9000 && stepsToConvert<= 10000) {
            //   setState(() {
            //     energyBar = 10;
            //   });
            // }
            // else{
            setState(() {
              points = (stepsToConvert / 1000) * 2;
            });
            print("your points is $points");
            if (points != 0) {
              FirebaseCrud().updateUserConvertedSteps(
                  pointsToAdd: points,
                  stepsConvert: stepsConvert+stepsToConvert,
                  context: context,
                  totalSteps: widget.totalfootsteps);
              Navigator.pop(context);
              Timer(Duration(seconds: 5), () {
                fetchtodayConvertedStepds();
                userdataGet();
              });
            }
            // }
          },
          child: Text("Convert"),),
        SizedBox(width: 20,),
        MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.blueGrey,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),),
      ],
    );
  });
}
// void showads()async {
//   _rewardedAd?.show(
//       onUserEarnedReward: (_, reward) {
//         // fetchUserData(allitesm.id!!);
//         setState(() {
//           // enerybar=enerybar+20;
//           advalue = advalue + oneadValue;
//           tads--;
//           // poerenergy = poerenergy + 20;
//         });
//       });
//   await saveValueToSharedPreferences(advalue);
//   updatePercentage();
// }
  Widget _buildRadialGauge(BuildContext context) {
    double convertedSteps = 0;
    double stepsToConvert = widget.totalfootsteps.toDouble() > 10000 ? 10000 : widget.totalfootsteps.toDouble();
    double conversionRate = (energyBar / 5).clamp(0.2, 2);
    convertedSteps = (stepsToConvert / 1000) * conversionRate;
    // percentage = 100-((widget.totalfootsteps / 10000) * 100) + advalue;
    // if(steps<=2000)

    //   {
    //     setState(() {
    //      prcenttage= ((steps/10000)*100)+advalue;
    //      advalue=(enerybar-prcenttage)%8;
    //      prcenttage=prcenttage+advalue;
    //       // enerybar=80;
    //     });
    //     Get.snackbar("value",enerybar.toString());
    //   }
    return SfRadialGauge(
      enableLoadingAnimation: true,
      // title:
      // GaugeTitle(
      //   text:'totalStepsToday',
      //   textStyle: TextStyle(color: Colors.white)
      // ),
      axes: <RadialAxis>[
        RadialAxis(
          axisLineStyle: AxisLineStyle(
            color: Colors.red,
            dashArray: const <double>[8, 2],
          ),
          axisLabelStyle: GaugeTextStyle(
            color: Theme.of(context).dialogBackgroundColor,
          ),
          annotations: [
            GaugeAnnotation(
              widget: Text.rich(
                TextSpan(
                    children: [
                  TextSpan(
                    text: 'Today Steps\n${widget.totalfootsteps}\n',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).dialogBackgroundColor,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: 'Converted Steps\n',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).dialogBackgroundColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 11
                    ),
                  ),
                  TextSpan(
                    text: '${stepsConvert}\n',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).dialogBackgroundColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 11
                    ),
                  ),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          pointers: <GaugePointer>[
            RangePointer(
              // TODO: Dummy equation for now until targeting each one's target
              // Our target is 8000 steps daily, do more sports!!!!
              value: percentage,
              color: Colors.green,
              dashArray: const <double>[8, 2],
            ),
          ],
        ),
      ],
    );
  }

  void updatePercentage() {
    setState(() {
      percentage = 100 - ((widget.totalfootsteps / 10000) * 100) + advalue;
      if (percentage >= 100) {
        _animationController.stop();
        enableconversion = true;
      }
      print("your advalue is:$advalue");
      print("your percentage is:$percentage");
    });
  }
  Future<void> _requestActivityRecognitionPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      // Permission already granted
      print("Activity recognition permission already granted");
    } else {
      // Request permission
      final status = await Permission.activityRecognition.request();
      if (status.isGranted) {
        print("Activity recognition permission granted");
      } else {
        print("Activity recognition permission denied");
      }
    }
  }
  late AnimationController controller;
  late String name="",image='',email='',address='';
  double previousPoints=0;
  late AnimationController _animationController;
  // var controler=Get.put(MyController());
  String adImage="https://media.istockphoto.com/id/886661830/photo/hourglass-and-calendar.jpg?s=2048x2048&w=is&k=20&c=lj9eHTIxd5C7D4ivDpVjDMwkY2bhqTbCJ5MU_rH7q6o=";
  // getImageAnnoucemnet()async{
  //   Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = await FirebaseFirestore.instance.collection('imageAnnouceShow').snapshots();
  //
  //   if (querySnapshot.isNull)
  //   {}
  //   else
  //   {
  //     // Get the reference to the first document (assuming there's only one match)
  //     // DocumentReference userRef = querySnapshot.docs.first.reference;
  //     querySnapshot.
  //     setState(() {
  //       print(querySnapshot['image']);
  //       // previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
  //       // name=(querySnapshot.docs.first.data() as Map<String, dynamic>)['name'] ?? '';
  //       // email=(querySnapshot.docs.first.data() as Map<String, dynamic>)['email'] ?? '';
  //       adImage=querySnapshot['image'] ?? '';
  //     });
  //     adImage!=null?
  //     Timer(Duration(seconds: 2),()=> showDialog(context: context, builder: (_){
  //       return AlertDialog(
  //         content: Image.network(adImage,fit: BoxFit.cover,),
  //       );
  //     })
  //     ):null;
  //     print(adImage);
  //     // print('Points updated successfully! New total points: $newPoints');
  //   } else {
  //     print('User document not found for current user');
  //   }
  //
  // }
  final MyControllers userController = Get.put(MyControllers());
  Future<void> _refreshSteps() async {
    await updateUserSteps();
    print('objecthbhbh');
    await fetchtodayConvertedStepds();
    // Call any other methods to refresh the data
    setState(() {}); // Update the state to reflect changes
  }
  initState(){
    super.initState();
    adController.loadRewardedAd();
    updateUserSteps();
    _refreshSteps();
    userdataGet();
    _loadRewardedAd();
    fetchtodayConvertedStepds();
    // controler.loadAd();
    // adImage!=''?Timer(Duration(seconds: 2),()=> showDialog(context: context, builder: (_){
    //   return AlertDialog(
    //     content: Image.network(adImage,fit: BoxFit.cover,
    //       // height:MediaQuery.of(context).size.height*0.7,
    //     ),
    //   );
    // })):null;
    // getImageAnnoucemnet();
    _requestActivityRecognitionPermission();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (percentage >= 100) {
        setState(() {
          _animationController.stop();
          enableconversion = true;
        });
      }
    });
    // if(steps<=2000)
    // {
    //   setState(() {
    //     tads=8;
    //     oneadValue=80/8;
    //   });
    // }
    // if(steps>2000 && steps<=4000)
    // {
    //   setState(() {
    //     tads=6;
    //     oneadValue=60/6;
    //   });
    // }
    // if(steps>4000 && steps<=6000)
    // {
    //   setState(() {
    //     tads=4;
    //     oneadValue=40/4;
    //   });
    // }
    // if(steps>6000 && steps<=8000)
    // {
    //   setState(() {
    //     tads=2;
    //     oneadValue=20/2;
    //   });
    // }
    getValueFromSharedPreferences().then((value) {
      setState(() {
        advalue = value;
        updateAdValues();
        updatePercentage()  ;
        // if (widget.totalfootsteps <= 2000) {
        //   tads = 8;
        //   oneadValue = 80 / 8;
        // } else if (widget.totalfootsteps > 2000 && widget.totalfootsteps <= 4000) {
        //   tads = 6;
        //   oneadValue = 60 / 6;
        // } else if (widget.totalfootsteps > 4000 && widget.totalfootsteps <= 6000) {
        //   tads = 4;
        //   oneadValue = 40 / 4;
        // } else if (widget.totalfootsteps > 6000 && widget.totalfootsteps <= 8000) {
        //   tads = 2;
        //   oneadValue = 20 / 2;
        // }
      });
    });
    resetTotalAdsIfDateChanged();
  }
  void updateAdValues() {
    if (widget.totalfootsteps <= 2000) {
      tads = 8;
      oneadValue = 80 / 8;
    } else if (widget.totalfootsteps > 2000 && widget.totalfootsteps <= 4000) {
      tads = 6;
      oneadValue = 60 / 6;
    } else if (widget.totalfootsteps > 4000 && widget.totalfootsteps <= 6000) {
      tads = 4;
      oneadValue = 40 / 4;
    } else if (widget.totalfootsteps > 6000 && widget.totalfootsteps <= 8000) {
      tads = 2;
      oneadValue = 20 / 2;
    }
  }
  @override

  int _current = 0;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady=false;
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd=ad!;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                // ad.dispose();
                // _rewardedAd = null;
                _isRewardedAdReady=false;
                _loadRewardedAd();
                setState(() {
                });
              });
              _isRewardedAdReady=true;
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
    // }
    // catch (e) {
    // print('Error updating points: $e');
    // }
  userdataGet()async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users')
        .where('uid', isEqualTo: auth.currentUser!.uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Get the reference to the first document (assuming there's only one match)
      DocumentReference userRef = querySnapshot.docs.first.reference;
        setState(() {
           previousPoints = (querySnapshot.docs.first.data() as Map<String, dynamic>)['points'] ?? 0;
           name=(querySnapshot.docs.first.data() as Map<String, dynamic>)['name'] ?? '';
           // steps=(querySnapshot.docs.first.data() as Map<String, dynamic>)['mysteps'] ?? '';
           email=(querySnapshot.docs.first.data() as Map<String, dynamic>)['email'] ?? '';
           image=(querySnapshot.docs.first.data() as Map<String, dynamic>)['userimage'] ?? '';
           address=(querySnapshot.docs.first.data() as Map<String, dynamic>)['address'] ?? '';
        });
        // print(image);
      // print('Points updated successfully! New total points: $newPoints');
    } else {
      print('User document not found for current user');
    }
  // }
  // catch (e) {
  // print('Error updating points: $e');
  // }
  }
  late TextEditingController nameController=TextEditingController(text: address);
  bool adresvalidate=false;
  @override
  void dispose() {
    _animationController.dispose();
    // controler.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user = userController.userModel.value;
    // adImage!=''?Timer(Duration(seconds: 2),()=> showDialog(context: context, builder: (_){
    //   return AlertDialog(
    //     content: Image.network(adImage,fit: BoxFit.cover,
    //       // height:MediaQuery.of(context).size.height*0.7,
    //     ),
    //   );
    // })):null;
    return Scaffold(
      backgroundColor: Color(0xff567a93),
      appBar: AppBar(
        backgroundColor: Color(0xff6a91a9),
        elevation: 0.0,
        // foregroundColor: Color(0xff6a91a9),
        actions: [
          IconButton(
              onPressed:()=> updateUserSteps,
              icon:Icon(Icons.update,color: Colors.white,)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 15,
              backgroundImage:NetworkImage(image),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${previousPoints.toInt().toString()} WGC',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),)),
          )
        ],
      ),
      drawer: Drawer(
        // backgroundColor:Color(0xff567a93),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              // color: Color(0xff567a93),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage:NetworkImage(image),
                  ),
                  Text(name)
                ],
              ),
            ),
            Expanded(child:
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      Get.to(
                          UserProfileScreen(
                        // points: previousPoints,
                        // name: name,
                        // email: email,
                        // address: address,
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
                              trailing:Icon(Icons.arrow_forward_ios_sharp)
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
                    onTap: (){
                      Get.to(()=>RewordScreen(totalfootsteps: widget.totalfootsteps,));
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
                    onTap: (){
                      showModalBottomSheet(
                          isScrollControlled: true,
                          // backgroundColor: Color(0xff567a93).withOpacity(0.1),
                          context: context,
                          builder: (context){
                            return Container(
                              height: MediaQuery.of(context).size.height*0.8,
                              width: double.infinity,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      icon:Icon(Icons.cancel_outlined,color: Colors.red,size: 45,),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 5,
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height*0.14,
                                        decoration: BoxDecoration(
                                          // color:  Color(0xff567a93),
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
                                            // fillColor: Color(0xff567a93),
                                            errorText: adresvalidate?"*Required Carrier  Address":null,
                                            hintText: 'e.g. city address,street address,house no',
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
                                     if(nameController.text.isEmpty)
                                       {
                                         nameController.text.isEmpty? adresvalidate=true:adresvalidate=false;
                                       }
                                     else {
                                       firebaseFirestore.collection("users")
                                           .doc(auth.currentUser!.uid)
                                           .update({
                                         'address': nameController.text
                                       }).whenComplete(() => Get.snackbar("Address Updated","User Address Updated"),);
                                       final updatedUser = UserModel(
                                           address: nameController.text,
                                           email: user!.email!,
                                           name: user.name,
                                           points: user.points,
                                           profileImage: user.profileImage,
                                           myOrders: user.myOrders
                                         // other fields as well...
                                       );
                                       userController.userModel.value = updatedUser;
                                       Navigator.pop(context);
                                     }
                                   },
                                    child: Card(
                                      // color:Color(0xff567a93),
                                      elevation: 10.0,
                                      child: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                            // color:Color(0xff567a93),
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        width: MediaQuery.of(context).size.width*0.4,
                                        child: Center(child: Text("UPDATE",style: TextStyle(fontWeight: FontWeight.w900),),),
                                      ),
                                    ),
                                  ),

                                  Text("Complete Address required for courier your gifts ",style: TextStyle(fontWeight: FontWeight.w900),),
                                ],
                              ),
                            );
                          });
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
                  //           leading: Icon(Icons.data_thresholding_sharp),
                  //           title: Text("Data"),
                  //           trailing: Icon(Icons.arrow_forward_ios_sharp)
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
                    onTap: (){
                      Share.share('share app with your friends: https://play.google.com/com.example.walk_gift');
                    },
                    child: Card(
                      elevation: 1,
                      // color: Color(0xff567a93),
                      child:  Container(
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
                    onTap: (){
                      Get.to(()=>FAQScreen());
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
                    onTap: (){
                      Get.to(()=>ContectScreen());
                    },
                    child: Card(
                      // color: Color(0xff567a93),
                      elevation: 1,
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                              leading: Icon(Icons.contact_mail_outlined),
                              title: Text("Contact Us."),
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSteps,
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(   bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),)),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.30,
                decoration: const BoxDecoration(
                  // color: Colors.deepPurple,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,

                        colors: [
                          // Color(0xffbecfd8),
                          Color(0xff6a91a9),
                          Color(0xff567a93),
                          // Color(0xff8cabc0),
                        ]),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                ),
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child:
                      GestureDetector(
                        onTap: (){
                        },
                        child:
                        percentage>=100?Image.asset('assets/speedicon.png',height: 90,width: 90,):FadeTransition(
                          opacity: _animationController,
                          child: Image.asset('assets/speedicon.png',height: 90,width: 90,)
                        )
                      ),
                    ),
                    Positioned(child:
                              InkWell(
                                onTap: (){
                                  _loadRewardedAd();
                                  if(percentage<100 )
                                  {
                                    showDialog(context: context, builder:(_){
                                      return AlertDialog(
                                       actions: [
                                         MaterialButton(
                                             onPressed: (){
                                           Navigator.pop(context);
                                         },
                                         child: Text("Cancel"),
                                         )
                                       ],
                                        // backgroundColor: Colors.teal,
                                        title: Image.asset('assets/advertising.png'),
                                        content:Obx(()=>adController.isLoadingAd.value?
                                        Container(
                                            height: 40,
                                            width: 30,
                                            child: Column(
                                              children: [
                                                CircularProgressIndicator(),
                                              ],
                                            )):Container(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(width: 1)
                                                ),
                                                child:
                                                    IconButton(
                                                  color: Colors.blueGrey,
                                                   onPressed: () {
                                                     if (adController.isRewardedAdReady.value) {
                                                       adController.showAd(() {
                                                          setState(() {
                                                            // enerybar=enerybar+20;
                                                            advalue = advalue + oneadValue;
                                                            tads--;
                                                            // poerenergy = poerenergy + 20;
                                                          });
                                                           saveValueToSharedPreferences(advalue);
                                                          updatePercentage();
                                                       });
                                                     }
                                                     // showads();
                                                     Navigator.pop(context);
                                                   },
                                                    icon: Icon(Icons.video_call,size: 35,color: Colors.white,)),
                                          // )
                                              ),
                                              Text('Watch Ads for Completing Your Energy',style: TextStyle(fontSize: 11),)
                                            ],
                                          ),
                                        ),

                                        )
                                      );
                                    });
                                  }
                                  else{
                                    setState(() {
                                      enableconversion=true;
                                    });
                                    showDialog(
                                        context: context,
                                        builder:(_){
                                          return AlertDialog(
                                            icon: Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                                icon:Icon(Icons.cancel_outlined,color: Colors.red,size: 45,),
                                              ),
                                            ),
                                            title:  Text("Full Energy",style: TextStyle(fontWeight: FontWeight.w900),),
                                            content: Text("You have gained maximum energy\n now move to steps conversion."),
                                          );
                                        });
                                    // Get.snackbar('Energy if full', "Your energy power is full");
                                  }
                                },
                                child:
                                Container(
                                                // height: 180,
                                                // width: MediaQuery.of(context).size.width*0.6,
                                child: _buildRadialGauge(context)),
                              ),
                    ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child:InkWell(
                              onTap: (){
                                int newsteps=0;
                                setState(() {
                                  newsteps=widget.totalfootsteps-stepsConvert;
                                });
                            //   if(enableconversion==true){
                            //     if( widget.totalfootsteps-stepsConvert<1000)
                            //       {
                            //         showDialog(
                            //             context: context,
                            //             builder:(_){
                            //               return AlertDialog(
                            //                 // icon: Align(
                            //                 //   alignment: Alignment.topRight,
                            //                 //   child: IconButton(
                            //                 //     onPressed: (){
                            //                 //       Navigator.pop(context);
                            //                 //     },
                            //                 //     icon:Icon(Icons.cancel_outlined,color: Colors.red,size: 45,),
                            //                 //   ),
                            //                 // ),
                            //                 title:  Text("Not convert",style: TextStyle(fontWeight: FontWeight.w900),),
                            //                 content: Text("Increase your Steps"),
                            //                 actions: [
                            //                 MaterialButton(
                            //                     onPressed: (){
                            //                       Navigator.pop(context);
                            //                     },
                            //                     child:Text("Cancel"),
                            //                   ),
                            //                 ],
                            //               );
                            //             });
                            //       }
                            // else
                           if(newsteps<widget.totalfootsteps||newsteps!=0)
                             {
                               showadsforconvert();
                          }
                        // }
                        //    Get.snackbar("mssss", 'message');
                        },
                        child: Card(
                          elevation: 20,
                          color: enableconversion?Colors.teal:Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          child: Stack(
                            children: [
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          // color: Color(0xff6a91a9),
                                          borderRadius: BorderRadius.circular(60)
                                      ),
                                      child: Center(child: Text("Convert\nSteps",style: TextStyle(fontSize: 9,color: Colors.black),
                                      )
                                      )

                                  )
                              ),
                              Positioned(
                                  child:percentage>=100?Image.asset('assets/roundicons.png',height: 50,width: 50,): LoopAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 2 * pi), // 0° to 360° (2π)
                                    duration: const Duration(seconds: 2), // for 2 seconds per iteration
                                    builder: (context, value, _) {
                                      return Transform.rotate(
                                          angle: value, // use value
                                          child:Image.asset('assets/roundicons.png',height: 50,width: 50,)
                                        // Container(
                                        //
                                        //     color: Colors.blue, width: 100, height: 100),
                                      );
                                    },
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
            InkWell(
              onTap: (){
                Get.to(()=>BounsScreen(totalfootsteps: widget.totalfootsteps,));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image:  AssetImage("assets/extrabouns.png"))
                      ),
                      height: 120,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GetX<MyControllers>(
                init:Get.put<MyControllers>(MyControllers()),
                builder:(MyControllers controllers){
                  return ListView.builder(
                    itemCount: controllers.annoucementgeter.length,
                    itemBuilder: (context, items) {
                      final allitesm = controllers.annoucementgeter[items];
                    adImage=controllers.annoucementgeter[0].adsImage!;
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

                }

              ),
            ),
          ],
        ),
      ),
    );
  }


}
class BounsCard extends StatelessWidget {
  final AnnoucementDisplayModel allitesm;
  const BounsCard({Key? key, required this.allitesm}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){
          Get.to(()=>AnnoucementShow());
        },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}