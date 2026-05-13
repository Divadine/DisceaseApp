import 'package:discese_dictionary/models/triviamodel.dart';
import 'package:flutter/material.dart';

class CategorycardViewall extends StatelessWidget {

  final CategoryModel categorynames;
  const CategorycardViewall({super.key,required this.categorynames});


  @override
  Widget build (BuildContext context){
    return GestureDetector(

      onTap: (){

      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          image:DecorationImage(image: NetworkImage(categorynames.image),fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(categorynames.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
        ),
      ),
    );
  }

}