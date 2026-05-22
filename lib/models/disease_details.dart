import 'package:flutter/material.dart';

//model -1
class DiseaseDetailsModel {
  final int result;
  final DiseaseResutDataModel resultData;
  final String message;

  const DiseaseDetailsModel({required this.result,required this.resultData,required this.message});

  factory DiseaseDetailsModel.fromJson(Map<String,dynamic> e){
    return DiseaseDetailsModel(
        result: e['result'],
        resultData: DiseaseResutDataModel.fromJson(e['resultData']),
        message: e['message']);
  }

}


//model-2
class DiseaseResutDataModel {
  final DiseaseInfo disease_info;
  final List<PhotoModel> photos;
  final List<VideoModel> videos;

  const DiseaseResutDataModel({required this.disease_info, required this.photos, required this.videos});

  factory DiseaseResutDataModel.fromJson(Map<String, dynamic> a){
    return DiseaseResutDataModel(
        disease_info: DiseaseInfo.fromJson(a['disease_info']),
        photos: (a['photos'] as List).map((e) => PhotoModel.fromJson(e)).toList(),
        videos: (a['videos'] as List).map((c) => VideoModel.fromJson(c)).toList(),
    );
  }
}


//model-3
class DiseaseInfo{
  final int id;
  final int cat_id;
  final String name;
  final String image;
  final List<InfoModel> info;

  DiseaseInfo({required this.id, required this.cat_id, required this.name, required this.image, required this.info});

  factory DiseaseInfo.fromJson(Map<String,dynamic> json){
    return DiseaseInfo(
        id: json['id'],
        cat_id: json['cat_id'],
        name: json['name'],
        image: json['image'],
        info: (json['info'] as List).map((d) => InfoModel.fromJson(d)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'cat_id' : cat_id,
      'name' : name,
      'image' : image
    };
  }
}


//model-4
class InfoModel{
  //final String disease_id;
  final String title;
  final String content;

  InfoModel({required this.title, required this.content, });

  factory InfoModel.fromJson(Map<String, dynamic> json){
    return InfoModel(title: json['title'], content: json['content'], );
  }

  Map<String,dynamic> toMap(int diseaseId){
    return {
      'disease_id' : diseaseId,
      'title' : title,
      'content' : content
    };
  }
}

//model-5
class PhotoModel {
  final int id;
  final int disease_id;
  final String name;
  final String image;

  PhotoModel({required this.id, required this.disease_id, required this.name, required this.image});

  factory PhotoModel.fromJson(Map<String,dynamic> json){
    return PhotoModel(
        id: json['id'], disease_id: json['disease_id'], name: json['name'], image: json['image'],
    );
  }

  Map<String , dynamic> toMap() {
    return {
      'id' : id,
      'disease_id' : disease_id,
      'name' : name,
      'image' : image,
    };
  }
}


//model-6
class VideoModel{
  final int id;

  final int disease_id;
  final String name;
  final String video;
  final String thumbnail_image;
  final String description;

  VideoModel({required this.id, required this.disease_id, required this.name, required this.video, required this.thumbnail_image, required this.description,  });

  factory VideoModel.fromJson(Map<String, dynamic> json){
    return VideoModel(id: json['id'], disease_id: json['disease_id'], name: json['name'], video: json['video'], thumbnail_image: json['thumbnail_image'], description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'disease_id' : disease_id,

      'name' : name,
      'video' : video,
      'thumbnail_image' : thumbnail_image,
      'description': description,
    };
  }
}