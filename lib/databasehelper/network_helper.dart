import 'package:discese_dictionary/api/internet_service.dart';
import 'package:flutter/material.dart';

class NetworkHelper {
  static Future<bool> checkConnection(BuildContext context) async {
    final result = await InternetService.hasInternet();
    return result;
  }
}
