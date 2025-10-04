import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/categoryWiseSalesController.dart';
import 'package:mbindiamy/controllers/regionalManager/departmentSales_controller.dart';
import 'package:mbindiamy/widget/appbar_widget.dart';

import '../../../controllers/ArticleWithMrpAndStockController.dart';
import '../../../controllers/branch_manager_controller/sales_comparison_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/reporting_controller.dart';
import '../../../controllers/subordinates_sales_vs_promise_controller.dart';
import '../../../controllers/top_articles_controller.dart';
import '../../../controllers/total_sales_controller.dart';
import '../../../controllers/weeklySalesTrend_controller.dart';
import '../../../model/top_artical_model.dart';

// import '../../../style/appstyle.dart';
import '../../../model/subordinates_sales_vs_promise_model.dart' as SalesModel;

import '../../../model/top_artical_model.dart' as TopArticleData;
import '../../../style/appTextStyle.dart';
import '../../../style/siseConfig.dart';
import '../../../widget/navigator_widget.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class RegionalManagerDashboard extends StatefulWidget {
  const RegionalManagerDashboard({super.key});

  @override
  State<RegionalManagerDashboard> createState() =>
      _RegionalManagerDashboardState();
}

class _RegionalManagerDashboardState extends State<RegionalManagerDashboard> {
  int currentSet = 0; // For Promise vs Actual pagination
  int currentIndex = 0; // For Top Articles pagination
  final PageController _pageController = PageController();

  // final ScrollController _mainScrollController =
  //     ScrollController(); // Added for main scrollbar

  final LoginController loginController = Get.find<LoginController>();
  final ReportingManagerController reportingController =
      Get.find<ReportingManagerController>();
  final TotalSalesController totalSalesController =
      Get.find<TotalSalesController>();
  final SalesComparisonController salesComparisonController =
      Get.find<SalesComparisonController>();
  final SubordinatesSalesVsPromiseController
  subordinatesSalesVsPromiseController = Get.find();
  final CategoryWiseSalesController categoryWiseSalesController =
      Get.find<CategoryWiseSalesController>();
  final TopArticlesController topArticlesController =
      Get.find<TopArticlesController>();

  final WeeklySalesTrendController weeklySalesTrendController =
      Get.find<WeeklySalesTrendController>();

