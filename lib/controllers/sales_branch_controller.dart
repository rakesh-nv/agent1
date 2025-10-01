import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:mbindiamy/api_services/branch/branch_promise_with_actual_api_services.dart';
import 'package:mbindiamy/api_services/branch/branch_with_actual_api_services.dart';
import 'package:mbindiamy/model/branch_wise_sales_model/actual_only_branch_model.dart';
import 'package:mbindiamy/model/branch_wise_sales_model/atual_vs_promise_branch_model.dart';

import '../utils/app_constants.dart';

class SalesbranchController extends GetxController {
  final _logger = Logger();
  final _salesApi = SalesByBranchCategoryApi();
  final _promiseApi = PromiseWithActualApi();

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var salesResponse = Rx<SalesByBranchCategoryResponse?>(null);
  var promiseResponse = Rx<PromiseActualResponse?>(null);
  var lastApiCalled = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initial data fetch can be triggered here if needed, e.g.,
    // fetchData(startDate: DateTime.now(), endDate: DateTime.now(), branch: 'all');
  }

  Future<void> fetchData({
    required DateTime startDate,
    required DateTime endDate,
    required String branch,
  }) async {
    try {
      isLoading(true);
      errorMessage(null);
      salesResponse(null);
      promiseResponse(null);

      final now = DateTime.now();
      final branchList = branch == 'all' ? ['all'] : branch.split(',');
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      if (startDate.month == now.month &&
          startDate.year == now.year &&
          endDate.month == now.month &&
          endDate.year == now.year) {
        _logger.i("Calling /promise/with-actual API with branch: $branch");

        if (branchList.length > 1 && branch != 'all') {
          final List<Location> allLocations = [];
          for (final singleBranch in branchList) {
            final response = await _promiseApi.fetchPromiseWithActual(
              year: now.year,
              month: now.month,
              branch: singleBranch.trim(),
              // token: token,
            );
            _logger.d(
              "Promise API Response for branch $singleBranch: ${response.toJson()}",
            );
            if (!response.success) {
              errorMessage.value = response.message;
              return;
            }
            allLocations.addAll(response.data.locations);
          }
          promiseResponse.value = PromiseActualResponse(
            success: true,
            statusCode: 200,
            message: '',
            data: Data(
              year: now.year,
              month: _getMonthName(now.month),
              locations: allLocations,
              createdAt: DateTime.now().toIso8601String(),
              updatedAt: DateTime.now().toIso8601String(),
            ),
            timestamp: DateTime.now().toIso8601String(),
          );
        } else {
          promiseResponse.value = await _promiseApi.fetchPromiseWithActual(
            year: now.year,
            month: now.month,
            branch: branch,
            // token: token,
          );

          _logger.d("Promise API Response: ${promiseResponse.value?.toJson()}");

          if (!promiseResponse.value!.success) {
            errorMessage.value = promiseResponse.value!.message;
          } else {
            promiseResponse.value = _applyFilterAggregationPromise(
              promiseResponse.value!,
              startDate,
              endDate,
            );
          }
        }
        lastApiCalled.value = "promise";
      } else {
        _logger.i("Calling /sales-by-branch-category API with branch: $branch");
        if (branchList.length > 1 && branch != 'all') {
          final List<BranchSales> allBranchSales = [];
          double totalSales = 0.0;
          int totalNetSlsQty = 0;
          for (final singleBranch in branchList) {
            final response = await _salesApi.fetchSalesByBranchCategory(
              startDate: startDate.toIso8601String(),
              endDate: endDate.toIso8601String(),
              branch: singleBranch.trim(),
              token: token,
            );
            _logger.d(
              "Sales API Response for branch $singleBranch: ${response.toJson()}",
            );
            if (!response.success) {
              errorMessage.value = response.message;
              return;
            }
            allBranchSales.addAll(response.data.branchSales);
            totalSales += response.data.totalSales;
            totalNetSlsQty += response.data.totalNetSlsQty;
          }
          salesResponse.value = SalesByBranchCategoryResponse(
            success: true,
            statusCode: 200,
            message: '',
            data: SalesByBranchCategoryData(
              totalSales: totalSales,
              totalNetSlsQty: totalNetSlsQty,
              branchSales: allBranchSales,
              categorySales: [],
            ),
          );
        } else {
          salesResponse.value = await _salesApi.fetchSalesByBranchCategory(
            startDate: startDate.toIso8601String(),
            endDate: endDate.toIso8601String(),
            branch: branch,
            token: token,
          );
          _logger.d("Sales API Response: ${salesResponse.value?.toJson()}");
          if (!salesResponse.value!.success) {
            errorMessage.value = salesResponse.value!.message;
          } else {
            salesResponse.value = _applyFilterAggregationSales(
              salesResponse.value!,
              startDate,
              endDate,
            );
          }
        }
        lastApiCalled.value = "sales";
      }
    } catch (e, st) {
      _logger.e("Error fetching data", error: e, stackTrace: st);
      errorMessage.value = 'Error fetching data: $e';
    } finally {
      isLoading(false);
    }
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  PromiseActualResponse _applyFilterAggregationPromise(
    PromiseActualResponse response,
    DateTime startDate,
    DateTime endDate,
  ) {
    final filteredLocations = response.data.locations.where((loc) {
      // Assuming Location has a date field that can be compared
      // This part needs adjustment based on the actual structure of `Location`.
      // For now, returning true to include all locations.
      return true;
    }).toList();

    return PromiseActualResponse(
      success: true,
      statusCode: 200,
      message: '',
      data: Data(
        year: response.data.year,
        month: response.data.month,
        locations: filteredLocations,
        createdAt: response.data.createdAt,
        updatedAt: response.data.updatedAt,
      ),
      timestamp: response.timestamp,
    );
  }

  SalesByBranchCategoryResponse _applyFilterAggregationSales(
    SalesByBranchCategoryResponse response,
    DateTime startDate,
    DateTime endDate,
  ) {
    final filteredBranchSales = response.data.branchSales.where((sale) {
      // Assuming BranchSales has a date field that can be compared
      // This part needs adjustment based on the actual structure of `BranchSales`.
      // For now, returning true to include all branch sales.
      return true;
    }).toList();

    final totalSales = filteredBranchSales.fold(
      0.0,
      (sum, item) => sum + item.totalAmount,
    );
    final totalNetSlsQty = filteredBranchSales.fold(
      0,
      (sum, item) => sum + item.totalNetSlsQty,
    );

    return SalesByBranchCategoryResponse(
      success: true,
      statusCode: 200,
      message: '',
      data: SalesByBranchCategoryData(
        totalSales: totalSales,
        totalNetSlsQty: totalNetSlsQty,
        branchSales: filteredBranchSales,
        categorySales: [],
      ),
    );
  }
}
