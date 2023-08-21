import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_translator/utils.dart';
import 'package:share_plus/share_plus.dart';

class CameraResultScreen extends StatelessWidget {

  final String text;

  const CameraResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Result'),
    ),
    body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Text(text,style: textStyle(20, const Color(0xff1738EB), FontWeight.w500),),
      ),
    ),
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: null,
          onPressed: () {
            FlutterClipboard.copy(text).then((value) {
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
          onPressed: () => Share.share(text),
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
