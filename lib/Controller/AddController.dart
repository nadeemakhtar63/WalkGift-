import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyController extends GetxController{
  NativeAd? nativeAd;
  RxBool isAdLoaded = false.obs;
  final String adUnitId = "ca-app-pub-3940256099942544/2247696110";

  loadAd(){
    nativeAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
            onAdLoaded: (ad){
              isAdLoaded.value = true;
            },
            onAdFailedToLoad: (ad, error){
              isAdLoaded.value = false;
            }
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(templateType: TemplateType.medium)
    );
    nativeAd!.load();
  }

  // @override
  // void dispose(){
  //   nativeAd?.dispose();
  //   super.dispose();
  // }
}
