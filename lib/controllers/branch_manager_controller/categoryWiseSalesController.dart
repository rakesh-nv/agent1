import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../api_services/sales/sales_by_branch_category_api_services.dart'
as category_api;
import '../../model/ceteforyWiseSales_model.dart';

class CategoryWiseSalesController extends GetxController {
  late final category_api.ApiService _apiService;
  final Connectivity _connectivity;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var salesData = Rx<categoryWiseSalesModal?>(null);
  var hasConnection = true.obs;
  var incentiveError = Rx<String?>(null);

  CategoryWiseSalesController({
    category_api.ApiService? apiService,
    Connectivity? connectivity,
  })  : _apiService = apiService ?? category_api.ApiService(),
        _connectivity = connectivity ?? Connectivity();

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }


  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.isNotEmpty) {
        _updateConnectionStatus(result.first);
      }

      _connectivitySubscription =
      _connectivity.onConnectivityChanged.listen((
          List<ConnectivityResult> results,
          ) {
        if (results.isNotEmpty) {
          _updateConnectionStatus(results.first);
        }
      })
      as StreamSubscription<ConnectivityResult>?;
    } catch (e) {
      debugPrint('Could not check connectivity status: $e');
    }
  }
  void _updateConnectionStatus(ConnectivityResult result) {
    final newStatus = result != ConnectivityResult.none;
    if (hasConnection.value != newStatus) {
      hasConnection.value = newStatus;

      // Auto retry fetching data if internet comes back
      if (hasConnection.value && errorMessage.value != null) {
        fetchCategoryWiseSales();
      }
    }
  }

  Future<void> fetchCategoryWiseSales() async {
    if (!hasConnection.value) {
      errorMessage.value = 'No internet connection available';
      return;
    }

    isLoading(true);
    errorMessage(null);

    try {
      final response = await _apiService.categoryWiseSales().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out after 15 seconds');
        },
      );

      salesData.value = response;
      debugPrint('Successfully fetched category-wise sales data');
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
