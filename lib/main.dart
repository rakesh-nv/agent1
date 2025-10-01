import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mbindiamy/controllers/ArticleWithMrpAndStockController.dart';
import 'package:mbindiamy/screen/businessHead/business_head_dashboard.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/BranchManagerSalesVsPromiseController.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/categoryWiseSalesController.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/sales_comparison_controller.dart';
import 'package:mbindiamy/controllers/login_controller.dart';
import 'package:mbindiamy/controllers/reporting_controller.dart';
import 'package:mbindiamy/controllers/total_sales_controller.dart';
import 'package:mbindiamy/controllers/sales_by_phase_controller.dart';
import 'package:mbindiamy/controllers/promise_actual_controller.dart';
import 'package:mbindiamy/controllers/top_articles_controller.dart';
import 'package:mbindiamy/controllers/filter_controller.dart';
import 'package:mbindiamy/controllers/sales_branch_controller.dart';
import 'package:mbindiamy/controllers/subordinates_sales_vs_promise_controller.dart';

import 'package:mbindiamy/api_services/branchManager/todayAndYesterday_sales.dart';
import 'package:mbindiamy/api_services/sales/sales_by_branch_category_api_services.dart'
    as category_api;

import 'package:mbindiamy/screen/sales/sales_dashboard_screen.dart';
import 'package:mbindiamy/screen/login.dart';
import 'package:mbindiamy/screen/sales/stafInBranch/branch_manager_dashboard.dart';
import 'package:mbindiamy/screen/sales/stafNotInBranch/purchase/regional_purchase_head_dashboard.dart';
import 'package:mbindiamy/screen/sales/stafNotInBranch/regional_manager_dashboard.dart';

import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/utils/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/profile_controller.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('myBox'); // Open a box, you can name it as you like

  // Dependency Injection
  Get.put(LoginController());
  Get.put(ReportingManagerController());
  Get.put(
    TotalSalesController(
      apiService: SalesApiService(),
      connectivity: Connectivity(),
    ),
  );
  Get.put(BranchManagerSalesVsPromiseController());
  Get.put(SalesByPhaseController());
  Get.put(PromiseActualController());
  Get.put(TopArticlesController());
  Get.put(FilterController());
  Get.put(CategoryWiseSalesController(apiService: category_api.ApiService()));
  Get.put(SalesbranchController());
  Get.put(SalesComparisonController());
  Get.put(SubordinatesSalesVsPromiseController());
  Get.put(ProfileController());
  Get.put(ArticleController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppStyle.init(context);
    return GetMaterialApp(
      title: 'MB INDIA MIS',
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,
      home: const LauncherScreen(),
      // home: LoginScreen(),
    );
  }
}

/// 🔹 Launcher Screen: Auto login check
class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  final LoginController loginController = Get.find();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    try {
      //  Load any saved user data from controller
      await loginController.loadUserData();

      if (loginController.token.value != null &&
          loginController.savedEmail.value != null &&
          loginController.savedPassword.value != null) {
        await loginController.reLoginWithSavedCreds();

        if (!mounted) return;

        //  Load Hive (local storage)
        final box = Hive.box('myBox');
        final userGrade = box.get(AppConstants.userGrade);

        print('grade');
        print(userGrade);

        //  Route user to appropriate dashboard based on grade
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
            // Get.offAll(() => const RegionalPurchaseHeadDashboard());
            Get.offAll(() => RegionalManagerDashboard());
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
      } else {
        //  No saved login credentials → go to Login
        Get.offAll(() => const LoginScreen());
      }
    } catch (e, stack) {
      //  Catch any error (e.g., Hive/PlatformException)
      print("Error in _checkLogin: $e");
      print(stack);

      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
