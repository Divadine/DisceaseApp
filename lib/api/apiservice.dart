import 'dart:convert';

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
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AllInOneModel.fromJson(data);
    } else {
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
      print(data);
      List videos = data['resultData'];
      print(videos.length);
      return videos.map((e) => VideoModel.fromJson(e)).toList();
    } else {
      throw Exception('no video found');
    }
  }
}

// class AppNetwork {
//   final String _baseUrl = 'https://diseasedictionary.skyraanapps.com/server/api/';
//   final Duration _timeoutDuration = const Duration(seconds: 30);
//
//   String _constructUrl(String route) {
//     return '$_baseUrl$route';
//   }
//
//   final token = '';
//
//   ///get
//   Future<ResponseModel?> get(String route) async {
//     try {
//       final response = await http
//           .get(
//         Uri.parse('$_baseUrl$route'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': token,
//         },
//       )
//           .timeout(_timeoutDuration);
//       return _handleResponse(response);
//     } catch (e) {
//       debugPrint('Failed to load data from api: $e');
//       return null;
//     }
//   }
//
//   /// post
//   Future<ResponseModel?> post(String route, Map<String, dynamic> body) async {
//     try {
//       print('URL : ${_constructUrl(route)} PARAMS: $body');
//       final response = await http
//           .post(
//         Uri.parse(_constructUrl(route)),
//         headers: {
//           'Content-Type': 'application/json',
//           'authorization': 'Bearer ${body['token']}',
//         },
//         body: jsonEncode(body),
//       ).timeout(_timeoutDuration);
//       print('Response data: ${response.body}');
//       return _handleResponse(response);
//     } catch (e) {
//       debugPrint('Failed to post data: $e');
//       return ResponseModel(
//         message: 'Failed to post data: $e',
//         status: false,
//         statusCode: null,
//         data: null,
//       );
//     }
//   }
//
//   /// put
//   Future<ResponseModel?> put(String route, Map<String, dynamic> body) async {
//     try {
//       print('URL : ${_constructUrl(route)} PARAMS: $body');
//       final response = await http
//           .put(
//         Uri.parse(_constructUrl(route)),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${body['token']}',
//         },
//         body: jsonEncode(body),
//       )
//           .timeout(_timeoutDuration);
//       print('Response data: ${response.body}');
//       return _handleResponse(response);
//     } catch (e) {
//       debugPrint('Failed to put data: $e');
//       return ResponseModel(
//         message: 'Failed to put data: $e',
//         status: false,
//         statusCode: null,
//         data: null,
//       );
//     }
//   }
//
//   Future<ResponseModel?> _handleResponse(http.Response response) async {
//     try {
//       if (response.statusCode != 200) {
//         print("Time Out Exception : ${response.statusCode}");
//         return ResponseModel(
//           message: 'Something went wrong with the API',
//           status: false,
//           statusCode: response.statusCode,
//           data: null,
//         );
//       }
//       final data = jsonDecode(response.body) as Map<String, dynamic>;
//       print("____________DATA_________________");
//       print(data);
//       final v = ResponseModel(
//         data: data,
//         statusCode: response.statusCode,
//         status: data['result'] == true,
//         message: data['message'] ?? '',
//       );
//       return v;
//     } catch (e) {
//       debugPrint('Error in _handleResponse: $e');
//       return ResponseModel(
//         message: 'Failed to parse response: $e',
//         status: false,
//         statusCode: response.statusCode,
//         data: null,
//       );
//     }
//   }
// }
// class ResponseModel {
//   String message;
//   int? statusCode;
//   bool status;
//   Map<String, dynamic>? data;
//
//   ResponseModel({
//     this.message = '',
//     this.statusCode,
//     this.status = false,
//     this.data,
//   });
//
//   factory ResponseModel.fromJson(Map<String, dynamic> json) {
//     return ResponseModel(
//       message: json['message'] ?? '',
//       statusCode: json['status_code'] ?? json['statusCode'],
//       status: json['status'] is bool
//           ? json['status']
//           : (json['status'] == 1 || json['status'] == true),
//       data: json['data'] != null
//           ? Map<String, dynamic>.from(json['data'])
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "message": message,
//       "status_code": statusCode,
//       "status": status,
//       "data": data,
//     };
//   }
// }
