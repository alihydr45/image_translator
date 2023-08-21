import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.deepOrange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Horizon',
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText('Pro Version is'),
                  TypewriterAnimatedText('unlocking very soon.'),
                  TypewriterAnimatedText('So, please stay tuned!'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
