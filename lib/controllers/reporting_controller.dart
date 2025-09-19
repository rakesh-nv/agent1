import 'package:get/get.dart';
import 'package:mbindiamy/api_services/reporting_to_api_services.dart';
import 'package:mbindiamy/model/reporting_model.dart';

class ReportingManagerController extends GetxController {
  final ReportingManagerApiService _apiService = ReportingManagerApiService();

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var manager = Rx<String?>(null);
  @override
  void onInit() {
    super.onInit();
    getReportingManager();
  }

  Future<void> getReportingManager() async {
    isLoading(true);
    errorMessage(null);
    try {
      final response = await _apiService.fetchReportingManager();
      print("-------------getReportingManager response---------:" + response.data.toString());
      manager.value = response.data?.name;
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
