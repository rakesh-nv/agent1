import 'package:get/get.dart';
import '../api_services/profile_update_api_services.dart';
import '../model/profile_update_model.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var profileData = Rx<ProfileUpdateData?>(null);

  final _apiService = ProfileUpdateApiServices();

  Future<void> updateProfile({
    required String id,
    required String name,
    required String email,
    required String mobile,
  }) async {
    isLoading(true);
    errorMessage(null);
    try {


      final response = await _apiService.updateProfile(
        id: id,
        name: name,
        email: email,
        mobile: mobile,
      );

      if (response != null && response.success) {
        profileData.value = response.data;
      } else {
        errorMessage("Failed to update profile");
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