  final DepartmentSalesController departmentSalesController = Get.find<DepartmentSalesController>();
  // final PromiseActualController promiseController = Get.find<PromiseActualController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      await Future.wait([
        totalSalesController.fetchTodaysSales().catchError((e) {
          debugPrint("Reporting error: $e");
        }),
        reportingController.getReportingManager().catchError((e) {
          debugPrint("Reporting error: $e");
        }),
        salesComparisonController.fetchTodaysSales().catchError((e) {
          debugPrint("Today's Sales error: $e");
        }),
        salesComparisonController.fetchYesterdaySales().catchError((e) {
          debugPrint("Yesterday's Sales error: $e");
        }),
        salesComparisonController.fetchThisMonthSales().catchError((e) {
          debugPrint("This Month's Sales error: $e");
        }),
        categoryWiseSalesController.fetchCategoryWiseSales().catchError((e) {
          debugPrint("Yesterday's Sales error: $e");
        }),
        weeklySalesTrendController.loadWeeklySalesTrend().catchError((e) {
          debugPrint("loadWeeklySalesTrend Sales error: $e");
        }),
        departmentSalesController.loadWeeklySalesTrend().catchError((e) {
          debugPrint("loadWeeklySalesTrend Sales error: $e");
        }),
        subordinatesSalesVsPromiseController
            .fetchSubordinatesSalesVsPromise()
            .catchError(
              (e) => debugPrint("fetchSubordinatesSalesVsPromise error"),
            ),
        topArticlesController.loadTopArticles().catchError((e) {
          debugPrint("loadTopArticles error");
        }),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dashboard data: $e')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _mainScrollController.dispose(); // Dispose main scroll controller
    super.dispose();
  }

  void showNext(int length) {
    if (currentIndex < length - 1) {
      setState(() {
        currentIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    }
  }

  void showPrevious(int length) {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void goNext() {
    setState(() {
      currentSet++;
    });
  }

  void goPrev() {
    setState(() {
      currentSet--;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final horizontalPadding = SizeConfig.isDesktop
        ? SizeConfig.w(40)
        : SizeConfig.isTablet
        ? SizeConfig.w(20)
        : SizeConfig.w(8);

    return Obx(() {
      // // late final loginResponse = loginController.loginResponse.value;
      // if (loginController.loginResponse.value == null ||
      //     loginController.loginResponse.value?.data == null ||
      //     loginController.loginResponse.value?.data!.user == null) {
      //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
      // }
      final userName =
          loginController.loginResponse.value?.data!.user.name ?? "Loading...";
      final userId = loginController.loginResponse.value?.data?.user.id ?? '';
      // final reportingName = reportingController.manager.value?? "Loading...";
      final reportingName = reportingController.manager.value ?? "Loading...";
      final totalNetAmount =
          totalSalesController.salesData.value?.totalNetAmount ?? 0.0;
      final totalNetSlsQty =
          totalSalesController.salesData.value?.totalNetSlsQty ?? 0;

      final currentUser = loginController.loginResponse.value?.data!.user;
      // final String? displayUserId = currentUser?.userType == 'head'
      //     ? 'All Branches'
      //     : (currentUser!.selectedBranchAliases.isNotEmpty
      //           ? currentUser.selectedBranchAliases.first
      //           : '');
      final salesDateStr = DateFormat('dd/MM/yyyy').format(DateTime.now());

      return Scaffold(
        backgroundColor: Colors.white,
        drawer: NavigationDrawerWidget(),
        appBar: CustomAppBar(
          userName: userName,
          reportingTo: reportingName,
          onNotificationPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications clicked!')),
            );
          },
        ),

        body: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: Obx(() {
            if (!salesComparisonController.hasConnection.value) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  // vertical: SizeConfig.h(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: SizeConfig.w(60),
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: SizeConfig.h(20)),
                      Text(
                        "No Internet Connection",
                        style: TextStyle(
                          fontSize: SizeConfig.w(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(10)),
                      Text(
                        "Please check your internet connection and try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeConfig.w(14),
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: SizeConfig.h(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Revenue Card
                  _buildInfoCard(
                    1,
                    "Regional Revenue ($salesDateStr)",
                    "₹${NumberFormat("#,##,###").format(totalNetAmount)}",
                    Icons.currency_rupee,
                    Colors.green,
                  ),
                  _buildInfoCard(
                    1,
                    "Unit Sold ($salesDateStr)",
                    "$totalNetSlsQty Qty",
                    Icons.shopping_cart_outlined,
                    Colors.blue,
                  ),
                  Obx(() {
                    final incentiveValue =
                        totalSalesController.myIncentive.value ?? 0.0;
                    return _buildInfoCard(
                      1,
                      "My Incentive ($salesDateStr)",
                      incentiveValue > 0
                          ? "₹${NumberFormat("#,##,###").format(incentiveValue)}"
                          : "₹0",
                      Icons.trending_up,
                      incentiveValue > 0 ? Colors.purple : Colors.grey,
                    );
                  }),

                  // Sales Comparison Card
                  _buildSalesComparisonCard(),
                  _buildBranchPerformanceCard(),
                  _buildSubordinatesSalesVsPromiseCard(),
                  // Category-wise Sales Card
                  _buildCategoryWiseSalesCard(),
                  RegionalSalesTrendsCard(),
                  // Highest Selling Product
                  _buildDepartmentWiseSales(),
                  highestSellingProduct(context),
                  ArticleWithMrpAndStockCard(),
                  SizedBox(height: SizeConfig.h(16)),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildSubordinatesSalesVsPromiseCard() {
    return Obx(() {
      if (subordinatesSalesVsPromiseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (subordinatesSalesVsPromiseController
              .subordinatesSalesVsPromiseData
              .value
              ?.data ==
          null) {
        return const SizedBox.shrink(); // show nothing if no data
      }

      final data = subordinatesSalesVsPromiseController
          .subordinatesSalesVsPromiseData
          .value!
          .data!;
      final subordinates = data.subordinates;

      if (subordinates == null || subordinates.isEmpty) {
        return const SizedBox.shrink(); // 🔹 don't show anything
      }

      // Calculate total sales and total promise across all subordinates
      double totalSales = 0.0;
      double totalPromise = 0.0;
      for (var subordinate in subordinates) {
        totalSales += subordinate.totalSales ?? 0;
        totalPromise += subordinate.totalPromise ?? 0;
      }
      final percentage = totalPromise > 0
          ? (totalSales / totalPromise) * 100
          : 0.0;

      return Card(
        color: Colors.white,
        // margin: EdgeInsets.symmetric(vertical: SizeConfig.h(8)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events_outlined),
                  Text(
                    "Team Incentive Dashboard",
                    style: AppTextStyles.subheadlineText(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(5),
                    color: Colors.green.withOpacity(0.2),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${NumberFormat("#,##,###").format(totalSales)}",
                          style: AppTextStyles.subheadlineText(
                            color: Colors.green,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Regional Team Performance",
                              style: AppTextStyles.subheadlineText(),
                            ),
                            Text(
                              "${percentage.toStringAsFixed(1)}%",
                              style: AppTextStyles.bodyText(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                          minHeight: SizeConfig.h(12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Target: ₹${NumberFormat('#,##,###').format(totalPromise)}",
                              style: AppTextStyles.captionText(),
                            ),
                            Text(
                              "Remaining: ₹${NumberFormat('#,##,###').format(totalPromise - totalSales)}",
                              style: AppTextStyles.captionText(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 300,
                child: Scrollbar(
                  thumbVisibility: true, // Always show scrollbar
                  thickness: 7, // Adjust thickness if needed
                  radius: const Radius.circular(8), // Rounded scrollbar
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subordinates.length,
                        itemBuilder: (context, index) {
                          final subordinate = subordinates[index];
                          return _buildSubordinateTile(subordinate);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSubordinateTile(SalesModel.Subordinate subordinate) {
    final totalSales = subordinate.totalSales ?? 0;
    final totalPromise = subordinate.totalPromise ?? 0;
    final percentage = totalPromise > 0
        ? (totalSales / totalPromise) * 100
        : 0.0;
    Color progressColor = Colors.grey;
    if (percentage >= 80) {
      progressColor = Colors.green;
    } else if (percentage >= 50) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(12)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.w(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${NumberFormat("#,##,###").format(totalSales)}",
                    style: AppTextStyles.subheadlineText(color: Colors.green),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subordinate.name ?? 'N/A',
                        style: AppTextStyles.subheadlineText(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${percentage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: SizeConfig.w(12),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(4)),
                  // Text(
                  //   "Email: ${subordinate.email ?? 'N/A'}",
                  //   style: TextStyle(
                  //     fontSize: SizeConfig.w(12),
                  //     color: Colors.grey[600],
                  //   ),
                  // ),
                  SizedBox(height: SizeConfig.h(8)),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: SizeConfig.h(8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Target: ₹${NumberFormat('#,##,###').format(totalPromise)}",
                        style: AppTextStyles.captionText(),
                      ),
                      Text(
                        "Remaining: ₹${NumberFormat('#,##,###').format(totalPromise - totalSales)}",
                        style: AppTextStyles.captionText(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(16)),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Branches:",
            //         style: TextStyle(
            //           fontSize: SizeConfig.w(14),
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: subordinate.branches?.length ?? 0,
            //         itemBuilder: (context, idx) {
            //           final branch = subordinate.branches![idx];
            //           final num branchPromise = branch.promised ?? 0;
            //           final num branchActualSales = branch.actualSales ?? 0;
            //           final double branchPercentage = branchPromise > 0
            //               ? (branchActualSales / branchPromise) * 100
            //               : 0.0;
            //           Color branchProgressColor = Colors.grey;
            //           if (branchPercentage >= 80) {
            //             branchProgressColor = Colors.green;
            //           } else if (branchPercentage >= 50) {
            //             branchProgressColor = Colors.orange;
            //           } else {
            //             branchProgressColor = Colors.red;
            //           }
            //           return Padding(
            //             padding: EdgeInsets.only(
            //               left: SizeConfig.w(16),
            //               top: SizeConfig.h(4),
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "${branch.branchAlias}: ₹${NumberFormat('#,##,###').format(branchActualSales)} / ₹${NumberFormat('#,##,###').format(branchPromise)}",
            //                   style: TextStyle(fontSize: SizeConfig.w(12)),
            //                 ),
            //                 LinearProgressIndicator(
            //                   value: branchPercentage / 100,
            //                   backgroundColor: Colors.grey[200],
            //                   valueColor: AlwaysStoppedAnimation<Color>(
            //                     branchProgressColor,
            //                   ),
            //                   minHeight: SizeConfig.h(6),
            //                   borderRadius: BorderRadius.circular(3),
            //                 ),
            //                 Align(
            //                   alignment: Alignment.centerRight,
            //                   child: Text(
            //                     "${branchPercentage.toStringAsFixed(1)}%",
            //                     style: TextStyle(
            //                       fontSize: SizeConfig.w(10),
            //                       color: branchProgressColor,
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //       Divider(height: SizeConfig.h(24)),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchPerformanceCard() {
    return Obx(() {
      final salesData = categoryWiseSalesController.salesData.value;

      if (categoryWiseSalesController.isLoading.value) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (salesData == null ||
          salesData.data?.categorySales == null ||
          salesData.data!.categorySales!.isEmpty) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("No Branch-wise sales data available.")),
          ),
        );
      }
      final totalSalesAmount = salesData.data?.totalSales ?? 0;
      final branch = salesData.data?.branchSales ?? [];
      print("gggggggggg");
      print(branch);
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_city_outlined,
                        size: SizeConfig.w(20),
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: SizeConfig.w(8)),
                      Text(
                        "Branch Performance",
                        style: AppTextStyles.subheadlineText(),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(8),
                      vertical: SizeConfig.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "${branch.length} Branches",
                      style: AppTextStyles.captionText(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: SizeConfig.w(8),
              //     vertical: SizeConfig.h(4),
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     child: Text(
              //       "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
              //       style: TextStyle(
              //         fontSize: SizeConfig.w(12),
              //         color: Colors.grey[700],
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              SizedBox(height: SizeConfig.h(16)),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: SizeConfig.w(16),
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: SizeConfig.w(8)),
                  Text(
                    "Regional Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)} ",
                    style: TextStyle(
                      fontSize: SizeConfig.w(14),
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(12)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: branch.length,
                itemBuilder: (context, index) {
                  final category = branch[index];
                  final categoryTotalAmount = category.totalAmount ?? 0;
                  final percentage = totalSalesAmount > 0
                      ? (categoryTotalAmount / totalSalesAmount) * 100
                      : 0.0;
                  Color progressColor = Colors.grey;
                  if (percentage >= 80) {
                    progressColor = Colors.green;
                  } else if (percentage >= 50) {
                    progressColor = Colors.orange;
                  } else {
                    progressColor = Colors.red;
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.branchAlias as String,
                              // style: TextStyle(fontSize: SizeConfig.w(14)),
                              style: AppTextStyles.bodyText(),
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Text(
                                  "${percentage.toStringAsFixed(1)}%",

                                  style: AppTextStyles.captionText(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                                  style: AppTextStyles.bodyText(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.h(4)),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green.shade700,
                          ),
                          minHeight: SizeConfig.h(6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCategoryWiseSalesCard() {
    return Obx(() {
      final salesData = categoryWiseSalesController.salesData.value;

      if (categoryWiseSalesController.isLoading.value) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      } else if (salesData == null ||
          salesData.data?.categorySales == null ||
          salesData.data!.categorySales!.isEmpty) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text("No category-wise sales data available."),
            ),
          ),
        );
      }
      final totalSalesAmount = salesData.data?.totalSales ?? 0;
      final categories = salesData.data?.categorySales ?? [];
      print("gggggggggg");
      print(categories);
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: SizeConfig.w(20),
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: SizeConfig.w(8)),
                        Flexible(
                          child: Text(
                            "Regional Category Sales",
                            maxLines: 2,
                            style: AppTextStyles.subheadlineText(),
                            overflow:
                                TextOverflow.ellipsis, // 👈 avoids overflow
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(8),
                      vertical: SizeConfig.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
                      style: AppTextStyles.captionText(color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: SizeConfig.w(8),
              //     vertical: SizeConfig.h(4),
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     child: Text(
              //       "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
              //       style: TextStyle(
              //         fontSize: SizeConfig.w(12),
              //         color: Colors.grey[700],
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              SizedBox(height: SizeConfig.h(16)),
              Row(
                children: [
                  Icon(
                    Icons.folder,
                    size: SizeConfig.w(16),
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: SizeConfig.w(8)),
                  Text(
                    "Sales Quantity: ${NumberFormat('#,##,###').format(salesData.data?.totalNetSlsQty ?? 0)}",
                    style: TextStyle(
                      fontSize: SizeConfig.w(14),
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(12)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final categoryTotalAmount = category.totalAmount ?? 0;
                  final percentage = totalSalesAmount > 0
                      ? (categoryTotalAmount / totalSalesAmount) * 100
                      : 0.0;
                  Color progressColor = Colors.grey;
                  if (percentage >= 80) {
                    progressColor = Colors.green;
                  } else if (percentage >= 50) {
                    progressColor = Colors.orange;
                  } else {
                    progressColor = Colors.red;
                  }
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.category as String,
                              style: AppTextStyles.bodyText(),
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Text(
                                  "${percentage.toStringAsFixed(1)}%",
                                  style: AppTextStyles.bodyText(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                                  style: AppTextStyles.bodyText(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.h(4)),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                          minHeight: SizeConfig.h(6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

 Widget _buildDepartmentWiseSales(){
    return Container(

    );
 }


  //  Highest Selling Products
  Widget highestSellingProduct(BuildContext context) {
    final topArticlesController = Get.find<TopArticlesController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        final paddingValue = SizeConfig.w(8); // Base padding
        final imageSize = MediaQuery.of(context).size.width * .23;
        final badgeWidth = SizeConfig.w(
          isMobile
              ? 50
              : isTablet
              ? 60
              : 70,
        ); // Scaled badge width
        final cardHeight = MediaQuery.of(context).size.width * .3;

        return Obx(() {
          final topArticles = topArticlesController.data.value?.data.take(7).toList() ?? [];
          return SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 1,
              // Matches the elevation used in other cards
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.w(5)),
              ),
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.w(4)),
              child: Padding(
                padding: EdgeInsets.all(paddingValue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Highest Selling Products",
                                maxLines: 2,
                                style: AppTextStyles.subheadlineText(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "(Last 7 Days)",
                                style: AppTextStyles.captionText(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (topArticles.isNotEmpty)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    showPrevious(topArticles.length),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: SizeConfig.w(isMobile ? 16 : 20),
                                  color: currentIndex > 0
                                      ? Colors.black87
                                      : Colors.grey,
                                ),
                                padding: EdgeInsets.all(SizeConfig.w(4)),
                              ),
                              Text("${currentIndex + 1}/${7}"),
                              IconButton(
                                onPressed: () => showNext(topArticles.length),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: SizeConfig.w(isMobile ? 16 : 20),
                                  color: currentIndex < topArticles.length - 1
                                      ? Colors.black87
                                      : Colors.grey,
                                ),
                                padding: EdgeInsets.all(SizeConfig.w(4)),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.h(8)),
                    SizedBox(
                      height: cardHeight,
                      child: topArticles.isEmpty
                          ? Center(
                              child: Text(
                                topArticlesController.isLoading.value
                                    ? "Loading top articles..."
                                    : "No top articles data available",
                                style: AppTextStyles.bodyText(
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: topArticles.length,
                              onPageChanged: (index) =>
                                  setState(() => currentIndex = index),
                              itemBuilder: (context, index) =>
                                  _buildProductCard(
                                    context: context,
                                    article: topArticles[index],
                                    imageSize: imageSize,
                                    paddingValue: paddingValue,
                                    badgeWidth: badgeWidth,
                                  ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required TopArticleData.ArticleData article,
    required double imageSize,
    required double paddingValue,
    required double badgeWidth,
  }) {
    final gpValue = article.gp;
    final formattedGp = gpValue.toStringAsFixed(2);
    final isMobile =
        SizeConfig.screenWidth <
        600; // Check screen width for additional responsiveness
    final hasImage =
        article.img.isNotEmpty; // Check image once and store result

    return Container(
      padding: EdgeInsets.all(paddingValue / (isMobile ? 1.5 : 1.2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.w(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.w(8)),
            ),
            child: hasImage
                ? _buildNetworkImage(article.img, imageSize)
                : _buildPlaceholderIcon(size: imageSize),
          ),
          SizedBox(width: SizeConfig.w(isMobile ? 8 : 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: MediaQuery.of(context).size.height * .01,
              children: [
                Text(
                  article.articleNo ?? 'N/A',
                  maxLines: 2,
                  style: AppTextStyles.bodyText(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount: ₹${article.netAmount.toStringAsFixed(2)}",
                      style: AppTextStyles.bodyText(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          "Qty: ${article.netQuantity}",
                          style: AppTextStyles.bodyText(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: SizeConfig.w(10)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.w(8),
                            vertical: SizeConfig.h(4),
                          ),
                          decoration: BoxDecoration(
                            color: _getGpColor(gpValue),
                            borderRadius: BorderRadius.circular(
                              SizeConfig.w(8),
                            ),
                          ),
                          constraints: BoxConstraints(minWidth: badgeWidth),
                          child: Text(
                            "GP: $formattedGp%",
                            style: AppTextStyles.smallText(
                              color: _getGpTextColor(gpValue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.w(8),
              top: SizeConfig.h(4),
            ),
            child: Icon(
              Icons.trending_up,
              color: _getTrendingColor(gpValue),
              size: SizeConfig.w(isMobile ? 20 : 24),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGpColor(double gpValue) => Colors.green.withOpacity(0.2);

  Color _getGpTextColor(double gpValue) => Colors.green[800]!;

  Color _getTrendingColor(double gpValue) => Colors.green;

  Widget _buildNetworkImage(String imageUrl, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeConfig.w(8)),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2.0, // Consistent thickness
                ),
              ),
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderIcon(size: size),
      ),
    );
  }

  Widget _buildPlaceholderIcon({double size = 50}) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image, size: size * 0.5, color: Colors.grey),
      ),
    );
  }


  Widget _buildSalesComparisonCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: SizeConfig.w(18),
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Regional Sales Comparison",
                      style: AppTextStyles.subheadlineText(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: SizeConfig.w(8),
                //     vertical: SizeConfig.h(4),
                //   ),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[200],
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                //   child: Text(
                //     "Limited Access",
                //     style: AppTextStyles.captionText(color: Colors.grey),
                //   ),
                // ),
              ],
            ),
            // SizedBox(height: SizeConfig.h(16)),
            Obx(() {
              final todaySales =
                  (salesComparisonController.todaySalesData.value ?? 0)
                      .toDouble();
              final yesterdaySales =
                  (salesComparisonController.yesterdaySalesData.value ?? 0)
                      .toDouble();
              final difference = todaySales - yesterdaySales;
              final percentageChange = yesterdaySales > 0
                  ? (difference / yesterdaySales) * 100
                  : 0.0;
              final (trendColor, trendIcon, trendText) = difference > 0
                  ? (
                      Colors.green,
                      Icons.trending_up,
                      "+${percentageChange.toStringAsFixed(1)}% vs yesterday (₹${difference.toStringAsFixed(0)})",
                    )
                  : difference < 0
                  ? (
                      Colors.red,
                      Icons.trending_down,
                      "${percentageChange.toStringAsFixed(1)}% vs yesterday (₹${difference.abs().toStringAsFixed(0)})",
                    )
                  : (Colors.orange, Icons.show_chart, "No change vs yesterday");

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          0,
                          "Today",
                          "₹${NumberFormat("#,##,###").format(todaySales)}",
                          null, // Keep the icon
                          null, // Keep the icon color
                        ),
                      ),
                      Expanded(
                        child: _buildInfoCard(
                          0,
                          "Yesterday",
                          "₹${NumberFormat("#,##,###").format(yesterdaySales)}",
                          null, // Icon is optional, passing null
                          null, // Icon color is optional, passing null
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(8),
                      vertical: SizeConfig.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          trendIcon,
                          color: trendColor,
                          size: SizeConfig.w(18),
                        ),
                        SizedBox(width: SizeConfig.w(5)),
                        Text(
                          trendText,
                          style: AppTextStyles.bodyText(
                            color: trendColor,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    double? elevation,
    String title,
    String value,
    IconData? icon,
    Color? iconColor,
  ) {
    // Determine if the screen is large (e.g., width > 600 pixels)
    final isLargeScreen = MediaQuery.of(context).size.height > 600;
    print("height: " + isLargeScreen.toString());
    // Set icon size based on screen size
    final iconSize = isLargeScreen
        ? MediaQuery.of(context).size.height * 0.01
        : MediaQuery.of(context).size.height * 0.01;

    return SizedBox(
      child: Card(
        elevation: elevation,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(12),
            vertical: SizeConfig.h(8),
          ),
          child: Row(
            children: [
              if (icon != null && iconColor != null) ...[
                Container(
                  padding: EdgeInsets.all(iconSize),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * .05,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * .03),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyText(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: SizeConfig.h(4)),
                    Text(
                      value,
                      style: AppTextStyles.bodyText(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerAnalyticsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: SizeConfig.w(20),
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Customer Analytics",
                      style: TextStyle(
                        fontSize: SizeConfig.w(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(8),
                    vertical: SizeConfig.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Today's Data",
                    style: TextStyle(
                      fontSize: SizeConfig.w(12),
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(16)),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.w(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                size: SizeConfig.w(18),
                                color: Colors.green.shade700,
                              ),
                              SizedBox(width: SizeConfig.w(8)),
                              Text(
                                "New Customers",
                                style: TextStyle(
                                  fontSize: SizeConfig.w(14),
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.h(8)),
                          Text(
                            "24",
                            style: TextStyle(
                              fontSize: SizeConfig.w(20),
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            "↗ +12%",
                            style: TextStyle(
                              fontSize: SizeConfig.w(12),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.w(16)),
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.w(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.people,
                                size: SizeConfig.w(18),
                                color: Colors.green.shade700,
                              ),
                              SizedBox(width: SizeConfig.w(8)),
                              Expanded(
                                child: Text(
                                  "Repeat Customers",
                                  style: TextStyle(
                                    fontSize: SizeConfig.w(14),
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.h(8)),
                          Text(
                            "156",
                            style: TextStyle(
                              fontSize: SizeConfig.w(20),
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            "↗ +8%",
                            style: TextStyle(
                              fontSize: SizeConfig.w(12),
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(16)),
            Text(
              "Customer Distribution",
              style: TextStyle(
                fontSize: SizeConfig.w(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: SizeConfig.h(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New vs Repeat",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "13% : 87%",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(4)),
            LinearProgressIndicator(
              value: 0.13,
              // 13% for new, so remaining is repeat
              backgroundColor: Colors.green.shade700,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade200),
              minHeight: SizeConfig.h(10),
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: SizeConfig.h(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Repeat Rate",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  "68%",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleWithMrpAndStockCard extends StatelessWidget {
  final ArticleController articleController = Get.find<ArticleController>();
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  ArticleWithMrpAndStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildArticleWithMrpAndStockCard();
  }

  Widget _buildArticleWithMrpAndStockCard() {
    return Obx(() {
      if (articleController.isLoading.value) return _buildLoadingCard();

      // Filter articles based on search query
      final allArticles = articleController.articles
          .where(
            (article) =>
                article.articleNo?.toLowerCase().contains(
                  _searchQuery.value.toLowerCase(),
                ) ??
                false ||
                    article.category!.toLowerCase().contains(
                      _searchQuery.value.toLowerCase(),
                    ) ??
                false,
          )
          .toList();

      // Limit to 10 articles for display
      final displayArticles = allArticles.take(5).toList();

      if (allArticles.isEmpty && _searchQuery.value.isEmpty) {
        return _buildEmptyCard("No articles available.");
      }
      if (allArticles.isEmpty) {
        return _buildEmptyCard("No articles match your search.");
      }

      // Calculate total price and total stock for all filtered articles
      final totalPrice = articleController.articles.fold<double>(
        0.0,
        (sum, article) => sum + (article.itemMRP ?? 0.0),
      );
      final totalStock = articleController.articles.fold<int>(
        0,
        (sum, article) => sum + (article.stockQty ?? 0),
      );

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  // Icon(Icons.search, size: SizeConfig.w(20)),
                  Text(
                    "Articles with MRP and Stock",
                    style: AppTextStyles.subheadlineText(),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(12)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  spacing: SizeConfig.w(10),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      height: 60,
                      width: SizeConfig.w(160),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "₹${NumberFormat("#,##,##").format(totalPrice)}",
                              style: AppTextStyles.subheadlineText(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total Price",
                              style: AppTextStyles.captionText(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      height: 60,
                      width: SizeConfig.w(155),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              NumberFormat("#,##,##").format(totalStock),
                              style: AppTextStyles.subheadlineText(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Total Stock",
                              style: AppTextStyles.captionText(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Article ID or Category',
                    prefixIcon: Icon(Icons.search, size: SizeConfig.w(16)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: SizeConfig.h(3),
                      horizontal: SizeConfig.w(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle: AppTextStyles.bodyText(),
                  ),
                  style: AppTextStyles.bodyText(),
                  onChanged: (value) {
                    _searchQuery.value = value;
                  },
                ),
              ),
              SizedBox(height: SizeConfig.h(12)),
              // Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: SizeConfig.w(300)),
                  child: DataTable(
                    columnSpacing: SizeConfig.w(10),
                    dataRowHeight: SizeConfig.h(60),
                    headingRowHeight: SizeConfig.h(40),
                    horizontalMargin: SizeConfig.w(6),
                    columns: [
                      _buildTableHeader("Article ID", flex: 1),
                      _buildTableHeader("Category", flex: 2),
                      _buildTableHeader("Price", flex: 1),
                      _buildTableHeader("Stock", flex: 1),
                    ],
                    rows: displayArticles
                        .map(
                          (article) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  article.articleNo ?? 'N/A',
                                  style: AppTextStyles.bodyText(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DataCell(
                                Text(
                                  article.category ?? 'N/A',
                                  style: AppTextStyles.bodyText(
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DataCell(
                                Text(
                                  "₹${NumberFormat("#,##,##").format(article.itemMRP)}",
                                  style: AppTextStyles.bodyText(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${article.stockQty ?? 0}",
                                  style: AppTextStyles.bodyText(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              // Total Price and Stock
              SizedBox(height: SizeConfig.h(12)),
            ],
          ),
        ),
      );
    });
  }

  DataColumn _buildTableHeader(String text, {int flex = 1}) {
    return DataColumn(
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: AppTextStyles.subheadlineText(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(5)),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(12)),
        child: Center(
          child: Text(errorMessage, style: AppTextStyles.bodyText()),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(12)),
        child: Center(child: Text(message, style: AppTextStyles.bodyText())),
      ),
    );
  }
}

class RegionalSalesTrendsCard extends StatelessWidget {
  const RegionalSalesTrendsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeeklySalesTrendController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      // else if (controller.errorMessage.value != null) {
      //   return Center(
      //     child: Text(
      //       "Error: ${controller.errorMessage.value}",
      //       style: const TextStyle(color: Colors.red),
      //     ),
      //   );
      // } else if (controller.data.value == null) {
      //   return const Center(child: Text("No data available"));
      // }

      final data = controller.data.value?.data!;
      final thisWeek = data?.thisWeek
          .map((e) => e.sales / 100000.0)
          .toList(); // Convert to Lakhs
      final lastWeek = data?.lastWeek
          .map((e) => e.sales / 100000.0)
          .toList(); // Convert to Lakhs
      final target = List<double>.filled(
        7,
        data!.summary.thisWeekAverage / 100000.0,
      );

      final growthPercent =
          ((data.summary.thisWeekTotal - data.summary.lastWeekTotal) /
                  data.summary.lastWeekTotal *
                  100)
              .toStringAsFixed(1);

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.green,
                        size: SizeConfig.w(20),
                      ),
                      SizedBox(width: SizeConfig.w(8)),
                      Text(
                        "Regional Sales Trends",
                        style: AppTextStyles.subheadlineText(),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(10),
                      vertical: SizeConfig.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "7 Days",
                      style: AppTextStyles.captionText(color: Colors.black87),
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.h(16)),

              /// Line Chart
              SizedBox(
                height: SizeConfig.h(350),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, horizontalInterval: 5),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 10,
                          reservedSize: SizeConfig.w(40),
                          getTitlesWidget: (value, _) => Text(
                            "₹${value.toInt()}L",
                            style: AppTextStyles.captionText(),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            if (value.toInt() < days.length) {
                              return Text(
                                days[value.toInt()],
                                style: AppTextStyles.captionText(),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      /// This Week
                      LineChartBarData(
                        spots: List.generate(
                          thisWeek!.length,
                          (i) => FlSpot(i.toDouble(), thisWeek[i]),
                        ),
                        isCurved: true,
                        barWidth: 3,
                        color: Colors.green,
                        dotData: FlDotData(show: true),
                      ),

                      /// Last Week
                      LineChartBarData(
                        spots: List.generate(
                          lastWeek!.length,
                          (i) => FlSpot(i.toDouble(), lastWeek[i]),
                        ),
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.grey[600],
                        dashArray: [6, 4],
                        dotData: FlDotData(show: true),
                      ),

                      /// Target Line
                      LineChartBarData(
                        spots: List.generate(
                          target.length,
                          (i) => FlSpot(i.toDouble(), target[i]),
                        ),
                        isCurved: false,
                        barWidth: 2,
                        color: Colors.green.shade400,
                        dashArray: [4, 4],
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.h(12)),

              /// Legends
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend(Colors.green, "This Week"),
                  SizedBox(width: SizeConfig.w(12)),
                  _buildLegend(Colors.grey, "Last Week"),
                  SizedBox(width: SizeConfig.w(12)),
                  _buildLegend(Colors.green.shade400, "Target", dashed: true),
                ],
              ),

              SizedBox(height: SizeConfig.h(16)),

              /// Footer stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBox(
                    "₹${(data.summary.thisWeekAverage / 100000).toStringAsFixed(2)}L",
                    "Avg This Week",
                    Colors.green.shade50,
                    Colors.green,
                  ),
                  _buildStatBox(
                    "₹${(data.summary.lastWeekAverage / 100000).toStringAsFixed(2)}L",
                    "Avg Last Week",
                    Colors.grey.shade200,
                    Colors.black,
                  ),
                  _buildStatBox(
                    "${double.parse(growthPercent) >= 0 ? '+' : ''}$growthPercent%",
                    "Growth",
                    double.parse(growthPercent) >= 0
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    double.parse(growthPercent) >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLegend(Color color, String label, {bool dashed = false}) {
    return Row(
      children: [
        Container(
          width: SizeConfig.w(16),
          height: SizeConfig.h(2),
          decoration: BoxDecoration(
            color: dashed ? Colors.transparent : color,
            border: dashed ? Border.all(color: color, width: 1) : null,
          ),
        ),
        SizedBox(width: SizeConfig.w(4)),
        Text(label, style: AppTextStyles.captionText()),
      ],
    );
  }

  Widget _buildStatBox(
    String value,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(16),
        vertical: SizeConfig.h(12),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.bodyText(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: SizeConfig.h(4)),
          Text(label, style: AppTextStyles.captionText(color: Colors.black54)),
        ],
      ),
    );
  }
}
