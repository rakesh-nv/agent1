import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../model/ArticlesWithMrpAndStock_model.dart';
import '../utils/app_constants.dart';

class ArticleWithMrpStockApiService {
  static const String baseUrl =
      "https://reports-mb-dev-backend.cstechns.com/api/mobile/filtered-article-details";

  Future<ArticleWithMrpAndStockResponse?> fetchArticles() async {
    try {
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';

      if (token == null || token.isEmpty) {
        throw Exception("Authentication required. Please log in.");
      }

      print("ArticleWithMrpStockApiService" + token);
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token, // Added Bearer prefix
        },
      );
      print("---------ArticleWithMrpStockApiService---------" + response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ArticleWithMrpAndStockResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load articles: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching articles: $e");
    }
  }
}
