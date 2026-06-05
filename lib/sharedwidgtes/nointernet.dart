import 'package:discese_dictionary/databasehelper/app_preference.dart';
import 'package:discese_dictionary/databasehelper/font_helper.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:discese_dictionary/utils/imagesutils.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final VoidCallback onTap;

  const NoInternet({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetImages.nointernet),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AppText(
                text:
                    ' "Please check your internet connection and try again." ',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: appTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPreference.getTheme()
                    ? Colors.transparent
                    : ColorUtils.selectedColor,
              ),
              onPressed: onTap,
              child: AppText(
                text: 'Retry',
                style: appTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
