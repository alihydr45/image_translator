import 'dart:convert';
import 'dart:io';
import 'dart:io' as Ios;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_translator/constants.dart';
import 'package:image_translator/constants/ads.dart';
import 'package:image_translator/pro_screen.dart';
import 'package:image_translator/screens/gallery/gallery_screen.dart';
import 'package:image_translator/screens/ads/interstitial_ad.dart';
import 'package:image_translator/screens/camera/camera_screen.dart';
import 'package:image_translator/recognition_screen.dart';
import 'package:image_translator/splash_screen.dart';
import 'package:image_translator/utils.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
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

  File? pickedImage;
  bool scanning = false;
  String scannedText = '';
  Future<void> pickImage(ImageSource source) async {
    // final pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    // final pickedCameraFile =
    //     await ImagePicker().pickImage(source: ImageSource.camera);
    // if (pickedFile != null || pickedCameraFile != null) {
    //   setState(() {
    //     scanning = true;
    //     pickedImage = File(pickedFile!.path);
    //   });
    // }
    // Navigator.pop(context);
    print('source::::::$source');
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final imagePermanent = File(img.path);
      setState(() {
        pickedImage = imagePermanent;
        scanning = true;
      });
      print('pickedImage:::::::$pickedImage');

      ////////////////////////////
      // Prepare the image
      Uint8List bytes = Ios.File(pickedImage!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);

      //Send to Api

      String url = kUri;
      var data = {'base64Image': 'data:image/jpg;base64,$img64'};
      var header = {'apikey': kApiKey};
      http.Response response =
          await http.post(Uri.parse(url), body: data, headers: header);

      //Get data back
      Map result = jsonDecode(response.body);
      print(result);
      print(result['ParsedResults'][0]['ParsedText']);
      setState(() {
        scanning = false;
        scannedText = result['ParsedResults'][0]['ParsedText'];
      });
    } catch (e) {
      print(e);
      print('exception::::::');
      debugPrint(e.toString());
    }
  }

  AppOpenAd? appOpenAd;
  loadAppOpenAd() {
    AppOpenAd.load(
        adUnitId: actOpenId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          appOpenAd = ad;
          appOpenAd!.show();
        }, onAdFailedToLoad: (error) {
          print(error);
        }),
        orientation: AppOpenAd.orientationPortrait);
  }

  loadAppOpenAdd() async {
    await loadAppOpenAd().then((value) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAppOpenAdd();
    initBannerAd();
    InterstitialAdScreenState.initInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff3467b8),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: const Color(0xff184fa9),
            onTap: () async {
              if (InterstitialAdScreenState.isInAdLoaded) {
                await InterstitialAdScreenState.interstitialAd.show();
              }
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProScreen()));
            },
            leading: const Icon(
              FontAwesomeIcons.crown,
              color: Color(0xfff8b228),
              size: 35,
            ),
            title: const Text(
              'Unlock Image Translator Pro!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Choose Your Image',
              style: textStyle(25, Colors.white, FontWeight.w500),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async{
                    if(InterstitialAdScreenState.isInAdLoaded){
                      await InterstitialAdScreenState.interstitialAd.show();
                    }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CameraScreen()));
                  // pickImage(ImageSource.camera);
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xff184fa9),
                  radius: 50,
                  child: Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  if (InterstitialAdScreenState.isInAdLoaded) {
                  await InterstitialAdScreenState.interstitialAd.show();
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryScreen()));
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xff184fa9),
                  radius: 50,
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
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
