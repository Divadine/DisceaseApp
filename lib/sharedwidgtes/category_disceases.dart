import 'package:discese_dictionary/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CategoryDisceases  extends StatelessWidget {

  final String name;
  const CategoryDisceases({super.key,required this.name});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("name"),
        centerTitle: true,
        backgroundColor: ColorUtils.selectedColor,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Disease",style: TextStyle(color: Colors.white),),
              Text("videos", style: TextStyle(color: Colors.white,),)
            ],
          ),
        ],
      )
    );
  }
}