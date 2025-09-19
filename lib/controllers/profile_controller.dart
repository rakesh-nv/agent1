import 'package:get/get.dart';
import 'package:mbindiamy/controllers/login_controller.dart';
import '../api_services/profile_update_api_services.dart';
import '../model/profile_update_model.dart';
import '../model/login_model.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);
  var profileData = Rx<ProfileUpdateData?>(null);

  final _apiService = ProfileUpdateApiServices();
  final LoginController _loginController = Get.find<LoginController>();

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
        // Update LoginController's user data as well
        if (response.data != null && _loginController.loginResponse.value != null) {
          final currentLoginUser = _loginController.loginResponse.value!.data!.user;
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
          );
          await _loginController.updateLoginResponseUserData(updatedUser);
        }
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
