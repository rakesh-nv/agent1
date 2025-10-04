import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../api_services/branch/branch_promise_with_actual_api_services.dart';
import '../model/branch_wise_sales_model/atual_vs_promise_branch_model.dart' as BranchModel;
import 'package:get/get.dart';

import '../utils/app_constants.dart';
class PromiseActualController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);
  final data = Rx<BranchModel.PromiseActualResponse?>(null);

  final currentData = <Map<String, dynamic>>[].obs;
  final filteredData = <Map<String, dynamic>>[].obs;

  var currentYear = DateTime.now().year.obs;
  var currentMonth = DateTime.now().month.obs;

  final _api = PromiseWithActualApi();

  /// 👇 Add variable to hold sum of current month's promise
  final monthPromiseSum = 0.0.obs;

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

      final int yearNow = currentYear.value;
      final int monthNow = currentMonth.value;
      final int prevMonth = monthNow == 1 ? 12 : monthNow - 1;
      final int prevYear = monthNow == 1 ? yearNow - 1 : yearNow;

      final BranchModel.PromiseActualResponse currentResp = await _api
          .fetchPromiseWithActual(
        year: yearNow,
        month: monthNow,
        branch: branch,
      );
      final BranchModel.PromiseActualResponse prevResp = await _api
          .fetchPromiseWithActual(
        year: prevYear,
        month: prevMonth,
        branch: branch,
      );

      /// ✅ Calculate total promise of current month
      double totalPromise = 0.0;
      for (final loc in currentResp.data.locations) {
        for (final dv in loc.dailyValues) {
          totalPromise += dv.promise.toDouble();
        }
      }
      monthPromiseSum.value = totalPromise; // 👈 stored in variable

      // Merge daily values across locations for both months into a date map
      final Map<String, Map<String, double>> byDate = {};
      void addResponse(BranchModel.PromiseActualResponse resp) {
        for (final loc in resp.data.locations) {
          for (final dv in loc.dailyValues) {
            try {
              final DateTime dt = DateTime.parse(dv.date);
              final String key = DateFormat('yyyy-MM-dd').format(dt);
              final agg = byDate.putIfAbsent(
                key,
                    () => {"promise": 0.0, "actual": 0.0},
              );
              agg["promise"] = (agg["promise"] ?? 0) + (dv.promise.toDouble());
              agg["actual"] = (agg["actual"] ?? 0) + (dv.actual.toDouble());
            } catch (_) {}
          }
        }
      }

      addResponse(prevResp);
      addResponse(currentResp);

      final DateTime today = DateTime.now();
      final DateTime start = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(const Duration(days: 6));

      final List<Map<String, dynamic>> last7 = [];
      for (int i = 0; i < 7; i++) {
        final DateTime d = start.add(Duration(days: i));
        final String key = DateFormat('yyyy-MM-dd').format(d);
        final Map<String, double>? agg = byDate[key];
        final double promise = agg == null ? 0.0 : (agg["promise"] ?? 0.0);
        final double actual = agg == null ? 0.0 : (agg["actual"] ?? 0.0);
        final int percent = promise > 0
            ? ((actual / promise) * 100).round()
            : 0;
        last7.add({
          'date': DateFormat('d MMM yyyy').format(d),
          'promise': promise,
          'actual': actual,
          'percent': percent,
        });
      }

      currentData
        ..clear()
        ..addAll(last7);

      final compact = NumberFormat.compact();
      filteredData.value = last7
          .map(
            (e) => {
          'date': e['date'],
          'promise': compact.format((e['promise'] as double)).toLowerCase(),
          'actual': compact.format((e['actual'] as double)).toLowerCase(),
          'percent': e['percent'],
        },
      )
          .toList();
    } catch (e) {
      errorMessage.value = e.toString();
      data.value = null;
      currentData.clear();
      filteredData.clear();
      monthPromiseSum.value = 0.0; // reset on error
    } finally {
      isLoading(false);
    }
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
