import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_translator/screens/gallery/gallery_screen.dart';
import 'package:image_translator/page_screen.dart';
import 'package:image_translator/recognition_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PageScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(child: Image(image: AssetImage('images/splash.jpeg'),height: 150, width: 200,)) ,
      ),
    );
  }
}
