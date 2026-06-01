import 'dart:async';

import 'package:discese_dictionary/api/apiservice.dart';
import 'package:discese_dictionary/screens/mainscreen.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

import 'databasehelper/app_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppUtils.reportList = await ApiService().getReportsReasons();
  await AppPreference.init();
  runApp(MyApp());
}

StreamController<Color> colorCtrl = StreamController.broadcast();
StreamController<String> fontCtrl = StreamController.broadcast();
StreamController<bool> themeCtrl = StreamController.broadcast();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: themeCtrl.stream,
      initialData: AppPreference.getTheme(),
      builder: (context, themeSnapshot) {
        return StreamBuilder<String>(
          stream: fontCtrl.stream,
          initialData: AppPreference.getFontChange(),
          builder: (context, fontSnapshot) {
            return StreamBuilder<Color>(
              stream: colorCtrl.stream,
              builder: (context, colorSnapshot) {
                return MaterialApp(
                  theme: ThemeData(
                    scaffoldBackgroundColor: themeSnapshot.data!
                        ? Colors.black
                        : Colors.white,
                    appBarTheme: AppBarTheme(
                      backgroundColor: themeSnapshot.data!
                          ? Colors.black
                          : ColorUtils.selectedColor,
                    ),
                    brightness: themeSnapshot.data!
                        ? Brightness.dark
                        : Brightness.light,
                    primaryColor: colorSnapshot.data,
                    fontFamily: fontSnapshot.data,
                  ),
                  home: Mainscreen(),
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        );
      },
    );
  }
}
