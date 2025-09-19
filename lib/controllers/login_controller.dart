import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mbindiamy/api_services/auth/login_api_services.dart';
import 'package:mbindiamy/model/login_model.dart';
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:mbindiamy/screen/login.dart';
import 'dart:convert';

class LoginController extends GetxController {
  final LoginApiService _apiService = LoginApiService();

  var isLoading = false.obs;
  var token = Rx<String?>(null);
  var savedEmail = Rx<String?>(null);
  var savedPassword = Rx<String?>(null);
  var errorMessage = Rx<String?>(null);
  var loginResponse = Rx<LoginResponse?>(null);
  var savedBranch = Rx<String?>(null);
  var savedGrade = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Load stored user data from SharedPreferences
  Future<void> loadUserData() async {
    final box = Hive.box('myBox');
    token.value = box.get(AppConstants.keyToken);
    savedEmail.value = box.get(AppConstants.keyEmail);
    savedPassword.value = box.get(AppConstants.keyPassword);
    savedBranch.value = box.get(AppConstants.branch);
    savedGrade.value = box.get(AppConstants.userGrade);

    final loginResponseJson = box.get(AppConstants.loginResponse);
    if (loginResponseJson != null) {
      loginResponse.value = LoginResponse.fromJson(
        jsonDecode(loginResponseJson),
      );
    }

    // if (token.value != null && token.value!.isNotEmpty) {
    //   Get.offAll(() => const RegionalManagerDashboard());
    // } else if (savedEmail.value != null && savedPassword.value != null) {
    //   reLoginWithSavedCreds();
    // }
  }

  /// Save user data in SharedPreferences
  Future<void> _saveUserData(
    String token,
    String email,
    String password,
    String userType,
    String branch,
    String grade,
    String id,
    String name,
    String mobile,
    String reportingTo,
    bool isAllBranches,
    bool isAllCategories,
    List<String> selectedBranches,
    List<String> selectedCategories,
    List<String> selectedBranchAliases,
    List<String> selectedCategoryNames,
    String templateIdId,
    String templateIdName,
    bool isBlocked,
    String lastLogin,
  ) async {
    final box = Hive.box('myBox');
    await box.put(AppConstants.keyToken, token);
    await box.put(AppConstants.keyEmail, email);
    await box.put(AppConstants.keyPassword, password);
    await box.put(AppConstants.userType, userType);
    await box.put(AppConstants.branch, branch);
    await box.put(AppConstants.userGrade, grade);
    await box.put(AppConstants.userId, id);
    await box.put(AppConstants.userName, name);
    await box.put(AppConstants.userMobile, mobile);
    await box.put(AppConstants.userReportingTo, reportingTo);
    await box.put(AppConstants.isAllBranches, isAllBranches);
    await box.put(AppConstants.isAllCategories, isAllCategories);
    await box.put(AppConstants.selectedBranches, selectedBranches);
    await box.put(AppConstants.selectedCategories, selectedCategories);
    await box.put(AppConstants.selectedBranchAliases, selectedBranchAliases);
    await box.put(AppConstants.selectedCategoryNames, selectedCategoryNames);
    await box.put(AppConstants.templateIdId, templateIdId);
    await box.put(AppConstants.templateIdName, templateIdName);
    await box.put(AppConstants.isBlocked, isBlocked);
    await box.put(AppConstants.lastLogin, lastLogin);

    // this.token.value = token;
    savedEmail.value = email;
    savedPassword.value = password;

    // Save the entire login response as JSON
    if (loginResponse.value != null) {
      await box.put(
        AppConstants.loginResponse,
        jsonEncode(loginResponse.value!.toJson()),
      );
    }
  }

  /// Handle login
  Future<void> login(String email, String password) async {
    isLoading(true);
    errorMessage(null);
    try {
      final loginModel = await _apiService.login(email, password);

      if (loginModel.statusCode == 200) {
        // print("✅ Login successful, tok: ${loginModel.data?.token}");
        await _saveUserData(
          loginModel.data!.token,
          email,
          password,
          loginModel.data!.user.userType,
          loginModel.data!.user.selectedBranchAliases.isNotEmpty
              ? loginModel.data!.user.selectedBranchAliases.first
              : '',
          loginModel.data!.user.grade,
          loginModel.data!.user.id,
          loginModel.data!.user.name,
          loginModel.data!.user.mobile,
          loginModel.data!.user.reportingTo,
          loginModel.data!.user.isAllBranches,
          loginModel.data!.user.isAllCategories,
          loginModel.data!.user.selectedBranches,
          loginModel.data!.user.selectedCategories,
          loginModel.data!.user.selectedBranchAliases,
          loginModel.data!.user.selectedCategoryNames,
          loginModel.data!.user.templateId.id,
          loginModel.data!.user.templateId.templateName ?? '',
          loginModel.data!.user.isBlocked,
          loginModel.data!.user.lastLogin,
        );

        loginResponse.value = loginModel;
        errorMessage.value =
            null; // Clear any previous error message on successful login

        // Navigate after success
        // Get.offAll(() => const RegionalManagerDashboard());
      }
    } catch (e) {
      String userMessage = "Login failed. Please try again.";
      if (e is Exception &&
          e.toString().contains("Login failed. Status code: 404")) {
        try {
          final errorBody = e.toString().split("Body:").last.trim();
          final Map<String, dynamic> errorJson = jsonDecode(errorBody);
          if (errorJson["message"] == "User not found!") {
            userMessage = "Invalid email or password.";
          }
        } catch (_) {
          // Fallback to generic message if parsing fails
        }
      } else if (e.toString().contains("No Internet connection")) {
        userMessage = "No Internet connection. Please check your network.";
      } else if (e.toString().contains("Invalid response format")) {
        userMessage = "Server error. Please try again later.";
      }
      errorMessage(userMessage);
      token.value = null;
      savedEmail.value = null;
      savedPassword.value = null;
      final box = Hive.box('myBox');
      await box.delete(AppConstants.keyEmail);
      await box.delete(AppConstants.keyPassword);
    } finally {
      isLoading(false);
    }
  }

  /// Re-login with stored credentials
  Future<void> reLoginWithSavedCreds() async {
    await login(
      savedEmail.value!,
      savedPassword.value!,
    ); // These are guaranteed not null by the caller
  }

  /// Logout user
  Future<void> logout() async {
    final box = Hive.box('myBox');
    await box.delete(AppConstants.keyToken);
    await box.delete(AppConstants.keyEmail);
    await box.delete(AppConstants.keyPassword);
    await box.delete(AppConstants.branch);
    await box.delete(AppConstants.userGrade);
    token.value = null;
    savedEmail.value = null;
    savedPassword.value = null;
    loginResponse.value = null;
    Get.offAll(() => const LoginScreen());
  }
}
