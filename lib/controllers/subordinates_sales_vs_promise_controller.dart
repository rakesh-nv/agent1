import 'package:get/get.dart';
import 'package:mbindiamy/api_services/sales/subordinates_sales_vs_promise_api_services.dart';
import 'package:mbindiamy/model/subordinates_sales_vs_promise_model.dart';

class SubordinatesSalesVsPromiseController extends GetxController {
  final SubordinatesSalesVsPromiseApiServices _apiServices =
      SubordinatesSalesVsPromiseApiServices();

  /// Holds the fetched data
  var subordinatesSalesVsPromiseData = Rx<SubordinatesSalesVsPromiseModel?>(
    null,
  );

  /// Loading state
  var isLoading = false.obs;

  /// Error message
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // fetchSubordinatesSalesVsPromise();
  }

  Future<void> fetchSubordinatesSalesVsPromise() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final data = await _apiServices.getSubordinatesSalesVsPromise();


      if (data != null) {
        subordinatesSalesVsPromiseData.value = data;
      } else {
        errorMessage.value = "No data received";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      // Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
