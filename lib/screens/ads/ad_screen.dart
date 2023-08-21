import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_translator/constants/ads.dart';
import 'package:image_translator/screens/ads/interstitial_ad.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAd();
  }
  late BannerAd bannerAd;
  bool isAdLoaded = false;

  initBannerAd(){
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: actBannerId,
        listener: BannerAdListener(
          onAdLoaded: (ad){
            setState(() {
              isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error){
            ad.dispose();
            print(error);
          }
        ),
        request: const AdRequest(),
    );
    bannerAd.load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ads'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 50,),
          isAdLoaded ? Container(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: AdWidget(ad: bannerAd)
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
