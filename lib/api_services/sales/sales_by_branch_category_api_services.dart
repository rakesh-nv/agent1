import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mbindiamy/model/sales_by_branch_category_actual_model.dart';
import 'package:mbindiamy/model/sales_by_branch_category_promise_model.dart';

import '../../model/ceteforyWiseSales_model.dart';

class ApiService {
  static const String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/sales-by-branch-category";

  Future<categoryWiseSalesModal> categoryWiseSales() async {
    try {
      // Get the token from Hive
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? ''; // Use AppConstants.keyToken
      // final branch = box.get(AppConstants.branch);
      // print("f//////" + token);
      // if (token.isEmpty) {
      //   print("empty");
      //   throw Exception("Auth token not found. Please login first.");
      // }

      // Prepare request body for today's sales only
      final requestBody = jsonEncode({"preset": "today"});
      // debugPrint('Requesting category sales with body: $requestBody');

      // Make POST request
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Add "Bearer " prefix if required
        },
        body: requestBody,
      );
      debugPrint(
        '---------------categoryWiseSales ---------------: ${response.body}',
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return categoryWiseSalesModal.fromJson(jsonData);
      } else {
        throw Exception('API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching today\'s sales: $e');
      rethrow;
    }
  }
}
