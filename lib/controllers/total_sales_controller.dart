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
  var salesData = Rx<SalesData?>(null); // Daily sales data
  var thisMonthSalesData = Rx<SalesData?>(null); // Monthly sales data
  var hasConnection = true.obs;
  var myIncentive = Rx<double?>(null); // Daily incentive
  var myIncentiveThisMonth = Rx<double?>(null); // Monthly incentive
  var totalPurchaseAmountDaily = Rx<double?>(null); // Daily purchase amount
  var totalPurchaseAmountMonthly = Rx<double?>(null); // Monthly purchase amount
  var customersServedDaily = Rx<int?>(null); // Daily customers served
  var customersServedMonthly = Rx<int?>(null); // Monthly customers served
  var netProfitDaily = Rx<double?>(null); // Daily net profit
  var netProfitMonthly = Rx<double?>(null); // Monthly net profit
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
        // fetchTodaysSales();
        // fetchThisMonthSales();
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

      // Update daily metrics
      totalPurchaseAmountDaily.value = response.data.totalPurchaseAmount;
      customersServedDaily.value = response.data.customersServed;
      netProfitDaily.value = response.data.netProfit;

      // Calculate daily incentive
      await _calculateMyIncentive();
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
      thisMonthSalesData.value = response.data;

      print("rest");
      print(thisMonthSalesData.value);
      // Update monthly metrics
      totalPurchaseAmountMonthly.value = response.data.totalPurchaseAmount;
      customersServedMonthly.value = response.data.customersServed;
      netProfitMonthly.value = response.data.netProfit;

      // Calculate monthly incentive
      await _calculateMyIncentiveThisMonth();
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

  Future<void> _calculateMyIncentive() async {
    if (salesData.value == null) {
      incentiveError.value = 'No daily sales data available';
      myIncentive.value = null;
      return;
    }

    try {
      final myRole = await _getCurrentUserRole();
      final staffCount = await _getStaffCount();

      if (myRole == null || staffCount == null) {
        throw Exception('Could not determine user role or staff count');
      }

      debugPrint("Daily totalNetAmount: ${salesData.value!.totalNetAmount}");
      debugPrint("Staff count: $staffCount");
      debugPrint("My role: $myRole");

      myIncentive.value = _calculateIncentive(
        netSales: salesData.value!.totalNetSlsValue,
        staffCount: staffCount,
        myRole: myRole,
      );

      debugPrint("Daily incentive: ${myIncentive.value}");
      incentiveError.value = null;
    } catch (e) {
      incentiveError.value = e.toString();
      myIncentive.value = null;
      debugPrint('Error calculating daily incentive: $e');
    }
  }

  Future<void> _calculateMyIncentiveThisMonth() async {
    if (thisMonthSalesData.value == null) {
      incentiveError.value = 'No monthly sales data available';
      myIncentiveThisMonth.value = null;
      return;
    }

    try {
      final myRole = await _getCurrentUserRole();
      final staffCount = await _getStaffCount();

      if (myRole == null || staffCount == null) {
        throw Exception('Could not determine user role or staff count');
      }

      debugPrint("Monthly totalNetAmount: ${thisMonthSalesData.value!.totalNetAmount}");
      debugPrint("Staff count: $staffCount");
      debugPrint("My role: $myRole");

      myIncentiveThisMonth.value = _calculateIncentive(
        netSales: thisMonthSalesData.value!.totalNetAmount,
        staffCount: staffCount,
        myRole: myRole,
        target: 5000.0, // Example monthly target
      );

      debugPrint("Monthly incentive: ${myIncentiveThisMonth.value}");
      incentiveError.value = null;
    } catch (e) {
      incentiveError.value = e.toString();
      myIncentiveThisMonth.value = null;
      debugPrint('Error calculating monthly incentive: $e');
    }
  }

  Future<String?> _getCurrentUserRole() async {
    final box = Hive.box('myBox');
    return box.get('userType'); // Assuming 'userType' is stored in Hive
  }

  Future<Map<String, int>?> _getStaffCount() async {
    // Placeholder for staff count; replace with actual API call if needed
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

    // return myParts * partValue;
    return netSales * 0.01;
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