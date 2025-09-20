import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/model/subordinates_sales_vs_promise_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';

class SubordinatesSalesVsPromiseApiServices extends GetConnect {
  final String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/subordinates-sales-vs-promise";

  Future<SubordinatesSalesVsPromiseModel?> getSubordinatesSalesVsPromise() async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';

      debugPrint("////// Token: $token");

      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }

      // Prepare request body for today's sales only
      final requestBody = jsonEncode({
        "preset": "thisweek", // "today" instead of "custom"
      });

      // Make POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add "Bearer " prefix if backend expects it
        },
        body: requestBody,
      );

      debugPrint(
        '---------------getSubordinatesSalesVsPromise--------------:  ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SubordinatesSalesVsPromiseModel.fromJson(jsonData);
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching today\'s sales: $e');
      rethrow;
    }
  }
}
