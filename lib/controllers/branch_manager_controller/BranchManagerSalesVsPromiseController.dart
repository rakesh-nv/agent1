import 'package:get/get.dart';
import 'package:mbindiamy/api_services/branchManager/BranchManagerSalesVsPromise_api_service.dart';
import 'package:mbindiamy/model/branchManagerModel/BranchManagerSalesVsPromiseModel.dart';

class BranchManagerSalesVsPromiseController extends GetxController {
  final BranchManagerSalesVsPromiseApiService _apiService =
      BranchManagerSalesVsPromiseApiService();
  var salesVsPromiseData = Rx<BranchManagerSalesVsPromiseModel?>(null);
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchSalesVsPromiseData();
  }

  Future<void> fetchSalesVsPromiseData() async {
    try {
      isLoading(true);
      var response = await _apiService.BmSalesVsPromise();
      print(response.data.thisWeek.totals.totalSales);
      print(response.data.lastWeek.totals.totalSales);
      salesVsPromiseData(response);
    } catch (e) {
      errorMessage(e.toString());
      print('Error fetching BranchManagerSalesVsPromiseData: $e');
    } finally {
      isLoading(false);
    }
  }
}
