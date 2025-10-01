import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mbindiamy/model/total_sales_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/utils/app_constants.dart';

class SalesApiService {
  final String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/sales-by-date";

  Future<SalesDataResponse> fetchTodaysSales() async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token =
          box.get(AppConstants.keyToken) ?? ''; // Use AppConstants.keyToken
      print("//////" + token);
      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }
      // Prepare request body for today's sales only
      final requestBody = jsonEncode({
        "preset": "today", // Changed from "custom" to "today"
        // Removed "from" and "to" paraRemeters since we're using preset
      });
      debugPrint('Requesting today\'s sales with body: $requestBody');

      // Make POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add "Bearer " prefix if required
        },
        body: requestBody,
      );
      debugPrint('--------Today Sales----------: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SalesDataResponse.fromJson(jsonData);
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching today\'s sales: $e');
      rethrow;
    }
  }

  Future<SalesDataResponse> fetchyesterdaysSales() async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token =
          box.get(AppConstants.keyToken) ?? ''; // Use AppConstants.keyToken
      print("//////" + token);
      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }
      // Prepare request body for today's sales only
      final requestBody = jsonEncode({
        "preset": "Yesterday", // Changed from "custom" to "today"
        // Removed "from" and "to" parameters since we're using preset
      });
      debugPrint('Requesting today\'s sales with body: $requestBody');

      // Make POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add "Bearer " prefix if required
        },
        body: requestBody,
      );
      debugPrint('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SalesDataResponse.fromJson(jsonData);
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching today\'s sales: $e');
      rethrow;
    }
  }

  Future<SalesDataResponse> fetchThisMonthSales() async {
    try {
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';
      print("//////" + token);
      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }
      final requestBody = jsonEncode({"preset": "thisMonth"});
      debugPrint('Requesting this month\'s sales with body: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: requestBody,
      );
      debugPrint('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SalesDataResponse.fromJson(jsonData);
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching this month\'s sales: $e');
      rethrow;
    }
  }

  Future<SalesDataResponse> fetchThisYearsSales() async {
    try {
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';
      print("//////" + token);
      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }
      final now = DateTime.now();
      final currentYear = now.year;
      final formattedToday = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final requestBody = jsonEncode({
        "from": "$currentYear-04-01",
        "to": formattedToday
      });
      debugPrint('Requesting this year\'s sales with body: $requestBody');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: requestBody,
      );
      debugPrint('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SalesDataResponse.fromJson(jsonData);
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching this year\'s sales: $e');
      rethrow;
    }
  }}
