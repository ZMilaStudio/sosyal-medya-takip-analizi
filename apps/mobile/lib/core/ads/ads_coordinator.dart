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
  bool _adsDisabledForSession = false;
  bool _mobileAdsInitializing = false;
  bool _mobileAdsInitialized = false;
  bool _interstitialLoading = false;
  bool _interstitialShowing = false;
  bool _analysisCompleted = false;
  int _sessionInterstitialCount = 0;
  DateTime? _lastInterstitialShownAt;
  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    if (_initializationStarted || _adsDisabledForSession) return;
    _initializationStarted = true;

    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () {
          unawaited(_handleConsentUpdateSuccess());
        },
        (formError) {
          unawaited(_handleConsentUpdateFailure(formError));
        },
      );
    } catch (error, stackTrace) {
      _disableAdsForSession('consent initialization', error, stackTrace);
    }
  }

  Future<void> _handleConsentUpdateSuccess() async {
    if (_adsDisabledForSession) return;
    try {
      // A previous-session consent state can already permit ads here.
      await _startAdsIfAllowed();
      final formError = await _loadAndShowConsentIfRequired();
      if (formError != null) {
        debugPrint(
          'Ad consent form error ${formError.errorCode}: '
          '${formError.message}',
        );
      }
      await _startAdsIfAllowed();
    } catch (error, stackTrace) {
      _disableAdsForSession('consent success callback', error, stackTrace);
    }
  }

  Future<void> _handleConsentUpdateFailure(FormError formError) async {
    if (_adsDisabledForSession) return;
    debugPrint(
      'Ad consent update error ${formError.errorCode}: ${formError.message}',
    );
    try {
      // UMP can still have a valid previous-session state after an update
      // error, so rely on canRequestAds rather than guessing consent.
      await _startAdsIfAllowed();
    } catch (error, stackTrace) {
      _disableAdsForSession('consent failure fallback', error, stackTrace);
    }
  }

  Future<FormError?> _loadAndShowConsentIfRequired() {
    final completer = Completer<FormError?>();
    try {
      ConsentForm.loadAndShowConsentFormIfRequired((formError) {
        if (!completer.isCompleted) completer.complete(formError);
      });
    } catch (error, stackTrace) {
      debugPrint('Consent form startup failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!completer.isCompleted) completer.complete(null);
    }
    return completer.future;
  }

  Future<void> _startAdsIfAllowed() async {
    if (_adsDisabledForSession ||
        _mobileAdsInitialized ||
        _mobileAdsInitializing ||
        !AdConfig.hasAdUnitIds) {
      return;
    }

    final canRequestAds = await ConsentInformation.instance.canRequestAds();
    if (!canRequestAds) return;

    _mobileAdsInitializing = true;
    try {
      await MobileAds.instance.initialize();
      _mobileAdsInitialized = true;
      adsReady.value = true;
      _loadInterstitial();
    } finally {
      _mobileAdsInitializing = false;
    }
  }

  void _disableAdsForSession(
    String stage,
    Object error,
    StackTrace stackTrace,
  ) {
    _adsDisabledForSession = true;
    _mobileAdsInitializing = false;
    _mobileAdsInitialized = false;
    _interstitialLoading = false;
    _interstitialShowing = false;
    final ad = _interstitialAd;
    _interstitialAd = null;
    ad?.dispose();
    adsReady.value = false;
    debugPrint('Ads disabled for this session at $stage: $error');
    debugPrintStack(stackTrace: stackTrace);
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
    if (_adsDisabledForSession) return false;
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (error, stackTrace) {
      debugPrint('Privacy options status failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  Future<FormError?> showPrivacyOptions() async {
    if (_adsDisabledForSession) return null;
    try {
      final completer = Completer<FormError?>();
      ConsentForm.showPrivacyOptionsForm((formError) {
        if (!completer.isCompleted) completer.complete(formError);
      });
      final result = await completer.future;
      await _startAdsIfAllowed();
      return result;
    } catch (error, stackTrace) {
      debugPrint('Privacy options form failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  bool get _interstitialEligible {
    if (_adsDisabledForSession || !adsReady.value || !_analysisCompleted) {
      return false;
    }
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

    try {
      ad.show();
      await completer.future;
      return true;
    } catch (error, stackTrace) {
      debugPrint('Interstitial show threw: $error');
      debugPrintStack(stackTrace: stackTrace);
      ad.dispose();
      _interstitialShowing = false;
      _loadInterstitial();
      return false;
    }
  }

  void _loadInterstitial() {
    if (_adsDisabledForSession ||
        !adsReady.value ||
        _interstitialLoading ||
        _interstitialAd != null) {
      return;
    }
    if (_sessionInterstitialCount >= interstitialSessionLimit) return;

    _interstitialLoading = true;
    try {
      InterstitialAd.load(
        adUnitId: AdConfig.interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialLoading = false;
            if (_adsDisabledForSession) {
              ad.dispose();
              return;
            }
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            _interstitialLoading = false;
            debugPrint('Interstitial load failed: $error');
          },
        ),
      );
    } catch (error, stackTrace) {
      _interstitialLoading = false;
      debugPrint('Interstitial load threw: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
