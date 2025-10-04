import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../model/weeklySalesTrend_model.dart';

class WeeklySalesTrendApiService {
  final String baseUrl = 'https://reports-mb-dev-backend.cstechns.com/api/mobile/weekly-sales-trend';

  Future<WeeklySalesTrendResponse> fetchWeeklySalesTrend() async {
    final url = Uri.parse(baseUrl);
    final box = Hive.box('myBox');
    final token = box.get("token");

    if (token == null || token.isEmpty) {
      throw Exception("Authentication required. Please log in.");
    }
    // If your API requires headers (auth token, etc.), include them here
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    print("-------------weekly sales trend------------"+response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return WeeklySalesTrendResponse.fromJson(jsonMap);
    } else {
      // You can create a custom exception class if you like
      throw Exception(
          'Failed to fetch weekly sales trend: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
