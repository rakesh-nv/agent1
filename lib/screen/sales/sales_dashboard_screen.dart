import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/controllers/login_controller.dart';
import 'package:mbindiamy/controllers/promise_actual_controller.dart';
import 'package:mbindiamy/controllers/reporting_controller.dart';
import 'package:mbindiamy/controllers/sales_by_phase_controller.dart';
import 'package:mbindiamy/controllers/total_sales_controller.dart';
import 'package:mbindiamy/controllers/top_articles_controller.dart';
import 'package:mbindiamy/controllers/filter_controller.dart';
import 'package:mbindiamy/widget/appbar_widget.dart';
import 'package:mbindiamy/widget/navigator_widget.dart';
import 'package:mbindiamy/model/top_artical_model.dart';

import '../../controllers/subordinates_sales_vs_promise_controller.dart';
import '../../model/subordinates_sales_vs_promise_model.dart';

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

class SalesAgentDashBoard extends StatefulWidget {
  const SalesAgentDashBoard({super.key});

  @override
  State<SalesAgentDashBoard> createState() => _SalesAgentDashBoardState();
}

class _SalesAgentDashBoardState extends State<SalesAgentDashBoard> {
  int currentSet = 0;
  int currentIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _mainScrollController = ScrollController();

  final LoginController loginController = Get.find<LoginController>();
  final PromiseActualController promiseController = Get.find<PromiseActualController>();
  final ReportingManagerController reportingController = Get.find<ReportingManagerController>();
  final SalesByPhaseController salesPhaseController = Get.find<SalesByPhaseController>();
  final TotalSalesController totalSalesController = Get.find<TotalSalesController>();
  final TopArticlesController topArticlesController = Get.find<TopArticlesController>();
  final FilterController filterController = Get.find<FilterController>();
  final SubordinatesSalesVsPromiseController subordinatesSalesVsPromiseController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      print("Start");
      await Future.wait([
        topArticlesController.loadTopArticles(),
        totalSalesController.fetchTodaysSales(),
        reportingController.getReportingManager(),
        promiseController.loadPromiseActualData(),
        salesPhaseController.loadSalesByPhase(),
        subordinatesSalesVsPromiseController.fetchSubordinatesSalesVsPromise(),
        // filterController.loadFilters(), // uncomment if needed
      ]);
      print("End");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading dashboard data: $e')));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  void showNext(int length) {
    if (currentIndex < length - 1) {
      setState(() {
        currentIndex++;
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
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
        ? SizeConfig.w(60)
        : SizeConfig.isTablet
        ? SizeConfig.w(40)
        : SizeConfig.w(12);

    // Get user data from LoginController
    return Obx(() {
      final userName = loginController.loginResponse.value?.data!.user.name ?? "Loading...";
      // final reportingName = reportingController.manager.value?? "Loading...";
      final reportingName = reportingController.manager.value ?? "Loading...";
      // Get sales data from TotalSalesController
      final totalNetAmount = totalSalesController.salesData.value?.totalNetAmount ?? 0.0;
      final totalNetSlsQty = totalSalesController.salesData.value?.totalNetSlsQty ?? 0;

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
          final dt = DateFormat('d/M').parse(dateString); // Use specific format for parsing
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
            final dt = DateFormat('d/M').parse(dateString); // Use specific format for parsing
            final day = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][dt.weekday % 7];
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
            return {"day": 'N/A', "date": 'N/A', "promise": '0.00', "actual": '0.00', "percent": 0};
          }
        }).toList();

        if (currentData.isNotEmpty) {
          dateRange = "${currentData.first['date']} - ${currentData.last['date']}";
        }
      }

      final loginResponse = loginController.loginResponse.value;
      final user = loginResponse?.data?.user;
      final userId = user == null
          ? ''
          : (user.userType.toLowerCase() == 'head' || user.isAllBranches == true)
          ? 'All Branches'
          : (user.selectedBranchAliases.isNotEmpty
                ? user.selectedBranchAliases.join(', ') // joins all branches as a string
                : '');

