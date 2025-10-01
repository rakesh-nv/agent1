import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/api_services/sales/currentPhaseApi_services.dart';

import '../../model/salesagentModel/sales_comparison_by_phase_modal.dart';
class CurrentPhaseController extends GetxController {
final CurrentPhaseApiServices _apiService = CurrentPhaseApiServices();
  var salesData = Rx<SalesComparisonByPhaseResponse?>(null);
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // loadSalesByPhase();
  }

  Future<void> loadCurrentPhase() async {
    isLoading(true);
    errorMessage(null);

    try {
      salesData.value = await _apiService.fetchCurrentPhaseData();
    } catch (e) {
      errorMessage(e.toString());
      debugPrint("Error loading sales by phase: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> retry() async {
    await loadCurrentPhase();
  }
}
