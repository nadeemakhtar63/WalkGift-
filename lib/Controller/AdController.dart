import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:walkagift/GoogleAds.dart';
import 'package:walkagift/ModelClasses/BounsModelClass.dart';

class AdController extends GetxController {
  RewardedAd? _rewardedAd;
  var isRewardedAdReady = false.obs;
  var isLoadingAd = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRewardedAd();
  }

  void loadRewardedAd() {
    isLoadingAd.value = true;

    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId!,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isRewardedAdReady.value = true;
          isLoadingAd.value = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isRewardedAdReady.value = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          isRewardedAdReady.value = false;
          isLoadingAd.value = false;
        },
      ),
    );
  }

  void showAd( Function onUserEarnedReward) {
    if (_rewardedAd != null && isRewardedAdReady.value) {
      _rewardedAd?.show(onUserEarnedReward: (_, reward) {
        onUserEarnedReward();
      });
    }
  }
}
