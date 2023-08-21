/// This code screen is for OCR api recognition.
/// This is left in the project as it is also a solution for our project. Means, there are two ways to solve our issue
/// You can  any one you like.

import 'dart:developer';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_translator/utils.dart';
import 'package:share_plus/share_plus.dart';

class GalleryResultScreen extends StatefulWidget {
  final String? path;
  const GalleryResultScreen({Key? key, this.path}) : super(key: key);

  @override
  State<GalleryResultScreen> createState() => _GalleryResultScreenState();
}

class _GalleryResultScreenState extends State<GalleryResultScreen> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Recognized Text")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _isBusy == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        maxLines: MediaQuery.of(context).size.height.toInt(),
                        controller: controller,
                        decoration:
                            const InputDecoration(hintText: "Text goes here..."),
                      ),
                    ),
            ],
          ),
        ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              FlutterClipboard.copy(controller.text).then((value) {
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
            onPressed: () => Share.share(controller.text),
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

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    controller.text = recognizedText.text;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }
}
