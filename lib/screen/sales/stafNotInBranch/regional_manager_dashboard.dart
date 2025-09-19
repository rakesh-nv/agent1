import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/categoryWiseSalesController.dart';
import 'package:mbindiamy/widget/appbar_widget.dart';

import '../../../controllers/branch_manager_controller/sales_comparison_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/reporting_controller.dart';
import '../../../controllers/top_articles_controller.dart';
import '../../../controllers/total_sales_controller.dart';
import '../../../model/top_artical_model.dart';
// import '../../../style/appstyle.dart';

import '../../../widget/navigator_widget.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    // final bool isDesktop = AppStyle.isDesktop;

    final horizontalPadding = SizeConfig.isDesktop
        ? SizeConfig.w(60)
        : SizeConfig.isTablet
        ? SizeConfig.w(40)
        : SizeConfig.w(12);

    return Obx(() {
      // // late final loginResponse = loginController.loginResponse.value;
      // if (loginController.loginResponse.value == null ||
      //     loginController.loginResponse.value?.data == null ||
      //     loginController.loginResponse.value?.data!.user == null) {
      //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
      // }

      final currentUser = loginController.loginResponse.value?.data!.user;
      final String? displayUserId = currentUser?.userType == 'head'
          ? 'All Branches'
          : (currentUser!.selectedBranchAliases.isNotEmpty
                ? currentUser?.selectedBranchAliases.first
                : '');

      return Scaffold(
        backgroundColor: Colors.grey[100],
        drawer: NavigationDrawerWidget(),
        appBar: CustomAppBar(
          userName: currentUser!.name,
          userId: displayUserId.toString(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
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
                          SizedBox(
                            width: SizeConfig.isDesktop
                                ? SizeConfig.w(340)
                                : SizeConfig.isTablet
                                ? (SizeConfig.screenWidth / 2) -
                                      SizeConfig.w(30)
                                : double.infinity,
                            child: _infoCard(
                              "Regional Revenue (Today)",
                              "₹${totalSalesController.salesData.value?.totalNetAmount ?? "0.0"}",
                              Icons.currency_rupee,
                              Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.isDesktop
                                ? SizeConfig.w(340)
                                : SizeConfig.isTablet
                                ? (SizeConfig.screenWidth / 2) -
                                      SizeConfig.w(30)
                                : double.infinity,
                            child: _infoCard(
                              "Unit Sold (Today)",
                              "${totalSalesController.salesData.value?.totalNetSlsQty ?? 0} Qty",
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
                                  ? (SizeConfig.screenWidth / 2) -
                                        SizeConfig.w(30)
                                  : double.infinity,
                              child: _infoCard(
                                "My Incentive (Today)",
                                incentiveValue > 0
                                    ? "₹${incentiveValue.toStringAsFixed(2)}"
                                    : "₹0",
                                Icons.currency_rupee,
                                incentiveValue > 0
                                    ? Colors.purple
                                    : Colors.grey,
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
                        final salesData =
                            categoryWiseSalesController.salesData.value;

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
                        } else if (categoryWiseSalesController
                                .errorMessage
                                .value !=
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
                                child: Text(
                                  "No category-wise sales data available.",
                                ),
                              ),
                            ),
                          );
                        }
                        final totalSalesAmount =
                            salesData.data?.totalSales ?? 0;
                        final categories = salesData.data?.categorySales ?? [];
                        print("gggggggggg");
                        print(categories);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(SizeConfig.w(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      size: SizeConfig.w(20),
                                      color: Colors.grey[700],
                                    ),
                                    SizedBox(width: SizeConfig.w(8)),
                                    Text(
                                      "Regional Category Sales",
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
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
                                      style: TextStyle(
                                        fontSize: SizeConfig.w(12),
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
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
                                      "Total Net Sales Quantity: ${NumberFormat('#,##,###').format(salesData.data?.totalNetSlsQty ?? 0)} Qty",
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
                                    final categoryTotalAmount =
                                        category.totalAmount ?? 0;
                                    final percentage = totalSalesAmount > 0
                                        ? (categoryTotalAmount /
                                                  totalSalesAmount) *
                                              100
                                        : 0.0;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: SizeConfig.h(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                category.category as String,
                                                style: TextStyle(
                                                  fontSize: SizeConfig.w(14),
                                                ),
                                              ),
                                              Text(
                                                "${percentage.toStringAsFixed(1)}% ₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                                                style: TextStyle(
                                                  fontSize: SizeConfig.w(14),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: SizeConfig.h(4)),
                                          LinearProgressIndicator(
                                            value: percentage / 100,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.green.shade700,
                                                ),
                                            minHeight: SizeConfig.h(6),
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
                          ),
                        );
                      }),
                      SizedBox(height: SizeConfig.h(16)),
                      highestSellingProduct(context),
                      // My Branch Performance Card
                      // _buildMyBranchPerformanceCard()s,
                      SizedBox(height: SizeConfig.h(16)),
                      // Promise vs Actual Section
                      // _buildPromiseVsActual(),
                      SizedBox(height: SizeConfig.h(16)),
                      // Customer Analytics Card
                      // _buildCustomerAnalyticsCard(),
                      SizedBox(height: SizeConfig.h(16)),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }

  //  Highest Selling Products
  Widget highestSellingProduct(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final double titleFontSize = isMobile ? SizeConfig.w(14) : SizeConfig.w(20);
    final double textFontSize = isMobile ? SizeConfig.w(12) : SizeConfig.w(16);
    final double imageSize = isMobile ? SizeConfig.w(100) : SizeConfig.w(120);
    final double paddingValue = isMobile ? SizeConfig.w(10) : SizeConfig.w(20);
    final double badgeWidth = isMobile ? SizeConfig.w(50) : SizeConfig.w(70);

    final TopArticlesController topArticlesController =
        Get.find<TopArticlesController>();
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
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
                        iconSize: isMobile
                            ? SizeConfig.w(18)
                            : SizeConfig.w(22),
                        color: currentIndex > 0 ? Colors.black : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () {
                          showNext(topArticles.length);
                        },
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
            SizedBox(
              height: cardHeight,
              child: topArticles.isEmpty
                  ? Center(
                      child: Text(
                        topArticlesController.isLoading.value
                            ? "Loading top articles..."
                            : "No top articles data available",
                        style: TextStyle(
                          fontSize: SizeConfig.w(16),
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
  ) {
    return Card(
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

  // Widget _buildPromiseVsActual() {
  //   final List<Map<String, dynamic>> staticDailyValues = [
  //     {
  //       "date": DateFormat('MMM yyyy').format(DateTime(2024, 7, 21)),
  //       "day": "Sun",
  //       "promise": 600000.0,
  //       "actual": 580000.0,
  //     },
  //     {
  //       "date": DateFormat('MMM yyyy').format(DateTime(2024, 7, 22)),
  //       "day": "Mon",
  //       "promise": 620000.0,
  //       "actual": 630000.0,
  //     },
  //     {
  //       "date": DateFormat('MMM yyyy').format(DateTime(2024, 7, 23)),
  //       "day": "Tue",
  //       "promise": 590000.0,
  //       "actual": 550000.0,
  //     },
  //     {
  //       "date": DateFormat('MMM yyyy').format(DateTime(2024, 7, 24)),
  //       "day": "Wed",
  //       "promise": 610000.0,
  //       "actual": 610000.0,
  //     },
  //     {
  //       "date": DateFormat('MMM yyyy').format(DateTime(2024, 7, 25)),
  //       "day": "Thu",
  //       "promise": 630000.0,
  //       "actual": 650000.0,
  //     },
  //   ];
  //
  //   final int itemsPerPage = 4;
  //
  //   List<Map<String, dynamic>> currentData = [];
  //
  //   final startIndex = currentSet * itemsPerPage;
  //   final endIndex = (startIndex + itemsPerPage < staticDailyValues.length)
  //       ? startIndex + itemsPerPage
  //       : staticDailyValues.length;
  //
  //   currentData = staticDailyValues.sublist(startIndex, endIndex).map((dv) {
  //     final promise = (dv["promise"] as num).toDouble();
  //     final actual = (dv["actual"] as num).toDouble();
  //     final percent = promise > 0 ? ((actual / promise) * 100).round() : 0;
  //
  //     return {
  //       "day": dv["day"],
  //       "date": DateFormat(
  //         'd/M',
  //       ).format(DateFormat('MMM yyyy').parse(dv["date"])),
  //       "promise": promise.toStringAsFixed(2),
  //       "actual": actual.toStringAsFixed(2),
  //       "percent": percent,
  //     };
  //   }).toList();
  //
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.all(SizeConfig.w(10)),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(14),
  //       boxShadow: const [
  //         BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               "Promise vs Actual",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: SizeConfig.w(14),
  //               ),
  //             ),
  //             if (staticDailyValues.isNotEmpty)
  //               Row(
  //                 children: [
  //                   // IconButton(
  //                   //   onPressed: currentSet > 0 ? goPrev : null,
  //                   //   icon: const Icon(Icons.arrow_back_ios_new, size: 18),
  //                   // ),
  //                   // Text(
  //                   //   dateRange,
  //                   //   style: TextStyle(fontSize: SizeConfig.w(10)),
  //                   // ),
  //                   // IconButton(
  //                   //   onPressed: currentSet < totalSetsLocal - 1
  //                   //       ? goNext
  //                   //       : null,
  //                   //   icon: const Icon(Icons.arrow_forward_ios, size: 18),
  //                   // ),
  //                 ],
  //               ),
  //           ],
  //         ),
  //         SizedBox(height: SizeConfig.h(4)),
  //         SizedBox(
  //           height: SizeConfig.h(224),
  //           child: staticDailyValues.isEmpty
  //               ? Center(
  //             child: Text(
  //               "No promise vs actual data for this month.",
  //               style: TextStyle(
  //                 fontSize: SizeConfig.w(16),
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           )
  //               : ScrollConfiguration(
  //             behavior: ScrollConfiguration.of(
  //               context,
  //             ).copyWith(scrollbars: false),
  //             child: ListView.separated(
  //               scrollDirection: Axis.horizontal,
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: SizeConfig.w(10),
  //               ),
  //               itemCount: currentData.length,
  //               separatorBuilder: (_, __) =>
  //                   SizedBox(width: SizeConfig.w(10)),
  //               itemBuilder: (context, index) {
  //                 final item = currentData[index];
  //                 final percent = item['percent'] as int;
  //                 final color = percent >= 100
  //                     ? Colors.green
  //                     : percent >= 80
  //                     ? Colors.orange
  //                     : Colors.red;
  //
  //                 return _buildDailyPromiseActualCard(item, color);
  //               },
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: SizeConfig.h(16)),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildDailyPromiseActualCard(Map<String, dynamic> item, Color color) {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: Container(
  //       width: SizeConfig.w(160), // Adjust width as needed
  //       padding: EdgeInsets.all(SizeConfig.w(6)),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: color, width: 2),
  //         borderRadius: BorderRadius.circular(14),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Column(
  //             children: [
  //               Text(
  //                 item['date'] as String,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: SizeConfig.w(14),
  //                 ),
  //               ),
  //               SizedBox(height: SizeConfig.h(2)),
  //               Text(
  //                 item['day'] as String,
  //                 style: TextStyle(
  //                   color: Colors.grey,
  //                   fontSize: SizeConfig.w(10),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Column(
  //             children: [
  //               Text(
  //                 "Promise",
  //                 style: TextStyle(
  //                   color: Colors.grey[700],
  //                   fontSize: SizeConfig.w(11),
  //                 ),
  //               ),
  //               SizedBox(height: SizeConfig.h(1.2)),
  //               FittedBox(
  //                 fit: BoxFit.scaleDown,
  //                 child: Text(
  //                   item['promise'] as String,
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: SizeConfig.w(14),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Column(
  //             children: [
  //               Text(
  //                 "Actual",
  //                 style: TextStyle(
  //                   color: Colors.grey[700],
  //                   fontSize: SizeConfig.w(11),
  //                 ),
  //               ),
  //               SizedBox(height: SizeConfig.h(1.2)),
  //               FittedBox(
  //                 fit: BoxFit.scaleDown,
  //                 child: Text(
  //                   item['actual'] as String,
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: SizeConfig.w(14),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Container(
  //             padding: EdgeInsets.symmetric(vertical: SizeConfig.h(3.2)),
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(0.15),
  //               borderRadius: BorderRadius.circular(14),
  //             ),
  //             child: Center(
  //               child: Text(
  //                 "${item['percent']}%",
  //                 style: TextStyle(
  //                   color: color,
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: SizeConfig.w(14),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSalesComparisonCard() {
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
                        ),
                      ),
                      SizedBox(width: SizeConfig.w(16)),
                      Expanded(
                        child: _infoCard(
                          "Yesterday's Sales",
                          "₹${yesterdaySales.toStringAsFixed(0)}",
                          Icons.money_off,
                          Colors.orange,
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

  // Widget _buildMyBranchPerformanceCard() {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: EdgeInsets.all(SizeConfig.w(16)),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.apartment,
  //                     size: SizeConfig.w(20),
  //                     color: Colors.grey[700],
  //                   ),
  //                   SizedBox(width: SizeConfig.w(8)),
  //                   Text(
  //                     "My Branch Performance",
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.w(16),
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: SizeConfig.w(8),
  //                   vertical: SizeConfig.h(4),
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: Colors.green.shade100,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Text(
  //                   "Own Branch",
  //                   style: TextStyle(
  //                     fontSize: SizeConfig.w(12),
  //                     color: Colors.green.shade700,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: SizeConfig.h(16)),
  //           Container(
  //             padding: EdgeInsets.all(SizeConfig.w(12)),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[100],
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Row(
  //               children: [
  //                   Icon(
  //                     Icons.location_on,
  //                     size: SizeConfig.w(18),
  //                     color: Colors.grey[600],
  //                   ),
  //                 SizedBox(width: SizeConfig.w(8)),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Mumbai Central Branch",
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.w(14),
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     Text(
  //                       "Code: MBC-001",
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.w(12),
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: SizeConfig.h(16)),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Today's Sales",
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.w(14),
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                     SizedBox(height: SizeConfig.h(4)),
  //                     Text(
  //                       "₹2,45,000",
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.w(20),
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.green.shade700,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Text(
  //                       "Month to Date",
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.w(14),
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                     SizedBox(height: SizeConfig.h(4)),
  //                     Text(
  //                       "₹3,250,000",
  //                       style: TextStyle(
  //                         fontSize: SizeConfig.w(20),
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.black87,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: SizeConfig.h(16)),
  //           Text(
  //             "Monthly Target Progress",
  //             style: TextStyle(
  //               fontSize: SizeConfig.w(14),
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //           SizedBox(height: SizeConfig.h(4)),
  //           LinearProgressIndicator(
  //             value: 0.813,
  //             // 81.3%
  //             backgroundColor: Colors.grey[200],
  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
  //             minHeight: SizeConfig.h(10),
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //           SizedBox(height: SizeConfig.h(4)),
  //           Align(
  //             alignment: Alignment.topRight,
  //             child: Text(
  //               "81.3%",
  //               style: TextStyle(
  //                 fontSize: SizeConfig.w(14),
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black87,
  //               ),
  //             ),
  //           ),
  //           Text(
  //             "Remaining: ₹750,000",
  //             style: TextStyle(
  //               fontSize: SizeConfig.w(13),
  //               color: Colors.orange.shade700,
  //             ),
  //           ),
  //           SizedBox(height: SizeConfig.h(16)),
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.group,
  //                 size: SizeConfig.w(16),
  //                 color: Colors.grey[600],
  //               ),
  //               SizedBox(width: SizeConfig.w(8)),
  //               Text(
  //                 "Team Size: 12",
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.w(14),
  //                   color: Colors.grey[800],
  //                 ),
  //               ),
  //               SizedBox(width: SizeConfig.w(24)),
  //               Icon(
  //                 Icons.people_alt,
  //                 size: SizeConfig.w(16),
  //                 color: Colors.grey[600],
  //               ),
  //               SizedBox(width: SizeConfig.w(8)),
  //               Text(
  //                 "Customers Today: 156",
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.w(14),
  //                   color: Colors.grey[800],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildCustomerAnalyticsCard() {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: EdgeInsets.all(SizeConfig.w(16)),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.people_outline,
  //                     size: SizeConfig.w(20),
  //                     color: Colors.grey[700],
  //                   ),
  //                   SizedBox(width: SizeConfig.w(8)),
  //                   Text(
  //                     "Customer Analytics",
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.w(16),
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: SizeConfig.w(8),
  //                   vertical: SizeConfig.h(4),
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: Colors.blue.shade100,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Text(
  //                   "Today's Data",
  //                   style: TextStyle(
  //                     fontSize: SizeConfig.w(12),
  //                     color: Colors.blue.shade700,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: SizeConfig.h(16)),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: Card(
  //                   color: Colors.green.shade50,
  //                   elevation: 0,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: Padding(
  //                     padding: EdgeInsets.all(SizeConfig.w(5)),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Icon(
  //                               Icons.person_add_alt_1,
  //                               size: SizeConfig.w(18),
  //                               color: Colors.green.shade700,
  //                             ),
  //                             SizedBox(width: SizeConfig.w(8)),
  //                             Text(
  //                               "New Customers",
  //                               style: TextStyle(
  //                                 fontSize: SizeConfig.w(14),
  //                                 color: Colors.green.shade700,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: SizeConfig.h(8)),
  //                         Text(
  //                           "24",
  //                           style: TextStyle(
  //                             fontSize: SizeConfig.w(20),
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.green.shade700,
  //                           ),
  //                         ),
  //                         Text(
  //                           "↗ +12%",
  //                           style: TextStyle(
  //                             fontSize: SizeConfig.w(12),
  //                             color: Colors.green,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: SizeConfig.w(16)),
  //               Expanded(
  //                 child: Card(
  //                   color: Colors.green.shade50,
  //                   elevation: 0,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: Padding(
  //                     padding: EdgeInsets.all(SizeConfig.w(12)),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Icon(
  //                               Icons.people,
  //                               size: SizeConfig.w(18),
  //                               color: Colors.green.shade700,
  //                             ),
  //                             SizedBox(width: SizeConfig.w(8)),
  //                             Expanded(
  //                               child: Text(
  //                                 "Repeat Customers",
  //                                 style: TextStyle(
  //                                   fontSize: SizeConfig.w(14),
  //                                   color: Colors.green.shade700,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: SizeConfig.h(8)),
  //                         Text(
  //                           "156",
  //                           style: TextStyle(
  //                             fontSize: SizeConfig.w(20),
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.green.shade700,
  //                           ),
  //                         ),
  //                         Text(
  //                           "↗ +8%",
  //                           style: TextStyle(
  //                             fontSize: SizeConfig.w(12),
  //                             color: Colors.green,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: SizeConfig.h(16)),
  //           Text(
  //             "Customer Distribution",
  //             style: TextStyle(
  //               fontSize: SizeConfig.w(16),
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           SizedBox(height: SizeConfig.h(12)),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "New vs Repeat",
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.w(14),
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Text(
  //                 "13% : 87%",
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.w(14),
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: SizeConfig.h(4)),
  //           LinearProgressIndicator(
  //             value: 0.13,
  //             // 13% for new, so remaining is repeat
  //             backgroundColor: Colors.green.shade700,
  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade200),
  //             minHeight: SizeConfig.h(10),
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //           SizedBox(height: SizeConfig.h(12)),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 "Repeat Rate",
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.w(14),
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Text(
  //                 "68%",
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.w(14),
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
