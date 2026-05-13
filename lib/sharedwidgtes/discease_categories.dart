import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/triviamodel.dart';

class DisceaseCategories extends StatelessWidget {

  final CategoryModel  category;

  const DisceaseCategories({super.key, required this.category});

  @override
  Widget build(BuildContext context){
    return Container(
      height: 100,

      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius:BorderRadius.circular(18),
        image: DecorationImage(image: NetworkImage(category.image),
          fit:  BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: AlignmentGeometry.bottomCenter,
          child: Text(category.name, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),)),
    );
  }
}