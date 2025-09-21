import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/BranchManagerSalesVsPromiseController.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/categoryWiseSalesController.dart';
import 'package:mbindiamy/controllers/total_sales_controller.dart'
    show TotalSalesController;
import 'package:mbindiamy/widget/appbar_widget.dart';

import '../../../controllers/branch_manager_controller/sales_comparison_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/promise_actual_controller.dart';
import '../../../controllers/reporting_controller.dart';
import '../../../controllers/subordinates_sales_vs_promise_controller.dart';
import '../../../controllers/top_articles_controller.dart';

// import '../../../controllers/promise_actual_controller.dart';
import '../../../model/subordinates_sales_vs_promise_model.dart';
import '../../../model/top_artical_model.dart' as TopArticleData;
import '../../../widget/navigator_widget.dart';
import 'package:get/get.dart';
import '../../../controllers/ArticleWithMrpAndStockController.dart';
import '../../../model/ArticlesWithMrpAndStock_model.dart'
    as ArticleMrpStockData;

// Utility class for responsive sizing
class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late bool isMobile;
  static late bool isTablet;
  static late bool isDesktop;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1024;
    isDesktop = screenWidth >= 1024;
  }

  static double w(double width) => screenWidth * (width / 375);

  static double h(double height) => screenHeight * (height / 812);
}

class BranchManagerDashboard extends StatefulWidget {
  const BranchManagerDashboard({super.key});

  @override
  State<BranchManagerDashboard> createState() => _BranchManagerDashboardState();
}

class _BranchManagerDashboardState extends State<BranchManagerDashboard> {
  int currentSet = 0; // For Promise vs Actual pagination
  int currentIndex = 0; // For Top Articles pagination
  final PageController _pageController = PageController();
  final ScrollController _mainScrollController =
      ScrollController(); // Added for main scrollbar
  final LoginController loginController = Get.find<LoginController>();
  final ReportingManagerController reportingController =
      Get.find<ReportingManagerController>();
  final TotalSalesController totalSalesController =
      Get.find<TotalSalesController>();
  final SalesComparisonController salesComparisonController =
      Get.find<SalesComparisonController>();

  final CategoryWiseSalesController categoryWiseSalesController =
      Get.find<CategoryWiseSalesController>();
  final TopArticlesController topArticlesController =
      Get.find<TopArticlesController>();
  final BranchManagerSalesVsPromiseController
  branchManagerSalesVsPromiseController =
      Get.find<BranchManagerSalesVsPromiseController>();
  final SubordinatesSalesVsPromiseController
  subordinatesSalesVsPromiseController = Get.find();
  final PromiseActualController promiseController =
      Get.find<PromiseActualController>();

  // final PromiseActualController promiseController =
  //     Get.find<PromiseActualController>();
  final ArticleController articleController = Get.find<ArticleController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      print("start");
      await Future.wait([
        reportingController.getReportingManager().catchError((e) {
          debugPrint("Reporting error: $e");
        }),
        salesComparisonController.fetchTodaysSales().catchError((e) {
          debugPrint("Today's Sales error: $e");
        }),
        salesComparisonController.fetchYesterdaySales().catchError((e) {
          debugPrint("Yesterday's Sales error: $e");
        }),
        categoryWiseSalesController.fetchCategoryWiseSales().catchError((e) {
          debugPrint("Category Wise Sales error: $e");
        }),
        totalSalesController.fetchTodaysSales().catchError((e) {
          debugPrint("Total Sales error: $e");
        }),
        topArticlesController.loadTopArticles().catchError((e) {
          debugPrint("loadTopArticles error");
        }),
        branchManagerSalesVsPromiseController
            .fetchSalesVsPromiseData()
            .catchError((e) {
              debugPrint("fetchSalesVsPromiseData error");
            }),
        subordinatesSalesVsPromiseController
            .fetchSubordinatesSalesVsPromise()
            .catchError((e) {
              debugPrint("fetchSubordinatesSalesVsPromise error");
            }),
        promiseController.loadPromiseActualData().catchError((e) {
          debugPrint("loadPromiseActualData error");
        }),
        articleController.fetchArticles().catchError((e) {
          debugPrint("ArticleController error: $e");
        }),

        // promiseController.loadPromiseActualData().catchError((e) {
        //   debugPrint("PromiseActualController error: $e");
        // }),
      ]);
      print("end");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dashboard data: $e')),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mainScrollController.dispose(); // Dispose main scroll controller
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

