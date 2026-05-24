import 'dart:core';

import 'package:discese_dictionary/models/disease_details.dart';
import 'package:discese_dictionary/models/triviamodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();

  DbHelper._init();

  Database? db;

  Future get dataBase async {
    if (db != null) return db!;
    db = await initDB();
    return db!;
  }

  Future<Database> initDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'disease_dictionary.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database data, int version) async {
    //trivia table
    await data.execute('''  
  CREATE TABLE trivias(
  id INT PRIMARY KEY ,
  trivia TEXT
  )
  ''');

    //category table
    await data.execute(''' 
  CREATE TABLE category(
  id INT PRIMARY KEY,
  name TEXT,
  image TEXT
  )
  ''');

    //discease list table
    await data.execute(''' 
  CREATE TABLE disceaseList(
   id INT PRIMARY KEY,
   cat_id INT,
   name TEXT 
  ) 
  ''');

    //diseasedetails
    await data.execute('''
    CREATE TABLE diseaseDetails(
    id INT PRIMARY KEY,
    cat_id INT,
    name TEXT,
    image TEXT
    )
    ''');

    //diseaseInfo Table
    await data.execute('''
    CREATE TABLE diseaseInfo(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER,
    title TEXT,
    content TEXT
    )
    ''');

    await data.execute('''
    CREATE TABLE photosTable(
    id INT,
    disease_id INT,
    name TEXT,
    image TEXT
    )
    ''');

    await data.execute('''
    CREATE TABLE videoTable(
    id INTEGER PRIMARY KEY,
    
    disease_id INTEGER,
    name TEXT,
    video TEXT,
    thumbnail_image TEXT,
    description TEXT
    )
    ''');

    await data.execute('''
    CREATE TABLE notesTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER,
    title TEXT,
    content TEXT,
    image TEXT,
    createdDate TEXT
    )
    ''');

    await data.execute('''
    CREATE TABLE bookmarksTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    disease_id INTEGER,
    disease_name TEXT
    )
    ''');
  }

  //firstApi datas
  Future insertTrivias(List<Triviamodel> triviaList) async {
    final dbClient = await dataBase;
    for (var trivia in triviaList) {
      await dbClient.insert(
        'trivias',
        trivia.toTriviaMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future insertCategory(List<CategoryModel> category) async {
    final dbClient = await dataBase;

    for (var cat in category) {
      await dbClient.insert(
        'category',
        cat.CategoryToMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future insertDisease(List<DisceaseList> diseaseList) async {
    final dbClient = await dataBase;
    for (var dis in diseaseList) {
      await dbClient.insert(
        'disceaseList',
        dis.DisceasetoMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Triviamodel>> getTriviaFromDbclient() async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query('trivias');
    return result.map((e) => Triviamodel.fromJson(e)).toList();
  }

  Future<List<CategoryModel>> getCategoryFromDbclient() async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'category',
      orderBy: 'name ASC',
    );
    return result.map((c) => CategoryModel.fromJson(c)).toList();
  }

  Future<List<DisceaseList>> getDiseaseListFromDbclient() async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'disceaseList',
      orderBy: 'name ASC',
    );
    return result.map((d) => DisceaseList.fromJson(d)).toList();
  }

  //2 nd Api datas

  Future insertDiseaseDetails(DiseaseInfo diseaseInfo) async {
    final dbClient = await dataBase;
    await dbClient.insert(
      'diseaseDetails',
      diseaseInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future insertDiseaseInformation(
    int diseaseId,
    List<InfoModel> informatonOfDisease,
  ) async {
    final dbClient = await dataBase;
    for (var info in informatonOfDisease) {
      await dbClient.insert(
        'diseaseInfo',
        info.toMap(diseaseId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future insertPhotos(List<PhotoModel> photosDetails) async {
    final dbClient = await dataBase;
    for (var photo in photosDetails) {
      await dbClient.insert(
        'photosTable',
        photo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> insertVideos(List<VideoModel> videoDetails, int catId) async {
    final dbClient = await dataBase;
    for (var video in videoDetails) {
      await dbClient.insert('videoTable', {
        "id": video.id,
        "disease_id": video.disease_id,
        "cat_id": catId,
        "name": video.name,
        "video": video.video,
        "thumbnail_image": video.thumbnail_image,
        "description": video.description,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<DiseaseInfo>> getDiseaseInfoFromDbClient() async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'diseaseDetails',
    );
    return result
        .map(
          (e) => DiseaseInfo(
            id: e['id'],
            cat_id: e['cat_id'],
            name: e['name'],
            image: e['image'],
            info: [],
          ),
        )
        .toList();
  }

  Future<List<InfoModel>> getInformationFromDbClient(int diseaseId) async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'diseaseInfo',
      where: 'disease_id = ?',
      whereArgs: [diseaseId],
    );
    return result.map((c) => InfoModel.fromJson(c)).toList();
  }

  Future<List<PhotoModel>> getPhotosFromDbClient(int diseaseId) async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'photosTable',
      where: 'disease_id = ?',
      whereArgs: [diseaseId],
    );
    return result.map((p) => PhotoModel.fromJson(p)).toList();
  }

  Future<List<VideoModel>> getVideosFromDbClient(int diseaseId) async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'videoTable',
      where: 'disease_id = ?',
      whereArgs: [diseaseId],
    );

    print("Fetched videos from DB: $result");
    return result.map((v) => VideoModel.fromJson(v)).toList();
  }

  Future<List<DisceaseList>> getDiseaseById(int catId) async {
    final dbClient = await dataBase;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'disceaseList',
      where: 'cat_id = ?',
      whereArgs: [catId],
    );

    return result.map((e) => DisceaseList.fromJson(e)).toList();
  }

  //notes datas

  Future<int> insertNotes({
    required int diseaseId,
    required String title,
    required String content,
    required String image,
  }) async {
    final dbClient = await dataBase;

    return await dbClient.insert('notesTable', {
      "disease_id": diseaseId,
      "title": title,
      "content": content,
      "image": image,
      "createdDate": DateTime.now().toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getNotes(int diseaseId) async {
    final dbClient = await dataBase;

    return await dbClient.query(
      "notesTable",
      where: "disease_id= ?",
      whereArgs: [diseaseId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final dbClient = await dataBase;

    return await dbClient.query("notesTable", orderBy: "createdDate DESC");
  }

  Future<bool> checkNotesExist(int diseaseId) async {
    final dbClient = await dataBase;

    final result = await dbClient.query(
      "notesTable",
      where: "disease_id =?",
      whereArgs: [diseaseId],
    );

    return result.isNotEmpty;
  }

  Future<int> updateNotes({
    required int id,
    required String title,
    required String content,
  }) async {
    final dbClient = await dataBase;

    return await dbClient.update(
      "notesTable",
      {"title": title, "content": content},
      where: "id= ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteNotes(int id) async {
    final dbClient = await dataBase;
    return await dbClient.delete(
      "notesTable",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //bookmark datas

  Future insertBookmarks({
    required int diseaseId,
    required String diseaseName,
  }) async {
    final dbClient = await dataBase;

    return await dbClient.insert('bookmarksTable', {
      'disease_id': diseaseId,
      'disease_name': diseaseName,
    });
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final dbClient = await dataBase;

    return await dbClient.query('bookmarksTable');
  }

  Future deleteBookmarks(int diseaseId) async {
    final dbClient = await dataBase;

    return await dbClient.delete(
      'bookmarksTable',
      where: 'disease_id = ?',
      whereArgs: [diseaseId],
    );
  }

  Future<bool> checkBookmarksExists(int diseaseId) async {
    final dbClient = await dataBase;

    final result = await dbClient.query(
      'bookmarksTable',
      where: 'disease_id = ?',
      whereArgs: [diseaseId],
    );

    return result.isNotEmpty;
  }

  //videos

  Future<List<VideoModel>> getAllVideos() async {
    final dbClient = await dataBase;

    final List<Map<String, dynamic>> result = await dbClient.query(
      'videoTable',
      orderBy: 'id DESC',
    );

    return result.map((v) => VideoModel.fromJson(v)).toList();
  }
}
