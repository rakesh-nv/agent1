import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/categoryWiseSalesController.dart';
import 'package:mbindiamy/widget/appbar_widget.dart';

import '../../../controllers/ArticleWithMrpAndStockController.dart';
import '../../../controllers/branch_manager_controller/sales_comparison_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/reporting_controller.dart';
import '../../../controllers/top_articles_controller.dart';
import '../../../controllers/total_sales_controller.dart';
import '../../../model/top_artical_model.dart';
// import '../../../style/appstyle.dart';

import '../../../model/top_artical_model.dart' as TopArticleData;
import '../../../style/appTextStyle.dart';
import '../../../style/siseConfig.dart';
import '../../../widget/navigator_widget.dart';
import 'package:get/get.dart';

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
                          ? "₹${incentiveValue.toStringAsFixed(2)}"
                          : "₹0",
                      Icons.trending_up,
                      incentiveValue > 0 ? Colors.purple : Colors.grey,
                    );
                  }),

                  // Sales Comparison Card
                  _buildSalesComparisonCard(),
                  _buildBranchPerformanceCard(),
                  // Category-wise Sales Card
                  _buildCategoryWiseSalesCard(),
                  // Highest Selling Product
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
      } else if (categoryWiseSalesController.errorMessage.value != null) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                            Text(
                              "${percentage.toStringAsFixed(1)}% ₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                              // style: TextStyle(
                              //   fontSize: SizeConfig.w(14),
                              //   fontWeight: FontWeight.w600,
                              // ),
                              style: AppTextStyles.bodyText(),
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
      } else if (categoryWiseSalesController.errorMessage.value != null) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                      "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
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
                  final categoryTotalAmount = category.totalAmount ?? 0;
                  final percentage = totalSalesAmount > 0
                      ? (categoryTotalAmount / totalSalesAmount) * 100
                      : 0.0;
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.category as String,
                              // style: TextStyle(fontSize: SizeConfig.w(14)),
                              style: AppTextStyles.bodyText(),
                            ),
                            Text(
                              "${percentage.toStringAsFixed(1)}% ₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                              // style: TextStyle(
                              //   fontSize: SizeConfig.w(14),
                              //   // fontWeight: FontWeight.w600,
                              // ),
                              style: AppTextStyles.bodyText(),
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
          final topArticles =
              topArticlesController.data.value?.data.take(7).toList() ?? [];
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
                          "Today's Sales",
                          "₹${todaySales.toStringAsFixed(0)}",
                          null, // Keep the icon
                          null, // Keep the icon color
                        ),
                      ),
                      Expanded(
                        child: _buildInfoCard(
                          0,
                          "Yesterday's Sales",
                          "₹${yesterdaySales.toStringAsFixed(0)}",
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
      if (articleController.errorMessage.value.isNotEmpty)
        return _buildErrorCard(articleController.errorMessage.value);

      // Filter articles based on search query
      final articles = articleController.articles
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
          .take(5)
          .toList();

      if (articles.isEmpty && _searchQuery.value.isEmpty)
        return _buildEmptyCard("No articles available.");
      if (articles.isEmpty)
        return _buildEmptyCard("No articles match your search.");
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
                  Icon(Icons.search, size: SizeConfig.w(20)),

                  Text(
                    "Articles with MRP and Stock",
                    style: AppTextStyles.subheadlineText(),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(12)),
              // Search Bar

              SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Article ID or Category',
                    prefixIcon: Icon(Icons.search, size: SizeConfig.w(16)), // Reduced icon size
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // Slightly smaller border radius
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 1), // Thinner border
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: SizeConfig.h(3), // Reduced vertical padding
                      horizontal: SizeConfig.w(8), // Reduced horizontal padding
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintStyle: AppTextStyles.bodyText(), // Smaller hint text
                  ),
                  style: AppTextStyles.bodyText(), // Smaller input text
                  onChanged: (value) {
                    _searchQuery.value = value; // Update search query reactively
                  },
                ),
              ),              SizedBox(height: SizeConfig.h(12)),
              // Table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: SizeConfig.w(300)),
                  child: DataTable(
                    columnSpacing: SizeConfig.w(8),
                    dataRowHeight: SizeConfig.h(40),
                    headingRowHeight: SizeConfig.h(30),
                    horizontalMargin: SizeConfig.w(6),
                    columns: [
                      _buildTableHeader("Article ID", flex: 1),
                      _buildTableHeader("Category", flex: 2),
                      _buildTableHeader("Price", flex: 1),
                      _buildTableHeader("Stock", flex: 1),
                    ],
                    rows: articles
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
                                  "₹${article.itemMRP?.toStringAsFixed(2) ?? '0.00'}",
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
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(12)),
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