  late final loginResponse = loginController.loginResponse.value;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final horizontalPadding = SizeConfig.isDesktop
        ? SizeConfig.w(60)
        : SizeConfig.isTablet
        ? SizeConfig.w(40)
        : SizeConfig.w(12);
    final loginResponse = loginController.loginResponse.value;
    final user = loginResponse?.data?.user;
    String userId = '';

    if (user != null) {
      final userType = user.userType?.toLowerCase();
      final isAllBranches = user.isAllBranches;
      final selectedBranchAliases = user.selectedBranchAliases;

      if (userType == 'head' || isAllBranches == true) {
        userId = 'All Branches';
      } else if (selectedBranchAliases.isNotEmpty) {
        // Join all branch aliases into a single string
        userId = selectedBranchAliases.join(', ');
      }
    }

    // Get promise vs actual data from PromiseActualController
    final allDailyValues = (promiseController.data.value?.data.locations ?? [])
        .expand((location) => location.dailyValues)
        .map(
          (dailyValue) => {
            "date": dailyValue.date.toString(),
            "day": dailyValue.date.day,
            "promise": dailyValue.promise,
            "actual": dailyValue.actual,
          },
        )
        .toList();

    // Get phase data from SalesByPhaseController
    // final phaseData = {
    //   "currentPhase":
    //       salesPhaseController.salesData.value?.data.currentPhase ??
    //       "Loading...",
    //   "phase1": (salesPhaseController.salesData.value?.data.phase1 ?? 0)
    //       .toDouble(),
    //   "phase2": (salesPhaseController.salesData.value?.data.phase2 ?? 0)
    //       .toDouble(),
    //   "phase3": (salesPhaseController.salesData.value?.data.phase3 ?? 0)
    //       .toDouble(),
    //   "phase4": (salesPhaseController.salesData.value?.data.phase4 ?? 0)
    //       .toDouble(),
    // };
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // Filter and sort daily values with proper error handling
    var filteredDailyValues = allDailyValues.where((dv) {
      try {
        final dateString = dv["date"] as String;
        if (dateString.isEmpty) return false;
        final dt = DateFormat(
          'd/M',
        ).parse(dateString); // Use specific format for parsing
        return dt.year == currentYear && dt.month == currentMonth;
      } catch (e) {
        return false;
      }
    }).toList();

    final int itemsPerPage = 4;
    final totalSetsLocal = (filteredDailyValues.length / itemsPerPage).ceil();

