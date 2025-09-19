import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/filter_model.dart';

class FilterApi {
  final String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/filter/get-filters";

  Future<FilterResponse?> fetchFilters() async {
    try {
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken);

      if (token == null) {
        throw Exception("No token found. Please login first.");
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json", "Authorization": token},
      );
      // print("fififififif  ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FilterResponse.fromJson(data);
      } else {
        throw Exception("Failed to load filters: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchFilters: $e");
      return null;
    }
  }
}
