import 'package:flutter/material.dart';
import 'package:mbindiamy/screen/sales/sales_dashboard_screen.dart';
import 'package:mbindiamy/screen/sales/stafInBranch/branch_manager_dashboard.dart';
import 'package:mbindiamy/screen/sales/stafNotInBranch/purchase/regional_purchase_head_dashboard.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/controllers/login_controller.dart';
import 'package:mbindiamy/screen/businessHead/business_head_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final LoginController loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppStyle.w(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppStyle.w(8)),
        borderSide: BorderSide(color: AppStyle.appBarColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppStyle.w(12),
        vertical: AppStyle.h(14),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    // Email format validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    await loginController.login(email, password);

    setState(() {}); // Force rebuild to re-evaluate errorMessage.value

    print(
      "Debug: errorMessage.value after login attempt: ${loginController.errorMessage.value}",
    );

    if (loginController.errorMessage.value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginController.errorMessage.value!)),
      );
    } else {
      // final SharedPreferences pref = await SharedPreferences.getInstance();
      // final userGrade = pref.getString(AppConstants.userGrade);
      final userGrade = loginController.loginResponse.value?.data!.user.grade;
      print(userGrade);
      switch (userGrade) {
        case "Grade 1":
        // Business Head (CEO)
          Get.offAll(() => BusinessHeadDashboard());
          break;
        case "Grade 2":
        // Sales Head
        // Purchase Head
        // Regional Purchase Head
        // Area/Cluster Head
          Get.offAll(() => const RegionalPurchaseHeadDashboard());
          break;
        case "Grade 3":
        // Branch Manager
        // Billing Manager
        // Sales Coordinator
        // Purchase Coordinator
          Get.offAll(() => const BranchManagerDashboard());
          break;
        case "Grade 4":
        // Sales Agent
        // Purchase Coordinator
          Get.offAll(() => SalesAgentDashBoard());
          break;
        case "Grade 5":
        // Sales Agent
        // Purchase Coordinator
          Get.offAll(() => SalesAgentDashBoard());
          break;
        case "Grade 6":
        // Sales Agent
        // Purchase Coordinator
          Get.offAll(() => SalesAgentDashBoard());
          break;
        case "Grade 7":
        // Sales Agent
        // Purchase Coordinator
          Get.offAll(() => SalesAgentDashBoard());
          break;
        default:
        //  If no matching grade found → go to Login
          Get.offAll(() => const LoginScreen());
      }
      // Get.offAll(() => const DashboardScreen());
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DEBUG: LoginScreen build method called.');
    AppStyle.init(context);
    final size = MediaQuery.of(context).size;
    final padding = AppStyle.w(16);
    final spacing = AppStyle.h(size.height * 0.025);

    debugPrint('DEBUG: LoginScreen - building Scaffold.');
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - spacing * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppStyle.w(12)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: spacing * 2,
                    ),
                    child: Obx(() {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon(Icons.person,size: 100,),
                          SizedBox(
                            height: AppStyle.h(100),
                            child: Image.asset(
                              'assets/MBZ_logo_130x.webp',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: spacing),
                          Text(
                            'Welcome Back',
                            style: AppStyle.headTextStyle().copyWith(),
                          ),
                          SizedBox(height: spacing / 4),
                          Text(
                            "Please sign in to your account",
                            style: AppStyle.normalTextStyle(),
                          ),
                          SizedBox(height: spacing * 1.5),
                          TextField(
                            controller: _usernameController,
                            decoration: _inputDecoration(
                              label: 'Email',
                              icon: Icons.person_outline,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: spacing),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _inputDecoration(
                              label: 'Password',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: spacing * 1.5),
                          SizedBox(
                            width: double.infinity,
                            height: AppStyle.h(50),
                            child: ElevatedButton(
                              onPressed: loginController.isLoading.value
                                  ? null
                                  : () => _handleLogin(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppStyle.appBarColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppStyle.w(8),
                                  ),
                                ),
                              ),
                              child: loginController.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Roboto',
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: spacing),
                          Text(
                            'Log in securely to your account',
                            style: AppStyle.normalTextStyle(),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
