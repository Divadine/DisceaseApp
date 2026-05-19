import 'package:flutter/material.dart';


class AllInOneModel{
  final List<Triviamodel> trivias;
  final List<CategoryModel> category;
  final List<DisceaseList> disceaseList;

  const AllInOneModel({required this.trivias,required this.category,required this.disceaseList});

  factory AllInOneModel.fromJson(Map<String,dynamic> a){
    final data = a['resultData'];

    return AllInOneModel(
        trivias: (data['trivias'] as  List<dynamic>? ?? [] ).map((e) => Triviamodel.fromJson(e as Map<String, dynamic>,)).toList(),
        category: (data['cat_info'] as  List<dynamic>? ?? []).map((c)=>CategoryModel.fromJson(c as Map<String, dynamic>,)).toList(),
        disceaseList: (data['disease_info'] as  List<dynamic>? ?? []).map((d) => DisceaseList.fromJson(d as Map<String, dynamic>,)).toList(),
    );
  }


}

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

   @override
   String toString() {
     return trivia;
   }
}

//model-2
class DisceaseList{
  final int id;
  final int cat_id;
  final String? disceaseName;


  const DisceaseList({required this.id,required this.cat_id, required this.disceaseName,});

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

  @override
  String toString() {
    return disceaseName ?? "";
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

  @override
  String toString() {
    return name;
  }
}







