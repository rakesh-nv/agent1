import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../api_services/branch/branch_total_api_services.dart';
import '../../model/branch_wise_sales_model/branch_total_model.dart';

class SalesComparisonController extends GetxController {
  late final SalesApiService _apiService;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var salesData = Rx<SalesData?>(null);
  var todaySalesData = Rx<double?>(null);
  var yesterdaySalesData = Rx<double?>(null);
  var thisMonthSalesData = Rx<double?>(null);
  var hasConnection = true.obs;
  var myIncentive = Rx<double?>(null);
  var incentiveError = Rx<String?>(null);

  SalesComparisonController({SalesApiService? apiService, Connectivity? connectivity})
    : _apiService = apiService ?? SalesApiService(),
      _connectivity = connectivity ?? Connectivity() {
    _initConnectivity();
  }

  final Connectivity _connectivity;

  @override
  void onInit() {
    super.onInit();
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
          _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
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

      if (hasConnection.value && errorMessage.value != null) {
        // fetchTodaysSales(); // Re-fetch data if connection is restored
        // fetchYesterdaySales();
      }
    }
  }

  Future<void> fetchTodaysSales() async {
    if (!hasConnection.value) {
      errorMessage.value = 'No internet connection available';
      return;
    }

    isLoading(true);
    errorMessage(null);

    try {
      // debugPrint('Fetching today\'s sales data...');

      final response = await _apiService.fetchTodaysSales();

      todaySalesData.value = response.data.totalNetAmount;
      // debugPrint('Successfully fetched today\'s sales data');
      // Calculate incentive after successful fetch
      // _calculateMyIncentive();
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching today\'s sales: $e');

      if (e.toString().contains('401')) {
        errorMessage.value = 'Session expired. Please login again.';
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchYesterdaySales() async {
    if (!hasConnection.value) {
      errorMessage.value = 'No internet connection available';
      return;
    }

    isLoading(true);
    errorMessage(null);

    try {
      debugPrint('Fetching yesterday\'s sales data...');

      final response = await _apiService.fetchyesterdaysSales().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out after 15 seconds');
        },
      );

      yesterdaySalesData.value = response.data.totalNetAmount;
      debugPrint('Successfully fetched yesterday\'s sales data');
      // Calculate incentive after successful fetch
      // _calculateMyIncentive();
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching yesterday\'s sales: $e');

      if (e.toString().contains('401')) {
        errorMessage.value = 'Session expired. Please login again.';
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchThisMonthSales() async {
    if (!hasConnection.value) {
      errorMessage.value = 'No internet connection available';
      return;
    }

    isLoading(true);
    errorMessage(null);

    try {
      debugPrint('Fetching this month\'s sales data...');

      final response = await _apiService.fetchThisMonthSales().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out after 15 seconds');
        },
      );

      thisMonthSalesData.value = response.data.totalNetAmount;
      debugPrint('Successfully fetched this month\'s sales data');
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching this month\'s sales: $e');

      if (e.toString().contains('401')) {
        errorMessage.value = 'Session expired. Please login again.';
      }
    } finally {
      isLoading(false);
    }
  }
}