      return Scaffold(
        backgroundColor: AppStyle.backgroundColor,
        drawer: NavigationDrawerWidget(),
        appBar: CustomAppBar(
          userName: userName,
          userId: userId.toString(),
          onNotificationPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Notifications clicked!')));
          },
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: SizeConfig.isDesktop ? SizeConfig.w(1100) : double.infinity,
                ),
                child: Scrollbar(
                  controller: _mainScrollController,
                  thumbVisibility: true,
                  thickness: SizeConfig.w(8),
                  radius: const Radius.circular(4.0),
                  child: RefreshIndicator(
                    onRefresh: _loadDashboardData,
                    child: SingleChildScrollView(
                      controller: _mainScrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: SizeConfig.h(16),
                      ),
                      child: Column(
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
                            child: Text(
                              "Reporting : $reportingName",
                              style: TextStyle(
                                fontSize: SizeConfig.w(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.h(4)),
                          Wrap(
                            spacing: SizeConfig.w(6),
                            runSpacing: SizeConfig.h(6),
                            children: [
                              SizedBox(
                                width: SizeConfig.isDesktop
                                    ? SizeConfig.w(340)
                                    : SizeConfig.isTablet
                                    ? (SizeConfig.screenWidth / 2) - SizeConfig.w(30)
                                    : double.infinity,
                                child: _infoCard(
                                  "Total Sales Amount (Today)",
                                  "₹${totalNetAmount.toStringAsFixed(2)}",
                                  Icons.currency_rupee,
                                  Colors.green,
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.isDesktop
                                    ? SizeConfig.w(340)
                                    : SizeConfig.isTablet
                                    ? (SizeConfig.screenWidth / 2) - SizeConfig.w(30)
                                    : double.infinity,
                                child: _infoCard(
                                  "Total Sales Quantity (Today)",
                                  "$totalNetSlsQty Qty",
                                  Icons.production_quantity_limits,
                                  Colors.blue,
                                ),
                              ),
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
                                  ),
                                );
                              }),
                            ],
                          ),

                          SizedBox(height: SizeConfig.h(8)),
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
                                            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                                          ),
                                          Text(
                                            dateRange,
                                            style: TextStyle(fontSize: SizeConfig.w(10)),
                                          ),
                                          IconButton(
                                            onPressed: currentSet < totalSetsLocal - 1
                                                ? goNext
                                                : null,
                                            icon: const Icon(Icons.arrow_forward_ios, size: 18),
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
                                                    padding: EdgeInsets.all(SizeConfig.w(6)),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: color, width: 2),
                                                      borderRadius: BorderRadius.circular(14),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                fontSize: SizeConfig.w(11),
                                                              ),
                                                            ),
                                                            SizedBox(height: SizeConfig.h(1.2)),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text(
                                                                item['promise'] as String,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: SizeConfig.w(14),
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
                                                                fontSize: SizeConfig.w(11),
                                                              ),
                                                            ),
                                                            SizedBox(height: SizeConfig.h(1.2)),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text(
                                                                item['actual'] as String,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: SizeConfig.w(14),
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
                                                            color: color.withOpacity(0.15),
                                                            borderRadius: BorderRadius.circular(14),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "$percent%",
                                                              style: TextStyle(
                                                                color: color,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: SizeConfig.w(14),
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
                          SizedBox(height: SizeConfig.h(4)),
                          highestSellingProduct(context),
                          // SizedBox(height: SizeConfig.h(2)),
                          PhaseTwoInfoWidget(),
                          SizedBox(height: SizeConfig.h(10)),
                          _buildSubordinatesSalesVsPromiseCard(),
                          SizedBox(height: SizeConfig.h(30)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _infoCard(String title, String value, IconData icon, Color iconBgColor) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: SizeConfig.h(4), right: 0),
      child: Container(
        constraints: BoxConstraints(minHeight: SizeConfig.h(120)),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(14), vertical: SizeConfig.h(8)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: SizeConfig.w(13)),
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
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: SizeConfig.w(19)),
            ),
          ],
        ),
      ),
    );
  }

  //  Highest Selling Products
  Widget highestSellingProduct(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final double titleFontSize = isMobile ? SizeConfig.w(12) : SizeConfig.w(20);
    final double textFontSize = isMobile ? SizeConfig.w(12) : SizeConfig.w(16);
    final double imageSize = isMobile ? SizeConfig.w(100) : SizeConfig.w(120);
    final double paddingValue = isMobile ? SizeConfig.w(10) : SizeConfig.w(20);
    final double badgeWidth = isMobile ? SizeConfig.w(50) : SizeConfig.w(70);

    final TopArticlesController topArticlesController = Get.find<TopArticlesController>();
    final double cardHeight = isMobile ? SizeConfig.h(150) : SizeConfig.h(180);

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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text("(Last 7 Days)"),
                    ],
                  ),
                ),
                if (topArticles.isNotEmpty)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showPrevious(topArticles.length);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        iconSize: isMobile ? SizeConfig.w(18) : SizeConfig.w(22),
                        color: currentIndex > 0 ? Colors.black : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () {
                          showNext(topArticles.length);
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                        iconSize: isMobile ? SizeConfig.w(18) : SizeConfig.w(22),
                        color: currentIndex < topArticles.length - 1 ? Colors.black : Colors.grey,
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: isMobile ? SizeConfig.h(8) : SizeConfig.h(12)),
            SizedBox(
              height: cardHeight,
              child: topArticles.isEmpty
                  ? Center(
                      child: Text(
                        topArticlesController.isLoading.value
                            ? "Loading top articles..."
                            : "No top articles data available",
                        style: TextStyle(fontSize: SizeConfig.w(16), color: Colors.grey),
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
  }

  Widget _buildProductCard({
    required BuildContext context,
    required ArticleData article,
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

                SizedBox(height: isMobile ? SizeConfig.h(3) : SizeConfig.h(5)),

                // Price and Quantity Row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount : ₹${article.netAmount.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: textFontSize, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Qty: ${article.netQuantity}",
                      style: TextStyle(fontSize: textFontSize, color: Colors.grey[600]),
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
            padding: EdgeInsets.only(left: SizeConfig.w(8), top: SizeConfig.h(4)),
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
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(size: size),
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

  Widget _buildSubordinatesSalesVsPromiseCard() {
    return Obx(() {
      if (subordinatesSalesVsPromiseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (subordinatesSalesVsPromiseController.errorMessage.value != null) {
        return Center(
          child: Text("Error: ${subordinatesSalesVsPromiseController.errorMessage.value}"),
        );
      } else if (subordinatesSalesVsPromiseController.subordinatesSalesVsPromiseData.value?.data ==
          null) {
        return const SizedBox.shrink(); // show nothing if no data
      }

      final data = subordinatesSalesVsPromiseController.subordinatesSalesVsPromiseData.value!.data!;
      final subordinates = data.subordinates;

      if (subordinates == null || subordinates.isEmpty) {
        return const SizedBox.shrink(); // 🔹 don't show anything
      }

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: SizeConfig.h(8)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subordinates Sales vs Promise",
                  style: TextStyle(fontSize: SizeConfig.w(18), fontWeight: FontWeight.bold),
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
        ),
      );
    });
  }

  Widget _buildSubordinateTile(Subordinate subordinate) {
    final totalSales = subordinate.totalSales ?? 0;
    final totalPromise = subordinate.totalPromise ?? 0;
    final percentage = totalPromise > 0 ? (totalSales / totalPromise) * 100 : 0.0;
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
                  style: TextStyle(fontSize: SizeConfig.w(16), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: SizeConfig.h(4)),
                Text(
                  "Email: ${subordinate.email ?? 'N/A'}",
                  style: TextStyle(fontSize: SizeConfig.w(12), color: Colors.grey[600]),
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
                  style: TextStyle(fontSize: SizeConfig.w(14), fontWeight: FontWeight.w500),
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
                      padding: EdgeInsets.only(left: SizeConfig.w(16), top: SizeConfig.h(4)),
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
                            valueColor: AlwaysStoppedAnimation<Color>(branchProgressColor),
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
}

class PhaseTwoInfoWidget extends StatelessWidget {
  final DateTime startDate = DateTime(2025, 4);
  final DateTime endDate = DateTime(2026, 4);

  final SalesByPhaseController salesPhaseController = Get.find<SalesByPhaseController>();

  PhaseTwoInfoWidget({super.key});

  String getPhaseTwoDateRange() {
    final phase2Start = DateTime(startDate.year, startDate.month + 3);
    final phase2End = DateTime(
      phase2Start.year,
      phase2Start.month + 3,
    ).subtract(const Duration(days: 1));
    final formatter = DateFormat('MMM yyyy');
    return "${formatter.format(phase2Start)} - ${formatter.format(phase2End)}";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final phaseData = {
        "currentPhase": salesPhaseController.salesData.value?.data.currentPhase ?? "Loading...",
        "phase1": (salesPhaseController.salesData.value?.data.phase1 ?? 0).toDouble(),
        "phase2": (salesPhaseController.salesData.value?.data.phase2 ?? 0).toDouble(),
        "phase3": (salesPhaseController.salesData.value?.data.phase3 ?? 0).toDouble(),
        "phase4": (salesPhaseController.salesData.value?.data.phase4 ?? 0).toDouble(),
      };
      final phaseRange = getPhaseTwoDateRange();
      final phaseTarget = (phaseData["phase2"] as num?)?.toDouble() ?? 0.0;
      final salesTillNow =
          ((phaseData["phase1"] as num?)?.toDouble() ?? 0.0) +
          ((phaseData["phase2"] as num?)?.toDouble() ?? 0.0) +
          ((phaseData["phase3"] as num?)?.toDouble() ?? 0.0) +
          ((phaseData["phase4"] as num?)?.toDouble() ?? 0.0);

      final isMobile = SizeConfig.isMobile;
      final padding = isMobile ? SizeConfig.w(12) : SizeConfig.w(20);
      final fontSize = isMobile ? SizeConfig.w(13) : SizeConfig.w(18);
      final amountFontSize = isMobile ? SizeConfig.w(16) : SizeConfig.w(20);
      final gap = isMobile ? SizeConfig.w(12) : SizeConfig.w(20);

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          // color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: Colors.grey.shade300),
          // border: Border.all(color: Colors.grey.shade300),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  constraints: BoxConstraints(minHeight: SizeConfig.h(120)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (phaseData["currentPhase"] as String?)?.isNotEmpty == true
                            ? "Current Phase: ${phaseData["currentPhase"]}"
                            : "Loading phase data...",
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(8)),
                      Text(
                        "₹${phaseTarget.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: amountFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        phaseRange,
                        style: TextStyle(fontSize: fontSize - 2, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  constraints: BoxConstraints(minHeight: SizeConfig.h(120)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current Year Sales",
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(10)),
                      Text(
                        "₹${salesTillNow.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: amountFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
