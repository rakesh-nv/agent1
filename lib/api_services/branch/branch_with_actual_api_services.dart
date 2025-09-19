import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mbindiamy/model/branch_wise_sales_model/actual_only_branch_model.dart';

class SalesByBranchCategoryApi {
  final String baseUrl = "https://reports-mb-dev-backend.cstechns.com/api/mobile/sales-by-branch-category";

  Future<SalesByBranchCategoryResponse> fetchSalesByBranchCategory({
  required String startDate,
  required String endDate,
  required String branch,
  required String token,
}) async {
  try {
    // No formatter needed here if the input strings are correct.

    final body = {
      "preset": "custom",
      "from": startDate, // Use the string directly
      "to": endDate,     // Use the string directly
      "branch": "",
    };
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return SalesByBranchCategoryResponse.fromJson(jsonData);
      } else {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return SalesByBranchCategoryResponse(
          success: false,
          statusCode: response.statusCode,
          message: jsonData['message'] ?? 'Failed to fetch sales data: ${response.statusCode}',
          data: SalesByBranchCategoryData(
            totalSales: 0.0,
            totalNetSlsQty: 0,
            branchSales: [],
            categorySales: [],
          ),
        );
      }
    } catch (e) {
      throw Exception("Failed to fetch Sales By Branch Category Data: $e");
    }
  }
}