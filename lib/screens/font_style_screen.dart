import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class FontStyleScreen extends StatefulWidget {
  const FontStyleScreen({super.key});

  @override
  State<FontStyleScreen> createState() => _FontStyleScreenState();
}

class _FontStyleScreenState extends State<FontStyleScreen> {
  final List<String> fonts = [
    "Inter",
    "Poppins",
    "Roboto Serif",
    "Open Sans",
    "Nunito Sans",
  ];
  String? selectedFont;
  final String texts =
      'Acne is a common skin condition that occurs when hair follicles become.';

  @override
  void initState() {
    super.initState();
    loadSavedFont();
  }

  Future<void> loadSavedFont() async {
    selectedFont = AppPreference.getFontChange() ?? "Inter";
    setState(() {});
  }

  Future<void> saveFont() async {
    await AppPreference.setFontChange(selectedFont ?? 'Inter');
    fontCtrl.sink.add(selectedFont ?? 'Inter');
    Navigator.pop(context, selectedFont);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        centerTitle: true,
        title: AppText(
          text: 'Font Style',
          style: appTextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        //Text(
        //   'Font Style',
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.white,
        //   ),
        // ),
        backgroundColor: AppPreference.getTheme()
            ? Theme.of(context).scaffoldBackgroundColor
            : ColorUtils.selectedColor,
      ),

      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: AppText(
                text: 'Preview',
                style: appTextStyle(
                  color: AppPreference.getTheme() ? Colors.white : Colors.black,
                ),
              ),
              //Text(
              //   'Preview',
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //     color: Colors.black,
              //   ),
              // ),
            ),
            SizedBox(height: 20),

            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                //border: Border.all(color: ColorUtils.selectedColor),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: AppText(
                  text: texts,
                  style: AppFonts.getFont(selectedFont ?? 'Inter').copyWith(
                    color: AppPreference.getTheme() ? Colors.black : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                //Text(
                //   text,
                //   style: AppFonts.getFont(selectedFont ?? "Inter"),
                //
                //   textAlign: TextAlign.center,
                // ),
              ),
            ),

            SizedBox(height: 30),

            Center(
              child: AppText(
                text: 'Choose Font',

                style: appTextStyle(
                  color: AppPreference.getTheme() ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              // Text(
              //   'Choose Font',
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //     color: Colors.black,
              //   ),
              // ),
            ),

            SizedBox(height: 20),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: fonts.map((value) {
                  return RadioListTile<String>(
                    title: AppText(text: value),
                    //Text(value),
                    value: value,
                    groupValue: selectedFont,
                    activeColor: ColorUtils.selectedColor,
                    onChanged: (value) {
                      setState(() {
                        selectedFont = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppText(
                    text: 'Cancel',
                    style: appTextStyle(
                      fontSize: 15,
                      color: AppPreference.getTheme()
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  // Text(
                  //   'Cancel',
                  //   style: TextStyle(fontSize: 15, color: Colors.black),
                  // ),
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtils.selectedColor,
                  ),
                  onPressed: saveFont,
                  child: AppText(
                    text: 'Apply',
                    style: appTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // Text(
                  //   'Apply',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //     fontSize: 15,
                  //   ),
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
