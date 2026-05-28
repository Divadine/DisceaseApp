import 'dart:async';

import 'package:discese_dictionary/api/apiservice.dart';
import 'package:discese_dictionary/screens/mainscreen.dart';
import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

void main() async {
  AppUtils.reportList = await ApiService().getReportsReasons();
  runApp(MyApp());
}

StreamController<bool> themeCtrl = StreamController.broadcast();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: themeCtrl.stream,
      builder: (context, asyncSnapshot) {
        return MaterialApp(
          home: Mainscreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
