import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? appliedFont;
  final String text =
      'Acne is a common skin condition that occurs when hair follicles become.';

  @override
  void initState() {
    super.initState();
    loadSavedFont();
  }

  Future<void> loadSavedFont() async {
    final prefs = await SharedPreferences.getInstance();
    String savedFont = prefs.getString("app_font") ?? 'Inter';
    setState(() {
      selectedFont = savedFont;
      appliedFont = savedFont;
    });
  }

  Future<void> saveFont() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("app_font", selectedFont!);
    setState(() {
      appliedFont = selectedFont;
    });
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
        title: Text(
          'Font Style',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorUtils.selectedColor,
      ),

      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Preview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
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
                child: Text(
                  text,
                  style: AppFonts.getFont(selectedFont ?? "Inter"),

                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 30),

            Center(
              child: Text(
                'Choose Font',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
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
                    title: Text(value),
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
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
                SizedBox(width: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorUtils.selectedColor,
                  ),
                  onPressed: saveFont,
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
