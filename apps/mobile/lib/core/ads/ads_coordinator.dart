import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

class AdsCoordinator {
  AdsCoordinator._();

  static final AdsCoordinator instance = AdsCoordinator._();

  static const Duration interstitialMinInterval = Duration(minutes: 10);
  static const int interstitialSessionLimit = 2;

  final ValueNotifier<bool> adsReady = ValueNotifier(false);
  final ValueNotifier<bool> bannerSuppressed = ValueNotifier(false);

  bool _initializationStarted = false;
  bool _mobileAdsInitialized = false;
  bool _interstitialLoading = false;
  bool _interstitialShowing = false;
  bool _analysisCompleted = false;
  int _sessionInterstitialCount = 0;
  DateTime? _lastInterstitialShownAt;
  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    if (_initializationStarted) return;
    _initializationStarted = true;

    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        await _startAdsIfAllowed();
        await ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          if (formError != null) {
            debugPrint(
              'Ad consent form error ${formError.errorCode}: '
              '${formError.message}',
            );
          }
        });
        await _startAdsIfAllowed();
      },
      (formError) async {
        debugPrint(
          'Ad consent update error ${formError.errorCode}: '
          '${formError.message}',
        );
        await _startAdsIfAllowed();
      },
    );
  }

  Future<void> _startAdsIfAllowed() async {
    if (_mobileAdsInitialized || !AdConfig.hasAdUnitIds) return;
    if (!await ConsentInformation.instance.canRequestAds()) return;

    _mobileAdsInitialized = true;
    await MobileAds.instance.initialize();
    adsReady.value = true;
    _loadInterstitial();
  }

  void setBannerSuppressed(bool value) {
    if (bannerSuppressed.value != value) {
      bannerSuppressed.value = value;
    }
  }

  void markAnalysisCompleted() {
    _analysisCompleted = true;
    _loadInterstitial();
  }

  Future<bool> isPrivacyOptionsRequired() async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    return status == PrivacyOptionsRequirementStatus.required;
  }

  Future<FormError?> showPrivacyOptions() async {
    FormError? result;
    await ConsentForm.showPrivacyOptionsForm((formError) {
      result = formError;
    });
    await _startAdsIfAllowed();
    return result;
  }

  bool get _interstitialEligible {
    if (!adsReady.value || !_analysisCompleted) return false;
    if (_interstitialShowing || _interstitialAd == null) return false;
    if (_sessionInterstitialCount >= interstitialSessionLimit) return false;

    final lastShown = _lastInterstitialShownAt;
    if (lastShown == null) return true;
    return DateTime.now().difference(lastShown) >= interstitialMinInterval;
  }

  Future<bool> showInterstitialIfEligible() async {
    if (!_interstitialEligible) {
      _loadInterstitial();
      return false;
    }

    final ad = _interstitialAd!;
    _interstitialAd = null;
    _interstitialShowing = true;
    final completer = Completer<void>();

    void finish(InterstitialAd finishedAd) {
      finishedAd.dispose();
      _interstitialShowing = false;
      if (!completer.isCompleted) completer.complete();
      _loadInterstitial();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) {
        _sessionInterstitialCount += 1;
        _lastInterstitialShownAt = DateTime.now();
      },
      onAdDismissedFullScreenContent: finish,
      onAdFailedToShowFullScreenContent: (failedAd, error) {
        debugPrint('Interstitial show failed: $error');
        finish(failedAd);
      },
    );

    ad.show();
    await completer.future;
    return true;
  }

  void _loadInterstitial() {
    if (!adsReady.value || _interstitialLoading || _interstitialAd != null) {
      return;
    }
    if (_sessionInterstitialCount >= interstitialSessionLimit) return;

    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialLoading = false;
          debugPrint('Interstitial load failed: $error');
        },
      ),
    );
  }
}
