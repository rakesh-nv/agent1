import 'package:get/get.dart';
import 'package:mbindiamy/api_services/regionalManager/departmentSales_api_services.dart';
import 'package:mbindiamy/model/regionalHead/DepartmentSale_model.dart';

class DepartmentSalesController extends GetxController {
  final departmentSalesApiService _apiService = departmentSalesApiService();
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var data = Rx<DepartmentSalesResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    // loadWeeklySalesTrend(); // optionally auto-load on init
  }

  Future<void> loadWeeklySalesTrend() async {
    isLoading(true);
    errorMessage(null);

    try {
      final response = await _apiService.fetchDepartmentSales();
      data.value = response;
    } catch (e) {
      // errorMessage(e.toString());
      data.value = null;
    } finally {
      isLoading(false);
    }
  }
}
