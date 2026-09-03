import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';
import 'ads_coordinator.dart';

class AnchoredAdaptiveAdBanner extends StatefulWidget {
  const AnchoredAdaptiveAdBanner({super.key});

  @override
  State<AnchoredAdaptiveAdBanner> createState() =>
      _AnchoredAdaptiveAdBannerState();
}

class _AnchoredAdaptiveAdBannerState extends State<AnchoredAdaptiveAdBanner> {
  BannerAd? _bannerAd;
  bool _loading = false;
  int? _loadedWidth;

  AdsCoordinator get _ads => AdsCoordinator.instance;

  @override
  void initState() {
    super.initState();
    _ads.adsReady.addListener(_onAdStateChanged);
    _ads.bannerSuppressed.addListener(_onAdStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoad());
  }

  @override
  void dispose() {
    _ads.adsReady.removeListener(_onAdStateChanged);
    _ads.bannerSuppressed.removeListener(_onAdStateChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onAdStateChanged() {
    if (!mounted) return;
    if (_ads.bannerSuppressed.value || !_ads.adsReady.value) {
      _disposeBanner();
      return;
    }
    _maybeLoad();
  }

  void _disposeBanner() {
    final ad = _bannerAd;
    _bannerAd = null;
    _loadedWidth = null;
    if (ad != null) ad.dispose();
    if (mounted) setState(() {});
  }

  Future<void> _maybeLoad() async {
    if (!mounted || _loading || _bannerAd != null) return;
    if (!_ads.adsReady.value || _ads.bannerSuppressed.value) return;

    final width = MediaQuery.sizeOf(context).width.truncate();
    if (width <= 0) return;

    _loading = true;
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted) {
      _loading = false;
      return;
    }
    if (size == null) {
      _loading = false;
      return;
    }

    final ad = BannerAd(
      adUnitId: AdConfig.bannerUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted || _ads.bannerSuppressed.value) {
            loadedAd.dispose();
            return;
          }
          setState(() {
            _loading = false;
            _bannerAd = loadedAd as BannerAd;
            _loadedWidth = width;
          });
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (!mounted) return;
          setState(() => _loading = false);
          debugPrint('Banner load failed: $error');
        },
      ),
    );
    ad.load();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.sizeOf(context).width.truncate();
    if (_loadedWidth != null && _loadedWidth != currentWidth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _disposeBanner();
        _maybeLoad();
      });
    }

    final ad = _bannerAd;
    if (ad == null || _ads.bannerSuppressed.value) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(top: 4),
        child: Center(
          child: SizedBox(
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ),
      ),
    );
  }
}
