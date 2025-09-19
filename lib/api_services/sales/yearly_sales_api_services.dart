import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/model/yearly_sales_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SalesComparisonApiService {
  final String baseUrl;

  SalesComparisonApiService({required this.baseUrl});

  Future<SalesComparisonResponse> fetchSalesComparison() async {
    final url = Uri.parse(baseUrl);

    //  get token from Hive
    final box = Hive.box('myBox');
    final token = box.get("token"); // make sure you saved it earlier

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // pass token here
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return SalesComparisonResponse.fromJson(jsonData);
    } else {
      throw Exception(
        "Failed to fetch sales comparison data: ${response.body}",
      );
    }
  }
}
