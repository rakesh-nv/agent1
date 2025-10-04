import 'package:get/get.dart';
import 'package:mbindiamy/controllers/login_controller.dart';
import '../api_services/profile_update_api_services.dart';
import '../model/profile_update_model.dart';
import '../model/login_model.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);
  final profileData = Rx<ProfileUpdateData?>(null);

  final _apiService = ProfileUpdateApiServices();
  final LoginController _loginController = Get.find<LoginController>();

  /// Updates profile data both on server and locally
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

        // ✅ Update the LoginController’s stored user data
        if (_loginController.loginResponse.value?.data?.user != null) {
          final currentLoginUser =
              _loginController.loginResponse.value!.data!.user;

          // Create a new updated User object with new profile data
          final updatedUser = User(
            id: currentLoginUser.id,
            name: name,
            email: email,
            mobile: mobile,
            userType: currentLoginUser.userType,
            grade: currentLoginUser.grade,
            reportingTo: currentLoginUser.reportingTo,
            isAllBranches: currentLoginUser.isAllBranches,
            isAllCategories: currentLoginUser.isAllCategories,
            selectedBranches: currentLoginUser.selectedBranches,
            selectedCategories: currentLoginUser.selectedCategories,
            selectedBranchAliases: currentLoginUser.selectedBranchAliases,
            selectedCategoryNames: currentLoginUser.selectedCategoryNames,
            templateId: currentLoginUser.templateId,
            isBlocked: currentLoginUser.isBlocked,
            lastLogin: currentLoginUser.lastLogin,
            createdAt:currentLoginUser.createdAt,
            updatedAt: currentLoginUser.updatedAt,
          );

          // 🔁 Update stored login data in Hive
          await _loginController.updateLoginResponseUserData(updatedUser);
        }
      } else {
        errorMessage("Failed to update profile. Please try again.");
      }
    } catch (e) {
      if (e.toString().contains("SocketException")) {
        errorMessage("No Internet connection. Please check your network.");
      } else {
        errorMessage("Error updating profile: ${e.toString()}");
      }
    } finally {
      isLoading(false);
    }
  }
}
