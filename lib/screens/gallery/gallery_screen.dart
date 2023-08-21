import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_translator/constants/ads.dart';
import 'package:image_translator/screens/ads/interstitial_ad.dart';
import 'package:image_translator/utils.dart';
import 'gallery_result_screen.dart';
import '../../utils/image_cropper_page.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Future<String> pickImage({ImageSource? source}) async {
    final picker = ImagePicker();

    String path = '';

    try {
      final getImage = await picker.pickImage(source: source!);

      if (getImage != null) {
        path = getImage.path;
      } else {
        path = '';
      }
    } catch (e) {
      log(e.toString());
    }
    return path;
  }
  late BannerAd bannerAd;
  bool isAdLoaded = false;

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: actBannerId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        print(error);
      }),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAd();
    InterstitialAdScreenState.initInterstitialAd();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Choose your Image',style: textStyle(25, Color(0xff1738EB), FontWeight.w700),),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .3,),
            GestureDetector(
                onTap: () async{
                  if (InterstitialAdScreenState.isInAdLoaded) {
                  await InterstitialAdScreenState.interstitialAd.show();}
                  pickImage(source: ImageSource.gallery).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => GalleryResultScreen(
                                path: value,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  });
                },
                child: Center(
                    child: Image.asset(
                  'images/select.png',
                  height: 100,
                  width: 150,
                ))),
          ],
        ),
      ),
      bottomNavigationBar: isAdLoaded
          ? Container(
          height: bannerAd.size.height.toDouble(),
          width: bannerAd.size.width.toDouble(),
          child: AdWidget(ad: bannerAd))
          : const SizedBox(),
    );
  }
}
