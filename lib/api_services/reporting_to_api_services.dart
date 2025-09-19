import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mbindiamy/model/reporting_model.dart';

class ReportingManagerApiService {
  final String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/reporting-manager";

  Future<ReportingManagerResponse> fetchReportingManager() async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';

      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Pass token in header
        },
      );
      print("----------Reporting manager-------- :"+response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ReportingManagerResponse.fromJson(jsonData);
      } else {
        throw Exception(
          "Failed to fetch reporting manager: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
