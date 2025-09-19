import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // For debugPrint
import 'package:mbindiamy/api_services/branchManager/todayAndYesterday_sales.dart';
import 'package:mbindiamy/model/total_sales_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TotalSalesController extends GetxController {
  final SalesApiService _apiService;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var salesData = Rx<SalesData?>(null);
  var hasConnection = true.obs;
  var myIncentive = Rx<double?>(null);
  var totalPurchaseAmount = Rx<double?>(null);
  var customersServed = Rx<int?>(null);
  var netProfit = Rx<double?>(null);
  var incentiveError = Rx<String?>(null);

  TotalSalesController({
    SalesApiService? apiService,
    Connectivity? connectivity,
  }) : _apiService = apiService ?? SalesApiService(),
       _connectivity = connectivity ?? Connectivity() {
    _initConnectivity();
  }

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

      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> results,
      ) {
        if (results.isNotEmpty) {
          _updateConnectionStatus(results.first);
        }
      });
    } catch (e) {
      debugPrint('Could not check connectivity status: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final newStatus = result != ConnectivityResult.none;
    if (hasConnection.value != newStatus) {
      hasConnection.value = newStatus;
      // Automatically retry fetch when connection is restored
      if (hasConnection.value && errorMessage.value != null) {
        fetchTodaysSales();
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
      debugPrint('Fetching today\'s sales data...');

      final response = await _apiService.fetchTodaysSales().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out after 15 seconds');
        },
      );


      salesData.value = response.data;
      debugPrint('Successfully fetched today\'s sales data');

      // Update new metrics
      totalPurchaseAmount.value = response.data.totalPurchaseAmount;
      customersServed.value = response.data.customersServed;
      netProfit.value = response.data.netProfit;
      // Calculate incentive after successful fetch
      _calculateMyIncentive();
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

  Future<void> _calculateMyIncentive() async {
    if (salesData.value == null) {
      incentiveError.value = 'No sales data available';
      myIncentive.value = null;
      return;
    }

    try {
      final myRole = await _getCurrentUserRole(); // Implement this method
      final staffCount = await _getStaffCount(); // Implement this method

      if (myRole == null || staffCount == null) {
        throw Exception('Could not determine user role or staff count');
      }

      print("totalNetAmount" + salesData.value!.totalNetAmount.toString());
      print("stafcount" + staffCount.toString());
      print("myRole" + myRole.toString());
      myIncentive.value = _calculateIncentive(
        netSales: salesData.value!.totalNetAmount,
        staffCount: staffCount,
        myRole: myRole,
      );
      print(myIncentive.value);
      // incentiveError.value = null;
    } catch (e) {
      incentiveError.value = e.toString();
      myIncentive.value = null;
      debugPrint('Error calculating incentive: $e');
    }
  }

  Future<String?> _getCurrentUserRole() async {
    final box = Hive.box('myBox');
    return box.get('userType'); // Assuming 'user_role' is stored in Hive
  }

  // Future<Map<String, int>?> _getStaffCount() async {
  //   // This will likely involve another API call or a more complex logic.
  //   // For now, returning a placeholder.
  //   return {'Manager': 1, 'Cashier': 2, 'SalesPerson': 3};
  // }
  Future<Map<String, int>?> _getStaffCount() async {
    // This will likely involve another API call or a more complex logic.
    // For now, returning a placeholder.
    return {'Manager': 1, 'Cashier': 2, 'SalesPerson': 3};
  }

  double _calculateIncentive({
    required double netSales,
    required Map<String, int> staffCount,
    required String myRole,
    double? target,
  }) {
    final Map<String, double> partsPerPerson = {
      'Manager': 1.25,
      'Cashier': 1.00,
      'Top Sales P (Amount)': 1.25,
      'Sales Person': 1.00,
      'Stock Executive': 0.75,
      'RHS': 0.75,
      'HOS': 0.25,
    };

    if (netSales <= 0) return 0.0;
    if (target != null && netSales < 0.95 * target) {
      return 0.0;
    }

    final double totalIncentivePool = netSales * 0.01;

    double totalParts = 0;
    staffCount.forEach((role, count) {
      String normalizedRole = _normalizeRole(role);
      if (partsPerPerson.containsKey(normalizedRole)) {
        totalParts += partsPerPerson[normalizedRole]! * count;
      }
    });

    if (totalParts == 0) {
      throw Exception('No valid staff roles for incentive calculation');
    }

    final double partValue = totalIncentivePool / totalParts;

    final double myParts = partsPerPerson[_normalizeRole(myRole)] ?? 1.00;

    return myParts * partValue;
  }

  String _normalizeRole(String role) {
    switch (role) {
      case 'VK Merchandiser':
        return 'Sales Person';
      case 'RHS & Manager':
        return 'Manager';
      default:
        return role;
    }
  }
}
