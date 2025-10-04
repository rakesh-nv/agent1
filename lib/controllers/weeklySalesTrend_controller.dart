import 'package:get/get.dart';

import '../api_services/sales/weeklySalesTrend_api_services.dart';
import '../model/weeklySalesTrend_model.dart';

class WeeklySalesTrendController extends GetxController {
  final WeeklySalesTrendApiService _apiService = WeeklySalesTrendApiService();

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var data = Rx<WeeklySalesTrendResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    // loadWeeklySalesTrend(); // optionally auto-load on init
  }

  Future<void> loadWeeklySalesTrend() async {
    isLoading(true);
    errorMessage(null);

    try {
      final response = await _apiService.fetchWeeklySalesTrend();
      data.value = response;
    } catch (e) {
      errorMessage(e.toString());
      data.value = null;
    } finally {
      isLoading(false);
    }
  }
}
