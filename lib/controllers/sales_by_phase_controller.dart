import 'package:get/get.dart';
import 'package:mbindiamy/api_services/sales/sales_by_phase_api_services.dart';
import 'package:mbindiamy/model/sales_by_phase_model.dart';
import 'package:flutter/material.dart'; // For debugPrint

class SalesByPhaseController extends GetxController {
  final SalesByPhaseApiService _apiService = SalesByPhaseApiService();

  var salesData = Rx<SalesByPhaseResponse?>(null);
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSalesByPhase();
  }

  Future<void> loadSalesByPhase() async {
    isLoading(true);
    errorMessage(null);

    try {
      salesData.value = await _apiService.fetchSalesByPhase();
    } catch (e) {
      errorMessage(e.toString());
      debugPrint("Error loading sales by phase: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> retry() async {
    await loadSalesByPhase();
  }
}
