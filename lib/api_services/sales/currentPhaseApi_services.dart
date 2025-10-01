import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/model/salesagentModel/sales_comparison_by_phase_modal.dart';
import '../../model/sales_by_phase_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mbindiamy/utils/app_constants.dart';

class CurrentPhaseApiServices {
  final String apiUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/sales-comparison-by-phase";

  Future<SalesComparisonByPhaseResponse> fetchCurrentPhaseData() async {
    try {
      final box = Hive.box('myBox');
      final token =
          box.get(AppConstants.keyToken) ?? ''; // Use AppConstants.keyToken

      if (token.isEmpty) {
        throw Exception("Authentication token not found");
      }
      // debugPrint("Request URL: $apiUrl");

      // Option 1: If the API expects GET with query parameters
      final uriWithParams = Uri.parse(
        apiUrl,
      ).replace(queryParameters: {"preset": "current"});

      final response = await http.get(
        uriWithParams,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Added Bearer prefix
        },
      );
      debugPrint("--------load current phase----------:: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Validate response structure
        if (jsonData['data'] == null) {
          throw Exception("No data received from API");
        }

        return SalesComparisonByPhaseResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please login again.");
      } else {
        throw Exception("API Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error in fetchSalesByPhase: $e");
      rethrow;
    }
  }
}
