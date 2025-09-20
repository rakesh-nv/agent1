import 'package:get/get.dart';
import '../api_services/ArticleWithMrpAndStock.dart';
import '../model/ArticlesWithMrpAndStock_model.dart';

class ArticleController extends GetxController {
  final ArticleWithMrpStockApiService _apiService = ArticleWithMrpStockApiService();

  var isLoading = false.obs;
  var articles = <Data>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles(); // Automatically fetch on controller init
  }

  Future<void> fetchArticles() async {
    try {
      isLoading(true);
      errorMessage(''); // Clear previous errors

      final response = await _apiService.fetchArticles();

      if (response != null && response.data != null && response.data!.isNotEmpty) {
        articles.assignAll(response.data!); // Assign data to RxList
        print("Fetched articles: ${articles.length}");
      } else {
        articles.clear();
        errorMessage("No articles found.");
      }
    } catch (e) {
      articles.clear();
      errorMessage("Failed to fetch articles: $e");
    } finally {
      isLoading(false);
    }
  }
}
