
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/triviamodel.dart';

class ApiService {
  final baseUrl =
      'https://diseasedictionary.skyraanapps.com/server/api/';

  Future<List<Triviamodel>> fetchTrivias() async {
    final response = await http.post(
      Uri.parse('${baseUrl}home'),
      body: jsonEncode({
        'last_cat_id': 0,
        'last_disease_id': 0,
        'last_trivia_id': 0,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final triviaList =
      data['resultData']['trivias'];

      return triviaList
          .map<Triviamodel>(
              (e) => Triviamodel.fromJson(e))
          .toList();
    } else {
      throw Exception('failed');
    }
  }
}