    List<Map<String, dynamic>> currentData = [];
    String dateRange = "";
    if (filteredDailyValues.isNotEmpty) {
      final startIndex = currentSet * itemsPerPage;
      final endIndex = (startIndex + itemsPerPage < filteredDailyValues.length)
          ? startIndex + itemsPerPage
          : filteredDailyValues.length;

      currentData = filteredDailyValues.sublist(startIndex, endIndex).map((dv) {
        try {
          final dateString = dv["date"] as String;
          final dt = DateFormat(
            'd/M',
          ).parse(dateString); // Use specific format for parsing
          final day = [
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat',
          ][dt.weekday % 7];
          final dateStr = "${dt.day}/${dt.month}";
          final promise = (dv["promise"] as num).toDouble();
          final actual = (dv["actual"] as num).toDouble();
          final percent = promise > 0 ? ((actual / promise) * 100).round() : 0;
          return {
            "day": day,
            "date": dateStr,
            "promise": promise.toStringAsFixed(2),
            "actual": actual.toStringAsFixed(2),
            "percent": percent,
          };
        } catch (e) {
          return {
            "day": 'N/A',
            "date": 'N/A',
            "promise": '0.00',
            "actual": '0.00',
            "percent": 0,
          };
        }
      }).toList();

      if (currentData.isNotEmpty) {
        dateRange =
            "${currentData.first['date']} - ${currentData.last['date']}";
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: NavigationDrawerWidget(),
      appBar: CustomAppBar(
        userName: loginResponse?.data?.user.name ?? "Loading...",
        userId: userId,
        onNotificationPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications clicked!')),
          );
        },
      ),

      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: SizeConfig.h(16),
          ),
          child: Obx(() {
            if (!salesComparisonController.hasConnection.value) {
              return Center(
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
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(SizeConfig.w(10)),
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.h(4)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    return Text(
                      "Reporting To: ${reportingController.manager.value ?? "Loading..."}",
                      style: TextStyle(
                        fontSize: SizeConfig.w(14),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
                // Today's Revenue Card
                Wrap(
                  spacing: SizeConfig.w(6),
                  runSpacing: SizeConfig.h(6),
                  children: [
                    Obx(() {
                      return SizedBox(
                        width: SizeConfig.isDesktop
                            ? SizeConfig.w(340)
                            : SizeConfig.isTablet
                            ? (SizeConfig.screenWidth / 2) - SizeConfig.w(30)
                            : double.infinity,
                        child: _infoCard(
                          "Todays's Revenue (Today)",
                          "₹${totalSalesController.salesData.value?.totalNetAmount ?? "0.0"}",
                          Icons.currency_rupee,
                          Colors.green,
                          1,
                        ),
                      );
                    }),
                    Obx(() {
                      return SizedBox(
                        width: SizeConfig.isDesktop
                            ? SizeConfig.w(340)
                            : SizeConfig.isTablet
                            ? (SizeConfig.screenWidth / 2) - SizeConfig.w(30)
                            : double.infinity,
                        child: _infoCard(
                          "Unit Sold (Today)",
                          "${totalSalesController.salesData.value?.totalNetSlsQty ?? 0} Qty",
                          Icons.production_quantity_limits,
                          Colors.blue,
                          1,
                        ),
                      );
                    }),
                    Obx(() {
                      final incentiveValue =
                          totalSalesController.myIncentive.value ?? 0.0;
                      return SizedBox(
                        width: SizeConfig.isDesktop
                            ? SizeConfig.w(340)
                            : SizeConfig.isTablet
                            ? (SizeConfig.screenWidth / 2) - SizeConfig.w(30)
                            : double.infinity,
                        child: _infoCard(
                          "My Incentive (Today)",
                          incentiveValue > 0
                              ? "₹${incentiveValue.toStringAsFixed(2)}"
                              : "₹0",
                          Icons.currency_rupee,
                          incentiveValue > 0 ? Colors.purple : Colors.grey,
                          1,
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: SizeConfig.h(16)),
                // Sales Comparison Card
                _buildSalesComparisonCard(),
                SizedBox(height: SizeConfig.h(16)),

                // Category-wise Sales Card
                Obx(() {
                  final salesData = categoryWiseSalesController.salesData.value;

                  if (categoryWiseSalesController.isLoading.value) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else if (categoryWiseSalesController.errorMessage.value !=
                      null) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "Error: ${categoryWiseSalesController.errorMessage.value}",
                          ),
                        ),
                      ),
                    );
                  } else if (salesData == null ||
                      salesData.data?.categorySales == null ||
                      salesData.data!.categorySales!.isEmpty) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = constraints.maxWidth;

                        final bool isMobile = screenWidth < 600;
                        final bool isTablet =
                            screenWidth >= 600 && screenWidth < 1024;

                        final double titleFontSize = isMobile
                            ? 16
                            : isTablet
                            ? 18
                            : 20;
                        final double textFontSize = isMobile
                            ? 14
                            : isTablet
                            ? 16
                            : 18;
                        final double smallTextSize = isMobile ? 12 : 14;
                        final double iconSize = isMobile ? 18 : 22;
                        final double padding = isMobile ? 12 : 20;

                        return Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bar_chart,
                                        size: iconSize,
                                        color: Colors.grey[700],
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Category-wise Sales",
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
                                      style: TextStyle(
                                        fontSize: smallTextSize,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 16),

                              /// Net Sales Qty
                              Row(
                                children: [
                                  Icon(
                                    Icons.folder,
                                    size: iconSize - 2,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Total Net Sales Quantity: ${NumberFormat('#,##,###').format(salesData.data?.totalNetSlsQty ?? 0)} Qty",
                                    style: TextStyle(
                                      fontSize: textFontSize,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              /// Category List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  final categoryTotalAmount =
                                      category.totalAmount ?? 0;
                                  final percentage = totalSalesAmount > 0
                                      ? (categoryTotalAmount /
                                                totalSalesAmount) *
                                            100
                                      : 0.0;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              category.category as String,
                                              style: TextStyle(
                                                fontSize: textFontSize,
                                              ),
                                            ),
                                            Text(
                                              "${percentage.toStringAsFixed(1)}% ₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                                              style: TextStyle(
                                                fontSize: textFontSize,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        LinearProgressIndicator(
                                          value: percentage / 100,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.green.shade700,
                                              ),
                                          minHeight: isMobile ? 6 : 8,
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                  // return Card(
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(SizeConfig.w(16)),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Icon(
                  //                   Icons.bar_chart,
                  //                   size: SizeConfig.w(20),
                  //                   color: Colors.grey[700],
                  //                 ),
                  //                 SizedBox(width: SizeConfig.w(8)),
                  //                 Text(
                  //                   "Category-wise Sales",
                  //                   style: TextStyle(
                  //                     fontSize: SizeConfig.w(16),
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Container(
                  //               padding: EdgeInsets.symmetric(
                  //                 horizontal: SizeConfig.w(8),
                  //                 vertical: SizeConfig.h(4),
                  //               ),
                  //               decoration: BoxDecoration(
                  //                 color: Colors.grey[200],
                  //                 borderRadius: BorderRadius.circular(8),
                  //               ),
                  //               child: Text(
                  //                 "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
                  //                 style: TextStyle(
                  //                   fontSize: SizeConfig.w(12),
                  //                   color: Colors.grey[700],
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: SizeConfig.h(16)),
                  //         Row(
                  //           children: [
                  //             Icon(Icons.folder, size: SizeConfig.w(16), color: Colors.grey[600]),
                  //             SizedBox(width: SizeConfig.w(8)),
                  //             Text(
                  //               "Total Net Sales Quantity: ${NumberFormat('#,##,###').format(salesData.data?.totalNetSlsQty ?? 0)} Qty",
                  //               style: TextStyle(
                  //                 fontSize: SizeConfig.w(14),
                  //                 color: Colors.grey[800],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: SizeConfig.h(12)),
                  //         ListView.builder(
                  //           shrinkWrap: true,
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           itemCount: categories.length,
                  //           itemBuilder: (context, index) {
                  //             final category = categories[index];
                  //             final categoryTotalAmount = category.totalAmount ?? 0;
                  //             final percentage = totalSalesAmount > 0
                  //                 ? (categoryTotalAmount / totalSalesAmount) * 100
                  //                 : 0.0;
                  //             return Padding(
                  //               padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Text(
                  //                         category.category as String,
                  //                         style: TextStyle(fontSize: SizeConfig.w(14)),
                  //                       ),
                  //                       Text(
                  //                         "${percentage.toStringAsFixed(1)}% ₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                  //                         style: TextStyle(
                  //                           fontSize: SizeConfig.w(14),
                  //                           fontWeight: FontWeight.w600,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(height: SizeConfig.h(4)),
                  //                   LinearProgressIndicator(
                  //                     value: percentage / 100,
                  //                     backgroundColor: Colors.grey[200],
                  //                     valueColor: AlwaysStoppedAnimation<Color>(
                  //                       Colors.green.shade700,
                  //                     ),
                  //                     minHeight: SizeConfig.h(6),
                  //                     borderRadius: BorderRadius.circular(3),
                  //                   ),
                  //                 ],
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                }),
                SizedBox(height: SizeConfig.h(16)),
                highestSellingProduct(context),
                SizedBox(height: SizeConfig.h(16)),
                // Card(
                //   color: Colors.white,
                //   child: Column(
                //     children: [
                //       // SizedBox(height: SizeConfig.h(16)),
                //       // SizedBox(height: 20),
                //       // SalesLineChart(),
                //       // SizedBox(height: SizeConfig.h(16)),
                //       SalesVSPromiseInfoRow(),
                //       SizedBox(height: SizeConfig.h(16)),
                //     ],
                //   ),
                // ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(SizeConfig.w(10)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Promise vs Actual",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.w(14),
                            ),
                          ),
                          if (filteredDailyValues.isNotEmpty)
                            Row(
                              children: [
                                IconButton(
                                  onPressed: currentSet > 0 ? goPrev : null,
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  dateRange,
                                  style: TextStyle(fontSize: SizeConfig.w(10)),
                                ),
                                IconButton(
                                  onPressed: currentSet < totalSetsLocal - 1
                                      ? goNext
                                      : null,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Obx(() {
                        final list = promiseController.filteredData.toList();
                        return SizedBox(
                          width: double.infinity,
                          // height: SizeConfig.h(200),
                          height: 200,
                          child: list.isEmpty
                              ? Center(
                                  child: Text(
                                    promiseController.isLoading.value
                                        ? "Loading promise vs actual data..."
                                        : "No promise vs actual data for this month.",
                                    style: TextStyle(
                                      fontSize: SizeConfig.w(16),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(
                                    context,
                                  ).copyWith(scrollbars: false),
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.w(10),
                                    ),
                                    itemCount: list.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: SizeConfig.w(10)),
                                    itemBuilder: (context, index) {
                                      final item = list[index];
                                      final percent = item['percent'] as int;
                                      final color = percent >= 100
                                          ? Colors.green
                                          : percent >= 80
                                          ? Colors.orange
                                          : Colors.red;

                                      // Reverse index
                                      final reverseIndex = list.length - index;

                                      return Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: SizeConfig.w(120),
                                          padding: EdgeInsets.all(
                                            SizeConfig.w(6),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: color,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Number + Date
                                              Text(
                                                "$reverseIndex ${item['date']}",
                                                style: TextStyle(
                                                  fontSize: SizeConfig.w(12),
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              // Promise
                                              Column(
                                                children: [
                                                  Text(
                                                    "Promise",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: SizeConfig.w(
                                                        11,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.h(1.2),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      item['promise'] as String,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: SizeConfig.w(
                                                          14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Actual
                                              Column(
                                                children: [
                                                  Text(
                                                    "Actual",
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                      fontSize: SizeConfig.w(
                                                        11,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig.h(1.2),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      item['actual'] as String,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: SizeConfig.w(
                                                          14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Percent Indicator
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: SizeConfig.h(3.2),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(
                                                    0.15,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "$percent%",
                                                    style: TextStyle(
                                                      color: color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig.w(
                                                        14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.h(16)),
                _buildSubordinatesSalesVsPromiseCard(),
                SizedBox(height: SizeConfig.h(16)),
                _buildArticleWithMrpAndStockCard(),
              ],
            );
          }),
        ),
      ),
    );
  }

  //  Highest Selling Products
  Widget highestSellingProduct(BuildContext context) {
    final TopArticlesController topArticlesController =
        Get.find<TopArticlesController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

        final double titleFontSize = isMobile
            ? SizeConfig.w(14)
            : isTablet
            ? SizeConfig.w(18)
            : SizeConfig.w(22);

        final double textFontSize = isMobile
            ? SizeConfig.w(12)
            : isTablet
            ? SizeConfig.w(14)
            : SizeConfig.w(16);

        final double imageSize = isMobile
            ? SizeConfig.w(90)
            : isTablet
            ? SizeConfig.w(110)
            : SizeConfig.w(140);

        final double paddingValue = isMobile
            ? SizeConfig.w(10)
            : isTablet
            ? SizeConfig.w(16)
            : SizeConfig.w(20);

        final double badgeWidth = isMobile
            ? SizeConfig.w(50)
            : isTablet
            ? SizeConfig.w(60)
            : SizeConfig.w(70);

        final double cardHeight = isMobile
            ? SizeConfig.h(150)
            : isTablet
            ? SizeConfig.h(170)
            : SizeConfig.h(200);

        return Obx(() {
          final topArticles = topArticlesController.data.value?.data ?? [];
          return Container(
            padding: EdgeInsets.all(paddingValue),
            margin: EdgeInsets.symmetric(vertical: SizeConfig.h(10)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "(Last 7 Days)",
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (topArticles.isNotEmpty)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => showPrevious(topArticles.length),
                            icon: const Icon(Icons.arrow_back_ios),
                            iconSize: isMobile
                                ? SizeConfig.w(18)
                                : SizeConfig.w(22),
                            color: currentIndex > 0
                                ? Colors.black
                                : Colors.grey,
                          ),
                          IconButton(
                            onPressed: () => showNext(topArticles.length),
                            icon: const Icon(Icons.arrow_forward_ios),
                            iconSize: isMobile
                                ? SizeConfig.w(18)
                                : SizeConfig.w(22),
                            color: currentIndex < topArticles.length - 1
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: isMobile ? SizeConfig.h(8) : SizeConfig.h(12)),

                // Product Cards
                SizedBox(
                  height: cardHeight,
                  child: topArticles.isEmpty
                      ? Center(
                          child: Text(
                            topArticlesController.isLoading.value
                                ? "Loading top articles..."
                                : "No top articles data available",
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: topArticles.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final article = topArticles[index];
                            return _buildProductCard(
                              context: context,
                              article: article,
                              isMobile: isMobile,
                              imageSize: imageSize,
                              paddingValue: paddingValue,
                              titleFontSize: titleFontSize,
                              textFontSize: textFontSize,
                              badgeWidth: badgeWidth,
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required TopArticleData.ArticleData article,
    required bool isMobile,
    required double imageSize,
    required double paddingValue,
    required double titleFontSize,
    required double textFontSize,
    required double badgeWidth,
  }) {
    // Debugging - remove after verification
    // debugPrint('Full article data: ${article.toString()}');

    // GP Value Extraction
    final gpValue = article.gp;
    final formattedGp = gpValue.toStringAsFixed(2);

    // debugPrint('GP value extracted: $gpValue'); // Verify extraction

    return Container(
      padding: EdgeInsets.all(paddingValue / 1.5),
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 0 : SizeConfig.w(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: article.img.isNotEmpty
                ? _buildNetworkImage(article.img, imageSize)
                : _buildPlaceholderIcon(),
          ),

          SizedBox(width: isMobile ? SizeConfig.w(8) : SizeConfig.w(16)),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Article Number
                Text(
                  article.articleNo,
                  maxLines: 3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    height: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: isMobile ? SizeConfig.h(6) : SizeConfig.h(8)),

                // Price and Quantity Row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount : ₹${article.netAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Qty: ${article.netQuantity}",
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? SizeConfig.h(6) : SizeConfig.h(10)),
                // GP Badge - Will definitely show if data exists
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(8),
                    vertical: SizeConfig.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: _getGpColor(gpValue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(minWidth: badgeWidth),
                  child: Text(
                    "GP: $formattedGp%", // Using the formatted value
                    style: TextStyle(
                      color: _getGpTextColor(gpValue),
                      fontSize: textFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Trending Icon
          Padding(
            padding: EdgeInsets.only(
              left: SizeConfig.w(8),
              top: SizeConfig.h(4),
            ),
            child: Icon(
              Icons.trending_up,
              color: _getTrendingColor(gpValue),
              size: isMobile ? 24 : 28,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to determine GP badge color
  Color _getGpColor(double gpValue) {
    return Colors.green.withOpacity(0.2);
  }

  // Helper function to determine GP text color
  Color _getGpTextColor(double gpValue) {
    return Colors.green.shade800;
  }

  // Helper function to determine trending icon color
  Color _getTrendingColor(double gpValue) {
    return Colors.green;
  }

  Widget _buildNetworkImage(String imageUrl, double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
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

  Widget _infoCard(
    String title,
    String value,
    IconData icon,
    Color iconBgColor,
    double elevation,
  ) {
    return Card(
      elevation: elevation,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: SizeConfig.h(4), right: 0),
      child: Container(
        constraints: BoxConstraints(minHeight: SizeConfig.h(120)),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(14),
          vertical: SizeConfig.h(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.w(13),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(2.8)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: SizeConfig.w(14),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.w(12)),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: SizeConfig.w(19)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesComparisonCard() {
    return Card(
      color: Colors.white,
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
                      Icons.calendar_today,
                      size: SizeConfig.w(20),
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Sales Comparison",
                      style: TextStyle(
                        fontSize: SizeConfig.w(16),
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
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     "Limited Access",
                //     style: TextStyle(
                //       fontSize: SizeConfig.w(12),
                //       fontWeight: FontWeight.w500,
                //       color: Colors.grey[700],
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: SizeConfig.h(20)),
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

              Color trendColor = Colors.grey[700]!;
              IconData trendIcon = Icons.remove;
              String trendText = "";

              if (difference > 0) {
                trendColor = Colors.green;
                trendIcon = Icons.trending_up;
                trendText =
                    "+${percentageChange.toStringAsFixed(1)}% vs yesterday (₹${difference.toStringAsFixed(0)}) ";
              } else if (difference < 0) {
                trendColor = Colors.red;
                trendIcon = Icons.trending_down;
                trendText =
                    "${percentageChange.toStringAsFixed(1)}% vs yesterday (₹${difference.abs().toStringAsFixed(0)}) ";
              } else {
                trendColor = Colors.orange;
                trendIcon = Icons.show_chart;
                trendText = "No change vs yesterday";
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          "Today's Sales",
                          "₹${todaySales.toStringAsFixed(0)}",
                          Icons.currency_rupee,
                          Colors.blue,
                          0,
                        ),
                      ),
                      SizedBox(width: SizeConfig.w(16)),
                      Expanded(
                        child: _infoCard(
                          "Yesterday's Sales",
                          "₹${yesterdaySales.toStringAsFixed(0)}",
                          Icons.currency_rupee,
                          Colors.orange,
                          0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        trendIcon,
                        color: trendColor,
                        size: SizeConfig.w(20),
                      ),
                      SizedBox(width: SizeConfig.w(8)),
                      Text(
                        trendText,
                        style: TextStyle(
                          color: trendColor,
                          fontSize: SizeConfig.w(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSubordinatesSalesVsPromiseCard() {
    return Obx(() {
      if (subordinatesSalesVsPromiseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (subordinatesSalesVsPromiseController.errorMessage.value !=
          null) {
        return Center(
          child: Text(
            "Error: ${subordinatesSalesVsPromiseController.errorMessage.value}",
          ),
        );
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

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subordinates Sales vs Promise",
                style: TextStyle(
                  fontSize: SizeConfig.w(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.h(16)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subordinates.length,
                itemBuilder: (context, index) {
                  final subordinate = subordinates[index];
                  return _buildSubordinateTile(subordinate);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSubordinateTile(Subordinate subordinate) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subordinate.name ?? 'N/A',
                  style: TextStyle(
                    fontSize: SizeConfig.w(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: SizeConfig.h(4)),
                Text(
                  "Email: ${subordinate.email ?? 'N/A'}",
                  style: TextStyle(
                    fontSize: SizeConfig.w(12),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: SizeConfig.h(8)),
                Text(
                  "Total Sales: ₹${NumberFormat('#,##,###').format(totalSales)}",
                  style: TextStyle(fontSize: SizeConfig.w(14)),
                ),
                Text(
                  "Total Promise: ₹${NumberFormat('#,##,###').format(totalPromise)}",
                  style: TextStyle(fontSize: SizeConfig.w(14)),
                ),
                SizedBox(height: SizeConfig.h(8)),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: SizeConfig.h(8),
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: SizeConfig.h(4)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${percentage.toStringAsFixed(1)}% achieved",
                    style: TextStyle(
                      fontSize: SizeConfig.w(12),
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Branches:",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subordinate.branches?.length ?? 0,
                  itemBuilder: (context, idx) {
                    final branch = subordinate.branches![idx];
                    final num branchPromise = branch.promised ?? 0;
                    final num branchActualSales = branch.actualSales ?? 0;
                    final double branchPercentage = branchPromise > 0
                        ? (branchActualSales / branchPromise) * 100
                        : 0.0;
                    Color branchProgressColor = Colors.grey;
                    if (branchPercentage >= 80) {
                      branchProgressColor = Colors.green;
                    } else if (branchPercentage >= 50) {
                      branchProgressColor = Colors.orange;
                    } else {
                      branchProgressColor = Colors.red;
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.w(16),
                        top: SizeConfig.h(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${branch.branchAlias}: ₹${NumberFormat('#,##,###').format(branchActualSales)} / ₹${NumberFormat('#,##,###').format(branchPromise)}",
                            style: TextStyle(fontSize: SizeConfig.w(12)),
                          ),
                          LinearProgressIndicator(
                            value: branchPercentage / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              branchProgressColor,
                            ),
                            minHeight: SizeConfig.h(6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${branchPercentage.toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: SizeConfig.w(10),
                                color: branchProgressColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(height: SizeConfig.h(24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleWithMrpAndStockCard() {
    return Obx(() {
      // Loading state
      if (articleController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Error state
      if (articleController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text("Error: ${articleController.errorMessage.value}"),
        );
      }

      final articles = articleController.articles.take(5).toList();
      if (articles.isEmpty) {
        return const Center(child: Text("No articles available."));
      }

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final bool isMobile = screenWidth < 600;
            final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
            final double titleFontSize = isMobile
                ? 16
                : isTablet
                ? 18
                : 20;
            final double smallTextSize = isMobile ? 12 : 14;
            final double padding = isMobile ? 12 : 20;

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Articles with MRP and Stock",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(16)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: screenWidth),
                      child: DataTable(
                        columnSpacing: SizeConfig.w(20),
                        dataRowHeight: SizeConfig.h(60),
                        headingRowHeight: SizeConfig.h(50),
                        horizontalMargin: padding / 2,
                        columns: [
                          // ArticleNo
                          _buildTableHeader("Article ID", smallTextSize),

                          _buildTableHeader("Category", smallTextSize),
                          _buildTableHeader("Price", smallTextSize),
                          _buildTableHeader("Stock", smallTextSize),

                        ],
                        rows: articles.map((article) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  article.articleNo ?? 'N/A',
                                  style: TextStyle(fontSize: smallTextSize),
                                ),
                              ),

                              DataCell(
                                Text(
                                  article.category ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "₹${article.itemMRP?.toStringAsFixed(2) ?? '0.00'}",
                                  style: TextStyle(fontSize: smallTextSize),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "${article.stockQty ?? 0}",
                                  style: TextStyle(fontSize: smallTextSize),
                                ),
                              ),


                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  // Helper for table headers
  DataColumn _buildTableHeader(String text, double fontSize) {
    return DataColumn(
      label: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
    );
  }

  // Status widget
  Widget _buildStatusWidget(int stockQty, double fontSize) {
    final status = _getStatus(stockQty);
    return Row(
      children: [
        Icon(status['icon'], color: status['color'], size: fontSize * 1.2),
        SizedBox(width: SizeConfig.w(4)),
        Text(
          status['text'],
          style: TextStyle(color: status['color'], fontSize: fontSize),
        ),
      ],
    );
  }

  Map<String, dynamic> _getStatus(int qty) {
    if (qty > 50) {
      return {
        'color': Colors.green,
        'text': 'In Stock',
        'icon': Icons.check_circle,
      };
    }
    if (qty > 10) {
      return {
        'color': Colors.orange,
        'text': 'Low Stock',
        'icon': Icons.warning,
      };
    }
    return {'color': Colors.red, 'text': 'Critical', 'icon': Icons.error};
  }
}
