import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../api_services/sales/sales_by_branch_category_api_services.dart' as category_api;
import '../../model/ceteforyWiseSales_model.dart';

class CategoryWiseSalesController extends GetxController {
  late final category_api.ApiService _apiService;
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var salesData = Rx<categoryWiseSalesModal?>(null);
  var hasConnection = true.obs;
  var incentiveError = Rx<String?>(null);

  CategoryWiseSalesController({category_api.ApiService? apiService})
    : _apiService = apiService ?? category_api.ApiService();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCategoryWiseSales() async {
    if (!hasConnection.value) {
      errorMessage.value = 'No internet connection available';
      return;
    }

    isLoading(true);
    errorMessage(null);

    try {
      // debugPrint('Fetching category\'s sales data...');

      final response = await _apiService.categoryWiseSales();
      // .timeout(
      //   const Duration(seconds: 15),
      //   onTimeout: () {
      //     throw TimeoutException('Request timed out after 15 seconds');
      //   },
      // );

      // final response = await _apiService.categoryWiseSales();
      salesData.value = response;
      // debugPrint('Successfully categoryWise sales data' + salesData.value.toString());
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching category sales: $e');

      if (e.toString().contains('401')) {
        errorMessage.value = 'Session expired. Please login again.';
      }
    } finally {
      isLoading(false);
    }
  }
}
