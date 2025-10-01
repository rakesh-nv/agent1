// import 'package:get/get.dart';
// import '../api_services/subordinates_aggregation_api_services.dart';
// import '../model/subordinates_aggregation_model.dart';
//
// class SubordinatesAggregationController extends GetxController {
//   final SubordinatesAggregationApiService _apiService =
//       SubordinatesAggregationApiService();
//
//   var isLoading = false.obs;
//   var subordinatesResponse = Rxn<SubordinatesAggregationResponse>();
//   var errorMessage = "".obs;
//
//   Future<void> fetchSubordinatesAggregation(String token) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = "";
//
//       final response = await _apiService.fetchSubordinatesAggregation();
//
//       if (response != null && response.success == true) {
//         subordinatesResponse.value = response;
//       } else {
//         errorMessage.value = response?.message ?? "Failed to fetch data";
//       }
//     } catch (e) {
//       errorMessage.value = "Error: $e";
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
