import 'package:get/get.dart';
import '../api_services/subordinates_aggregation_api_services.dart';
import '../model/subordinates_aggregation_model.dart';

class SubordinatesAggregationController extends GetxController {
  final SubordinatesAggregationApiService _apiService =
      SubordinatesAggregationApiService();

  var isLoading = false.obs;
  var subordinatesResponse = Rxn<SubordinatesAggregationResponse>();
  var subordinatesTodaysResponse = Rxn<SubordinatesAggregationResponse>();
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // fetchSubordinatesAggregation(); // Fetch data on controller initialization
  }

  Future<void> fetchSubordinatesAggregation() async {
    try {
      isLoading.value = true;
      errorMessage.value = null; // Reset error message

      final response = await _apiService.fetchSubordinatesAggregation();

      if (response != null && response.success) {
        subordinatesResponse.value = response;
      } else {
        errorMessage.value =
            response?.message ?? 'Failed to fetch subordinate data';
      }
    } catch (e) {
      // Log the technical error for debugging
      print('Error fetching subordinates aggregation: $e');
      errorMessage.value = 'An error occurred while fetching data';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubordinatesTodaysAggregation() async {
    try {
      isLoading.value = true;
      errorMessage.value = null; // Reset error message

      final response = await _apiService.fetchSubordinatesTodaysAggregation();

      if (response != null && response.success) {
        subordinatesTodaysResponse.value = response;
      } else {
        errorMessage.value = response?.message ?? 'Failed to fetch today\'s subordinate data';
      }
    } catch (e) {
      print('Error fetching today\'s subordinates aggregation: $e');
      errorMessage.value = 'An error occurred while fetching today\'s data';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchSubordinatesAggregation(); // Reuse fetch logic for refresh
  }
}
