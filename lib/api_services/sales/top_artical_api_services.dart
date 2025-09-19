// top_articles_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mbindiamy/model/top_artical_model.dart';

class TopArticlesApiService {
  static const String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/top-articles";

  Future<TopArticlesResponse> fetchTopArticles() async {
    try {
      final box = Hive.box('myBox');
      final token = box.get("token");

      if (token == null || token.isEmpty) {
        throw Exception("Authentication required. Please log in.");
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Added Bearer prefix
        },
      );
      // print("TopArticles res"+ response.body.toString());
      final responseBody = json.decode(response.body);
      print("---------------fetchTopArticles-------------------:${responseBody}");
      if (response.statusCode == 200) {
        return TopArticlesResponse.fromJson(responseBody);
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please log in again.");
      } else {
        throw Exception(
          responseBody['message'] ??
              "Failed to load data (Status: ${response.statusCode})",
        );
      }
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to fetch articles: ${e.toString()}");
    }
  }
}
