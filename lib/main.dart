import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_translator/screens/ads/ad_screen.dart';
import 'package:image_translator/page_screen.dart';
import 'package:image_translator/splash_screen.dart';

void main() async {
  // var devices = ["C44B352AB59CF22DCB33CE4C7013CACA"];
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  // RequestConfiguration requestConfiguration =
  //     RequestConfiguration(testDeviceIds: devices);
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Translator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
