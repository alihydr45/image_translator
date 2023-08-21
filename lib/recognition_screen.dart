import 'dart:convert';
import 'dart:io';
import 'dart:io' as Ios;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_translator/constants.dart';
import 'package:image_translator/constants/ads.dart';
import 'package:image_translator/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share_plus/share_plus.dart';
import 'screens/ads/interstitial_ad.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  File? pickedImage;
  bool scanning = false;
  String scannedText = '';

  // optionsDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return SimpleDialog(
  //           children: [
  //             SimpleDialogOption(
  //               onPressed: () async{
  //                 if(InterstitialAdScreenState.isInAdLoaded){
  //                   await InterstitialAdScreenState.interstitialAd.show();
  //                 }
  //                 Navigator.pop(context);
  //                 pickImage(ImageSource.gallery);
  //               },
  //               child: Text(
  //                 'Gallery',
  //                 style: textStyle(20, Colors.black, FontWeight.w800),
  //               ),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () {
  //                 // Navigator.pop(context);
  //                 pickImage(ImageSource.camera);
  //                 // Navigator.pop(context);
  //               },
  //               child: Text(
  //                 'Camera',
  //                 style: textStyle(20, Colors.black, FontWeight.w800),
  //               ),
  //             ),
  //             SimpleDialogOption(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text(
  //                 'Cancel',
  //                 style: textStyle(20, Colors.black, FontWeight.w800),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

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
      if (kDebugMode) {
        print('exception::::::');
      }
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const Text('Show Dialog');
    GdprDialog.instance.resetDecision();
    GdprDialog.instance
        .showDialog(isForTest: false, testDeviceId: '')
        .then((onValue) {
      setState(() {
        status = 'dialog result == $onValue';
      });
    });
    // InterstitialAdScreenState.initInterstitialAd();
    initBannerAd();
  }

  String status = 'none';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FB),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 55 + MediaQuery.of(context).viewInsets.top,
              ),
              Text(
                'Select Image',
                style: textStyle(35, const Color(0xff1738EB), FontWeight.w800),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: ()  {
                  // if (InterstitialAdScreenState.isInAdLoaded) {
                  //   await InterstitialAdScreenState.interstitialAd
                  //       .show()
                  //       .then((value) =>
                        pickImage(ImageSource.gallery);
                  // }
                },
                child: pickedImage == null
                    ? const Icon(
                        FontAwesomeIcons.fileLines,
                        size: 100,
                        color: Colors.grey,
                      )
                    // Image.asset('images/select.png',height: 250, width: 250,)
                    : Image(
                        height: 240,
                        width: 240,
                        image: FileImage(pickedImage!),
                        // pickedImage == null
                        //     ?  const AssetImage('images/select.png')
                        //     : FileImage(pickedImage!)  ,
                        fit: BoxFit.fill,
                      ),
              ),
              const SizedBox(
                height: 5,
              ),
              isAdLoaded
                  ? Container(
                      height: bannerAd.size.height.toDouble(),
                      width: bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd))
                  : const SizedBox(),
              scanning == true
                  ? Text(
                      'Scanning...',
                      style: textStyle(30, Colors.black, FontWeight.w700),
                    )
                  : Text(
                      scannedText,
                      style: textStyle(
                          25, const Color(0xff1738EB), FontWeight.w600),
                      textAlign: TextAlign.center,
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              FlutterClipboard.copy(scannedText).then((value) {
                SnackBar snackBar = SnackBar(
                  content: Text(
                    'Copied to Clipboard',
                    style: textStyle(18, Colors.white, FontWeight.w700),
                  ),
                  duration: const Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
            child: const Icon(
              Icons.copy,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: const Color(0xffEC360E),
            onPressed: () => Share.share(scannedText),
            child: const Icon(
              Icons.reply_outlined,
              size: 35,
              color: Color(0xffF8F9FB),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
