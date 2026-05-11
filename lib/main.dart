import 'package:discese_dictionary/screens/onboardingscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


void main(){
  runApp(MyApp());
}


class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: DisceseApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}