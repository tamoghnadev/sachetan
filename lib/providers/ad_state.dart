// import 'dart:io';
//
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdState {
//   Future<InitializationStatus> initialization;
//
//   AdState(this.initialization);
//
//   String get bannerAdUnitId => Platform.isAndroid
//       ? 'YOUR_ADMOB_KEY_FOR_ANDROID'
//       : 'YOUR_ADMOB_KEY_FOR_IOS';
//
//   BannerAdListener get adListner => _adListener;
//
//   final BannerAdListener _adListener = BannerAdListener(
//     // Called when an ad is successfully received.
//     onAdLoaded: (Ad ad) => print('Ad loaded.'),
//     // Called when an ad request failed.
//     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//       // Dispose the ad here to free resources.
//       ad.dispose();
//     },
//     // Called when an ad opens an overlay that covers the screen.
//     onAdOpened: (Ad ad) => print('Ad opened.'),
//     // Called when an ad removes an overlay that covers the screen.
//     onAdClosed: (Ad ad) => print('Ad closed.'),
//     // Called when an impression occurs on the ad.
//     onAdImpression: (Ad ad) => print('Ad impression.'),
//   );
// }
