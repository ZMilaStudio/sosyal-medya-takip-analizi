abstract final class AdConfig {
  static const bool useTestIds = bool.fromEnvironment(
    'ADMOB_USE_TEST_IDS',
    defaultValue: true,
  );

  static const String _liveBannerUnitId = String.fromEnvironment(
    'ADMOB_BANNER_UNIT_ID',
  );
  static const String _liveInterstitialUnitId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_UNIT_ID',
  );

  static const String _androidTestBannerUnitId =
      'ca-app-pub-3940256099942544/9214589741';
  static const String _androidTestInterstitialUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static String get bannerUnitId =>
      useTestIds ? _androidTestBannerUnitId : _liveBannerUnitId;

  static String get interstitialUnitId => useTestIds
      ? _androidTestInterstitialUnitId
      : _liveInterstitialUnitId;

  static bool get hasAdUnitIds =>
      bannerUnitId.isNotEmpty && interstitialUnitId.isNotEmpty;
}
