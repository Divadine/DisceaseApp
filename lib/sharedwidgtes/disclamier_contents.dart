import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';

import '../utils/app_utils.dart';

class DisclamierscreenContents extends StatefulWidget {
  const DisclamierscreenContents({super.key});

  @override
  State<DisclamierscreenContents> createState() =>
      _DisclamierScreenContentState();
}

class _DisclamierScreenContentState extends State<DisclamierscreenContents> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Disclaimer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ColorUtils.selectedColor,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //1--image
          Image.asset(AssetImages.disclamierImage, height: 100),
          SizedBox(height: 10),
          //2--content Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "The information provided in this app is for general educational purposes only."
              " It is not intended to replace professional medical advice, diagnosis, or treatment. Each individual’s health condition is different, and symptoms or disease progression may vary from person to person. Always consult a qualified healthcare professional if you feel unwell or have any concerns. We are not responsible for any outcomes, misinterpretation, "
              "or misuse of the information provided. "
              "Use this app for knowledge and awareness only, not for self-diagnosis or treatment.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
