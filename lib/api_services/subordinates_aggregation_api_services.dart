import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/subordinates_aggregation_model.dart';
import '../utils/app_constants.dart';

class SubordinatesAggregationApiService {
  final String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/subordinates-aggregation";

  Future<SubordinatesAggregationResponse?> fetchSubordinatesAggregation({
    String preset = "thismonth", // Default to "thismonth"
  }) async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';

      if (token.isEmpty) {
        throw AuthException(
          "Authentication token not found. Please login first.",
        );
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: jsonEncode({"preset": preset}),
      );

      print("------------sub--------" + response.body);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return SubordinatesAggregationResponse.fromJson(data);
        } catch (e) {
          throw FormatException("Failed to parse response: $e");
        }
      } else {
        throw ApiException(
          "Failed to fetch data: ${response.statusCode}, ${response.body}",
        );
      }
    } catch (e) {
      print("Exception in fetchSubordinatesAggregation: $e");
      if (e is AuthException || e is NetworkException || e is ApiException) {
        rethrow; // Allow specific exceptions to propagate
      }
      return null; // Fallback for unhandled exceptions
    }
  }

  Future<SubordinatesAggregationResponse?> fetchSubordinatesTodaysAggregation({
    String preset = "today", // Default to "thismonth"
  }) async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';

      if (token.isEmpty) {
        throw AuthException(
          "Authentication token not found. Please login first.",
        );
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Authorization": token, "Content-Type": "application/json"},
        body: jsonEncode({"preset": preset}),
      );

      print("------------sub--------" + response.body);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          return SubordinatesAggregationResponse.fromJson(data);
        } catch (e) {
          throw FormatException("Failed to parse response: $e");
        }
      } else {
        throw ApiException(
          "Failed to fetch data: ${response.statusCode}, ${response.body}",
        );
      }
    } catch (e) {
      print("Exception in fetchSubordinatesAggregation: $e");
      if (e is AuthException || e is NetworkException || e is ApiException) {
        rethrow; // Allow specific exceptions to propagate
      }
      return null; // Fallback for unhandled exceptions
    }
  }
}

// Custom exceptions for better error handling
class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);
}
