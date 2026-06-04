import 'dart:convert';

import 'package:discese_dictionary/models/report_model.dart';
import 'package:http/http.dart' as http;

import '../models/disease_details.dart';
import '../models/triviamodel.dart';

class ApiService {
  final String _baseUrl =
      'https://diseasedictionary.skyraanapps.com/server/api/';

  Future<AllInOneModel> getAllDatas() async {
    final response = await http.post(
      Uri.parse('${_baseUrl}home'),
      body: jsonEncode({
        'last_cat_id': 0,
        'last_disease_id': 0,
        'last_trivia_id': 0,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AllInOneModel.fromJson(data);
    } else {
      print(response.body);
      throw Exception('Failed');
    }
  }

  //2 nd API
  Future<DiseaseDetailsModel> getAllDiseaseDetails(int id) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}disease-details'),
      body: jsonEncode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DiseaseDetailsModel.fromJson(data);
    } else {
      throw Exception('failed');
    }
  }

  // 3rd Api for videos

  Future<List<VideoModel>> getVideosApi(int lastId) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}videos'),
      body: jsonEncode({'last_id': lastId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List videos = data['resultData'];

      return videos.map((e) => VideoModel.fromJson(e)).toList();
    } else {
      throw Exception('no video found');
    }
  }

  //4th Api for Reports

  Future<List<ReportReasonModel>> getReportsReasons() async {
    final response = await http.post(
      Uri.parse(
        'https://diseasedictionary.skyraantech.com/server/api/report-reasons',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (data['result'] == 1) {
      //print(data['resultData']);
      final result = data['resultData']
          .map<ReportReasonModel>((e) => ReportReasonModel.fromJson(e))
          .toList();

      return result;
    }

    return [];
  }

  //5th Api

  Future<bool> submitReport({
    required int typeId,
    required int contentId,
    required int reasonId,
    required int deviceId,
    String? reason,
  }) async {
    final response = await http.post(
      Uri.parse("https://diseasedictionary.skyraantech.com/server/api/report"),
      body: jsonEncode({
        'type_id': typeId,
        'content_id': contentId,
        'reason_id': reasonId,
        'device_id': deviceId,
        'reason': reason,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(response.body);

    if (data['result'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  //6th Api for Video Search

  Future<List<VideoModel>> searchVideos(String searchAlphabet) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}reels/search'),
        body: jsonEncode({'search': searchAlphabet}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final search = data['resultData'];

        return search.map<VideoModel>((s) => VideoModel.fromJson(s)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('error ---------------->>>>> $e');
    }
  }
}
