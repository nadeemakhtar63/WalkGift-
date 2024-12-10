import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

 class AdMobService{
  static String ? get bannerAdUnitedId{
    if(Platform.isAndroid)
    {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if(Platform.isIOS)
    {
      return 'ca-app-pub-7834073120294783/9495264411';
    }
    return null;
  }
  static final BannerAdListener bannerAdListener=BannerAdListener(
    onAdLoaded: (ad)=>debugPrint("Ad Load"),
    onAdFailedToLoad: (ad,error){
      ad.dispose();
      debugPrint("ad failed to load $error");
    },
    onAdOpened: (ad)=>debugPrint('Ad Open'),
    onAdClosed: (ad)=>debugPrint("Ad close"),

  );

  static String ? get appOpenAdUnitId{
    if(Platform.isAndroid)
    {
      return 'ca-app-pub-3940256099942544/9257395921';
    } else if(Platform.isIOS)
    {
      return 'ca-app-pub-7834073120294783/3668222666';
    }
    return null;
  }

  static String ? get interstitonalAdUnitId{
    if(Platform.isAndroid)
    {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if(Platform.isIOS)
    {
      return 'ca-app-pub-7834073120294783/3668222666';
    }
    return null;
  }
  static String ? get rewardedAdUnitId{
    if(Platform.isAndroid)
    {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if(Platform.isIOS)
    {
      return 'ca-app-pub-7834073120294783/9621588623';
    }
    return null;
  }
}
