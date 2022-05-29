import 'dart:io' show Platform;

class AdmobService {
  static String appIDTest1 =
      Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';

  static bool testMode = true;
  static String get bannerAdUnitId {
    if (testMode) {
      return appIDTest1;
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7827652182414574/9297808857';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7827652182414574/9297808857';
    } else {
      return "";
    }
  }

//Canlı
//AddroidManifest.xml "ca-app-pub-7827652182414574~1885334648"

//"ca-app-pub-7827652182414574/9297808857"

}

/*


App Open	ca-app-pub-3940256099942544/3419835294
Banner	ca-app-pub-3940256099942544/6300978111
Interstitial	ca-app-pub-3940256099942544/1033173712
Interstitial Video	ca-app-pub-3940256099942544/8691691433
Rewarded	ca-app-pub-3940256099942544/5224354917
Rewarded Interstitial	ca-app-pub-3940256099942544/5354046379
Native Advanced	ca-app-pub-3940256099942544/2247696110
Native Advanced Video	ca-app-pub-3940256099942544/1044960115
 */
