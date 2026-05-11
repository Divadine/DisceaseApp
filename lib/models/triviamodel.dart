import 'package:flutter/material.dart';


//model-1
class Triviamodel {
   final int id;
   final  String trivia;

   const Triviamodel({required this.id,required this.trivia});


   factory Triviamodel.fromJson(Map<String,dynamic> e){
     return Triviamodel(
       id: e['id'],
       trivia: e['trivia'],
     );
   }


   Map<String, dynamic> toTriviaMap(){
     return{
       'id' : id,
       'trivia' : trivia

     };
   }
}

//model-2
class DisceaseList{
  final int? id;
  final int? cat_id;
  final String? disceaseName;


  const DisceaseList({this.id,this.cat_id,this.disceaseName,});

  factory DisceaseList.fromJson(Map<String,dynamic> d){
    return DisceaseList(
      id:d['id'],
      cat_id: d['cat_id'],
        disceaseName: d['name'],


    );
  }

  Map<String,dynamic> DisceasetoMap(){
    return{
      'id' : id,
      'cat_id' : cat_id,
      'name' : disceaseName,

    };
  }
}

//model-3

class CategoryModel{
  final int id;
  final String name;
  final String image;

  const CategoryModel({required this.id,required this.name,required this.image});

  factory CategoryModel.fromJson(Map<String,dynamic> c){
    return CategoryModel(
        id: c['id'],
        name: c['name'],
        image: c['image']
    );
  }

  Map<String,dynamic> CategoryToMap(){
    return {
      'id':id,
      'name':name,
      'image' : image
    };
  }
}







