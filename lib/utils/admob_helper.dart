import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardAdManager {
  RewardedAd? _rewardedAd;
  final String rewardAdId;
  bool _isAdLoaded = false;

  RewardAdManager({required this.rewardAdId});

  // 한 번만 광고를 로드하도록 처리합니다.
  void loadAd() {
    if (!_isAdLoaded) {
      RewardedAd.load(
        adUnitId: rewardAdId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isAdLoaded = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            _isAdLoaded = false;
          },
        ),
      );
    } else {
      debugPrint('RewardedAd is already loaded.');
    }
  }

  // 로드된 광고가 있고 유효한 경우에만 광고를 표시합니다.
  void showAd() {
    if (_isAdLoaded && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('User earned reward: $reward');
          // 광고 보상 처리
          // 보상 받은 후 새로운 광고 로드
          loadAd();
        },
      );
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('Rewarded ad was dismissed.');
          // 광고가 닫혔을 때 새로운 광고 로드
          loadAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('Failed to show rewarded ad: $error');
          // 광고가 보여지지 못했을 때 새로운 광고 로드
          loadAd();
        },
      );
      // 현재 광고 인스턴스를 초기화하여 다음 광고 준비
      _rewardedAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint('RewardedAd is not loaded or valid.');
      // 광고 로드가 완료되지 않았거나 유효하지 않은 경우 처리할 내용
    }
  }


  // 객체를 dispose하여 리소스를 정리합니다.
  void dispose() {
    _rewardedAd?.dispose();
    _isAdLoaded = false; // 광고 로드 상태 초기화
  }
}
