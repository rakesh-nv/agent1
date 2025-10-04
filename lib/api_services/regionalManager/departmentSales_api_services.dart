import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/model/regionalHead/DepartmentSale_model.dart';

import '../../model/weeklySalesTrend_model.dart';

class departmentSalesApiService {
  final String baseUrl =
      'https://reports-mb-dev-backend.cstechns.com/api/mobile/department-sales';

  Future<DepartmentSalesResponse> fetchDepartmentSales() async {
    final box = Hive.box('myBox');
    final token = box.get("token");

    if (token == null || token.isEmpty) {
      throw Exception("Authentication required. Please log in.");
    }
    final requestBody = jsonEncode({
      "preset": "today", // "today" instead of "custom"
    });
    // If your API requires headers (auth token, etc.), include them here
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body : requestBody,
    );

    print("-------------departmentSalesApiService------------" + response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return DepartmentSalesResponse.fromJson(jsonMap);
    } else {
      // You can create a custom exception class if you like
      throw Exception(
        'Failed to fetch weekly sales trend: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }
}
