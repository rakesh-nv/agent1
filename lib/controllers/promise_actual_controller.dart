import 'package:get/get.dart';
import 'package:mbindiamy/api_services/branch/branch_promise_with_actual_api_services.dart';
import 'package:mbindiamy/model/promise_vs_actual_model.dart';
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PromiseActualController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);
  final data = Rx<PromiseActualResponse?>(null);

  final currentData = <Map<String, dynamic>>[].obs; // full month data
  final filteredData = <Map<String, dynamic>>[].obs; // 👈 only up to today

  var currentYear = DateTime.now().year.obs;
  var currentMonth = DateTime.now().month.obs;

  final _api = PromiseWithActualApi();

  @override
  void onInit() {
    super.onInit();
    loadPromiseActualData();
  }

  Future<void> loadPromiseActualData() async {
    isLoading(true);
    errorMessage(null);

    try {
      final box = Hive.box('myBox');
      final branch = box.get(AppConstants.branch);
      // final token = box.get(AppConstants.keyToken);

      // if (branch == null || branch.isEmpty) {
      //   errorMessage.value = "No branch available from login";
      //   return;
      // }
      // if (token == null || token.isEmpty) {
      //   errorMessage.value = "No token available from login";
      //   return;
      // }

      final response = await _api.fetchPromiseWithActual(
        year: currentYear.value,
        month: currentMonth.value,
        branch: branch,
      );

      currentData.value = _api.mapToUiList(response);
      _updateFilteredData(); // 👈 always refresh filteredData
    } catch (e) {
      errorMessage.value = e.toString();
      data.value = null;
      currentData.clear();
      filteredData.clear();
    } finally {
      isLoading(false);
    }
  }

  void _updateFilteredData() {
    final today = DateTime.now().day;

    print(today);
    // take first `today` records (assuming your list is already ordered)
    final temp = currentData.take(today).toList();

    // reverse so latest day is last
    filteredData.value = temp.reversed.toList();
  }

  void changePeriod(int year, int month) {
    currentYear.value = year;
    currentMonth.value = month;
    loadPromiseActualData();
  }

  void refreshData() {
    loadPromiseActualData();
  }
}
