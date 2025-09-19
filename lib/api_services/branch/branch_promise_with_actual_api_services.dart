import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mbindiamy/model/branch_wise_sales_model/atual_vs_promise_branch_model.dart';
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PromiseWithActualApi {
  final String baseUrl = "https://reports-mb-dev-backend.cstechns.com/api/mobile/promise/with-actual";

  Future<PromiseActualResponse> fetchPromiseWithActual({
    required String branch,
    required int year,
    required int month,
  }) async {
    try {
      // print("demo");
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken) ?? '';
      // print("pa");
      // print(branch);
      // print(token);
      if (token.isEmpty) {
        throw Exception("Auth token not found. Please login first.");
      }
      // ✅ Format month to always have 2 digits
      final formattedMonth = month.toString().padLeft(2, '0');

      final body = {
        "year": year.toString(),
        // "month": "05",
        "month": formattedMonth,
        "branch": branch,
      };
      print('➡ Request Body: $body');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: jsonEncode(body),
      );

      print('➡ Request Body: $body');
      print('--------Promise with actual----------:: ${response.body}');

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return PromiseActualResponse.fromJson(jsonData);
      } else {
        return PromiseActualResponse(
          success: false,
          statusCode: response.statusCode,
          message:
              jsonData['message'] ??
              'Failed to fetch promise data: ${response.statusCode}',
          data: Data(
            year: year,
            month: '',
            locations: [],
            createdAt: '',
            updatedAt: '',
          ),
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      throw Exception("Failed to fetch Promise With Actual Data: $e");
    }
  }

  /// 🔄 Helper: Convert API response to UI-friendly list
  List<Map<String, dynamic>> mapToUiList(PromiseActualResponse response) {
    final List<Map<String, dynamic>> result = [];

    if (response.data.locations.isEmpty) return result;

    final dailyValues = response.data.locations.first.dailyValues;

    for (var item in dailyValues) {
      final DateTime date = DateTime.parse(item.date);
      final String formattedDate = DateFormat(
        'MMM yyyy',
      ).format(date); // e.g. "Jul 2024"
      // final String day = DateFormat('E').format(date); // e.g. "Mon"

      final int promise = item.promise;
      final int actual = item.actual;
      final int percent = promise > 0 ? ((actual / promise) * 100).round() : 0;

      result.add({
        'date': formattedDate,
        // 'day': day,
        'promise': NumberFormat.compact().format(promise), // e.g. "530K"
        'actual': NumberFormat.compact().format(actual), // e.g. "23.6K"
        'percent': percent,
      });
    }

    return result;
  }
}
