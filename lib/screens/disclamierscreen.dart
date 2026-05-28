import 'package:flutter/material.dart';

import '../sharedwidgtes/disclamier_contents.dart';
import '../utils/app_utils.dart';
import 'disceasedict_homeScreen.dart';

class Disclamierscreen extends StatefulWidget {
  const Disclamierscreen({super.key});

  @override
  State<Disclamierscreen> createState() => _DisclamierScreenState();
}

class _DisclamierScreenState extends State<Disclamierscreen> {
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
          DisclamierscreenContents(),

          //3--checkbox
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },

            title: Text(
              "I am aware that this app is for reference only and not for medical advice.",
              style: TextStyle(fontSize: 10),
            ),
          ),

          //SizedBox(height: 10,),

          //4--button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              backgroundColor: ColorUtils.selectedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            onPressed: isChecked
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => DisceaseDictionary()),
                    );
                  }
                : null,
            child: Text(
              "Continue",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
