import 'package:get/get.dart';
import 'package:mbindiamy/api_services/sales/top_artical_api_services.dart';
import 'package:mbindiamy/model/top_artical_model.dart';

class TopArticlesController extends GetxController {
  final TopArticlesApiService _apiService;

  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var data = Rx<TopArticlesResponse?>(null);

  TopArticlesController({TopArticlesApiService? apiService})
    : _apiService = apiService ?? TopArticlesApiService();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadTopArticles() async {
    isLoading(true);
    errorMessage(null);

    try {
      data.value = await _apiService.fetchTopArticles();
    } catch (e) {
      errorMessage(e.toString());
      data.value = null; // Clear previous data on error
    } finally {
      isLoading(false);
    }
  }
}
