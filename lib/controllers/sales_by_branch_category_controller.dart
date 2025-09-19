// import 'package:get/get.dart';
// import 'package:flutter/material.dart'; // For debugPrint
// import 'package:mbindiamy/api_services/sales/sales_by_branch_category_api_services.dart';
// import 'package:mbindiamy/model/sales_by_branch_category_actual_model.dart';
// import 'package:mbindiamy/model/sales_by_branch_category_promise_model.dart';
//
// enum LoadingState {
//   idle,
//   loadingFilters,
//   loadingSales,
//   loadingPromises,
//   loaded,
//   error,
// }
//
// class SalesByBranchCategoryController extends GetxController {
//   final ApiService _apiService = ApiService();
//   final RxMap _promiseDataMap = {}.obs; // Use Rx for map values
//
//   var salesData = Rx<SalesByBranchCategoryModel?>(null);
//   var selectedBranches = <String>[].obs;
//   var selectedStartDate = Rx<DateTime?>(null);
//   var selectedEndDate = Rx<DateTime?>(null);
//   var loadingState = LoadingState.idle.obs;
//   var error = Rx<String?>(null);
//
//   RxMap get promiseDataMap => _promiseDataMap;
//
//   double get totalPromisedSales {
//     return _promiseDataMap.values.fold(
//       0.0,
//       (sum, promiseRx) =>
//           sum +
//           (promiseRx.value?.data.isNotEmpty == true
//               ? promiseRx.value!.data.first.promisedPurchase
//               : 0.0),
//     );
//   }
//
//   double getPromiseAmountForCategory(String category) {
//     final promiseRx = _promiseDataMap[category];
//     if (promiseRx == null ||
//         promiseRx.value == null ||
//         promiseRx.value!.data.isEmpty) {
//       return 0.0;
//     }
//     return promiseRx.value!.data.first.promisedPurchase;
//   }
//
//   Future<void> loadSalesData(
//     List<String> branches, {
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     try {
//       loadingState.value = LoadingState.loadingSales;
//       error(null);
//
//       final data = await _apiService.fetchSalesByBranchCategory(
//         branches: branches,
//         startDate: startDate,
//         endDate: endDate,
//       );
//
//       salesData.value = data;
//       selectedBranches.value = branches;
//       selectedStartDate.value = startDate;
//       selectedEndDate.value = endDate;
//       loadingState.value = LoadingState.loaded;
//     } catch (e) {
//       error.value = e.toString();
//       loadingState.value = LoadingState.error;
//       debugPrint("Error loading sales data: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> loadPromiseData(
//     String category, {
//     DateTime? startDate,
//     DateTime? endDate,
//   }) async {
//     try {
//       loadingState.value = LoadingState.loadingPromises;
//
//       final promiseData = await _apiService.fetchPurchasePromise(
//         category: category,
//         startDate: startDate,
//         endDate: endDate,
//       );
//
//       _promiseDataMap[category] = promiseData.obs; // Wrap in Rx
//       loadingState.value = LoadingState.loaded;
//     } catch (e) {
//       error.value =
//           'Failed to load promise data for $category: ${e.toString()}';
//       loadingState.value = LoadingState.error;
//       debugPrint("Error loading promise data: $e");
//     }
//   }
//
//   void clearData() {
//     salesData.value = null;
//     _promiseDataMap.clear();
//     selectedBranches.clear();
//     selectedStartDate.value = null;
//     selectedEndDate.value = null;
//     loadingState.value = LoadingState.idle;
//     error(null);
//   }
// }
