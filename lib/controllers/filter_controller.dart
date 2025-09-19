import 'package:get/get.dart';
import 'package:mbindiamy/api_services/filter_api_services.dart';
import 'package:mbindiamy/model/filter_model.dart';

class FilterController extends GetxController {
  final FilterApi _filterApi = FilterApi();

  var filterResponse = Rx<FilterResponse?>(null);
  var isLoading = false.obs;
  var error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    // loadFilters();
  }

  Future<void> loadFilters() async {
    isLoading(true);
    error(null);
    // print("fffffffffffff");
    try {
      final response = await _filterApi.fetchFilters();

      if (response != null && response.success) {
        filterResponse.value = response;
      } else {
        error.value = "Failed to fetch filters";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}
