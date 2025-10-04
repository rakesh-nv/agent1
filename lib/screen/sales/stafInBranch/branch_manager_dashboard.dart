import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/BranchManagerSalesVsPromiseController.dart';
import 'package:mbindiamy/controllers/branch_manager_controller/categoryWiseSalesController.dart';
import 'package:mbindiamy/controllers/subordinates_aggregation_controller.dart';
import 'package:mbindiamy/controllers/total_sales_controller.dart'
    show TotalSalesController;
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/widget/appbar_widget.dart';
import 'package:get/get.dart';
import '../../../controllers/branch_manager_controller/sales_comparison_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/promise_actual_controller.dart';
import '../../../controllers/reporting_controller.dart';
import '../../../controllers/subordinates_sales_vs_promise_controller.dart';
import '../../../controllers/top_articles_controller.dart';
import '../../../model/subordinates_sales_vs_promise_model.dart' as SalesModel;
import '../../../model/subordinates_aggregation_model.dart' as AggModel;
import '../../../model/top_artical_model.dart' as TopArticleData;
import '../../../style/appTextStyle.dart';
import '../../../style/siseConfig.dart';
import '../../../widget/navigator_widget.dart';
import '../../../controllers/ArticleWithMrpAndStockController.dart';
import '../../../model/ArticlesWithMrpAndStock_model.dart'
    as ArticleMrpStockData;

class BranchManagerDashboard extends StatefulWidget {
  const BranchManagerDashboard({super.key});

  @override
  State<BranchManagerDashboard> createState() => _BranchManagerDashboardState();
}

class _BranchManagerDashboardState extends State<BranchManagerDashboard> {
  int currentSet = 0;
  int currentIndex = 0;
  final PageController _pageController = PageController();
  final PageController _pageController1 = PageController();
  final ScrollController _mainScrollController = ScrollController();
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
  final SubordinatesAggregationController subordinatesAggregationController =
      Get.find<SubordinatesAggregationController>();
  final PromiseActualController promiseController =
      Get.find<PromiseActualController>();
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
      await Future.wait([
        reportingController.getReportingManager().catchError(
          (e) => debugPrint("Reporting error: $e"),
        ),
        salesComparisonController.fetchTodaysSales().catchError(
          (e) => debugPrint("Today's Sales error: $e"),
        ),
        salesComparisonController.fetchYesterdaySales().catchError(
          (e) => debugPrint("Yesterday's Sales error: $e"),
        ),
        categoryWiseSalesController.fetchCategoryWiseSales().catchError(
          (e) => debugPrint("Category Wise Sales error: $e"),
        ),
        totalSalesController.fetchTodaysSales().catchError(
          (e) => debugPrint("Total Sales error: $e"),
        ),
        totalSalesController.fetchThisMonthSales().catchError(
          (e) => debugPrint("Total Sales error: $e"),
        ),
        topArticlesController.loadTopArticles().catchError(
          (e) => debugPrint("loadTopArticles error"),
        ),
        branchManagerSalesVsPromiseController
            .fetchSalesVsPromiseData()
            .catchError((e) => debugPrint("fetchSalesVsPromiseData error")),
        subordinatesSalesVsPromiseController
            .fetchSubordinatesSalesVsPromise()
            .catchError(
              (e) => debugPrint("fetchSubordinatesSalesVsPromise error"),
            ),
        subordinatesAggregationController
            .fetchSubordinatesAggregation()
            .catchError((e) => debugPrint("loadPromiseActualData error")),
        promiseController.loadPromiseActualData().catchError(
          (e) => debugPrint("loadPromiseActualData error"),
        ),
        articleController.fetchArticles().catchError(
          (e) => debugPrint("ArticleController error: $e"),
        ),
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
    _mainScrollController.dispose();
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

  void goNext() => setState(() => currentSet++);

  void goPrev() => setState(() => currentSet--);
  int currentIncentiveIndex = 0;

  void switchIncentivePage(int index) {
    setState(() {
      currentIncentiveIndex = index;
      _pageController1.jumpToPage(
        index,
      ); // Sync the PageController with the new index
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

      final loginResponse = loginController.loginResponse.value;
      final user = loginResponse?.data?.user;
      String userId =
      user?.userType.toLowerCase() == 'head' || user?.isAllBranches == true
          ? 'All Branches'
          : user?.selectedBranchAliases.join(', ') ?? '';

      final allDailyValues = (promiseController.data.value?.data.locations ?? [])
          .expand((location) => location.dailyValues)
          .map(
            (dv) => {
          "date": dv.date.toString(),
          "day": DateTime.parse(dv.date.toString()).day,
          "promise": dv.promise,
          "actual": dv.actual,
        },
      )
          .toList();

      final now = DateTime.now();
      final currentYear = now.year;
      final currentMonth = now.month;
      final filteredDailyValues = allDailyValues.where((dv) {
        try {
          final dateString = dv["date"] as String;
          if (dateString.isEmpty) return false;
          final dt = DateFormat('d/M').parse(dateString);
          return dt.year == currentYear && dt.month == currentMonth;
        } catch (e) {
          return false;
        }
      }).toList();

      final itemsPerPage = SizeConfig.isMobile ? 3 : 4;
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
            final dt = DateFormat('d/M').parse(dateString);
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
        dateRange = "${currentData.first['date']} - ${currentData.last['date']}";
      }
      final userName =
          loginController.loginResponse.value?.data!.user.name ?? "Loading...";
      final reportingName = reportingController.manager.value ?? "Loading...";
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
        body: LayoutBuilder(
          builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: Obx(() {
                return SingleChildScrollView(
                  controller: _mainScrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: SizeConfig.h(6),
                  ),
                  child: !salesComparisonController.hasConnection.value
                      ? Center(
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
                          style: AppTextStyles.headlineText(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: SizeConfig.h(10)),
                        Text(
                          "Please check your internet connection and try again.",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyText(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    children: [
                      Obx(
                            () => _buildInfoCard(
                          1,
                          "Total Sales Amount($salesDateStr)",
                          // "₹${totalSalesController.salesData.value?.totalNetAmount ?? '0.0'}",
                          (totalSalesController
                              .salesData
                              .value
                              ?.totalNetAmount ??
                              0.0) >
                              0
                              ? "₹${(NumberFormat('#,##,###').format(totalSalesController.salesData.value?.totalNetAmount))}"
                              : "₹0",
                          Icons.currency_rupee,
                          Colors.green,
                        ),
                      ),
                      Obx(
                            () => _buildInfoCard(
                          1,
                          "Unit Sold ($salesDateStr)",
                          "${totalSalesController.salesData.value?.totalNetSlsQty ?? 0} Qty",
                          Icons.shopping_cart_outlined,
                          Colors.blue,
                        ),
                      ),
                      Obx(
                            () => _buildInfoCard(
                          1,
                          "My Incentive ($salesDateStr)",
                          (totalSalesController.myIncentive.value ?? 0.0) >
                              0
                              ? "₹${(NumberFormat('#,##,###').format(totalSalesController.myIncentive.value))}"
                              : "₹0",
                          Icons.trending_up,
                          (totalSalesController.myIncentive.value ?? 0.0) >
                              0
                              ? Colors.purple
                              : Colors.grey,
                        ),
                      ),
                      // Consistent gap
                      _buildSalesComparisonCard(),
                      // Consistent gap
                      Obx(() => _buildCategoryWiseSalesCard()),
                      // Consistent gap
                      _buildBranchPerformanceCard(),

                      _buildPromiseVsActualCard(
                        filteredDailyValues,
                        totalSetsLocal,
                        dateRange,
                      ),
                      highestSellingProduct(context),
                      // _buildSubordinatesSalesVsPromiseCard(),
                      _buildIncentiveDashboardCard(),
                      // Consistent gap
                      // _buildArticleWithMrpAndStockCard(),
                      ArticleWithMrpAndStockCard(),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      );
    },);

  }

  Widget _buildPromiseVsActualCard(
    List<Map<String, dynamic>> filteredDailyValues,
    int totalSetsLocal,
    String dateRange,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 600 ? 18.0 : 24.0;

    return Card(
      color: Colors.white,
      elevation: 1,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(SizeConfig.w(8)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.w(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Promise vs Actual",
                  style: AppTextStyles.subheadlineText(),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(4)),
            Obx(() {
              final list = promiseController.filteredData
                  .where(
                    (item) =>
                        item['percent'] != null &&
                        item['promise'] != null &&
                        item['actual'] != null,
                  )
                  .toList()
                  .reversed
                  .toList();
              final isLargeScreen = MediaQuery.of(context).size.height > 600;
              final containerHeight = isLargeScreen
                  ? MediaQuery.of(context).size.height * 0.2
                  : MediaQuery.of(context).size.height * 0.5;
              return SizedBox(
                height: containerHeight,
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          promiseController.isLoading.value
                              ? "Loading promise vs actual data..."
                              : "No promise vs actual data for this month.",
                          style: AppTextStyles.bodyText(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
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
                            horizontal: SizeConfig.w(8),
                          ),
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: SizeConfig.w(8)),
                          itemBuilder: (context, index) {
                            final item = list[index];
                            final percent =
                                (item['percent'] as num?)?.toInt() ?? 0;
                            final color = percent >= 100
                                ? Colors.green
                                : percent >= 80
                                ? Colors.orange
                                : Colors.red;
                            return Container(
                              width: SizeConfig.w(100),
                              padding: EdgeInsets.all(SizeConfig.w(6)),
                              decoration: BoxDecoration(
                                border: Border.all(color: color, width: 2),
                                borderRadius: BorderRadius.circular(
                                  SizeConfig.w(12),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${item['date']}",
                                    style: AppTextStyles.captionText(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Promise",
                                        style: AppTextStyles.smallText(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.h(1.2)),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          item['promise'] as String? ?? '0.00',
                                          style: AppTextStyles.bodyText(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Actual",
                                        style: AppTextStyles.smallText(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.h(1.2)),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          item['actual'] as String? ?? '0.00',
                                          style: AppTextStyles.bodyText(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.h(3),
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                        SizeConfig.w(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "$percent%",
                                        style: AppTextStyles.bodyText(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
    );
  }

  Widget _buildSectionCard(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.w(8)),
      margin: EdgeInsets.symmetric(vertical: SizeConfig.h(4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.w(12)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 4,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Text(title, style: AppTextStyles.bodyText()),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  article.articleNo ?? 'N/A',
                  maxLines: 2,
                  style: AppTextStyles.bodyText(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount: ₹${NumberFormat("#,##,##").format(article.netAmount)}",
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
                      "Sales Comparison",
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
                      "+${percentageChange.toStringAsFixed(1)}%",
                    )
                  :
                    // difference < 0 ?
                    (
                      Colors.red,
                      Icons.trending_down,
                      "${percentageChange.toStringAsFixed(1)}% ",
                    );
              // : (Colors.orange, Icons.show_chart, "No change vs yesterday");

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
                        Text(
                          "vs yesterday (₹${NumberFormat("#,##,###").format(difference.abs())})",
                          style: AppTextStyles.bodyText(),
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

  Widget _buildCategoryWiseSalesCard() {
    final salesData = categoryWiseSalesController.salesData.value;

    if (categoryWiseSalesController.isLoading.value) {
      return _buildLoadingCard();
    } else if (salesData == null ||
        salesData.data?.categorySales == null ||
        salesData.data!.categorySales!.isEmpty) {
      return _buildEmptyCard("No category-wise sales data available.");
    }
    final totalSalesAmount = salesData.data?.totalSales ?? 0;
    final categories = salesData.data?.categorySales ?? [];
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
                      Icons.bar_chart,
                      size: SizeConfig.w(18),
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Category-wise Sales",
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
                    borderRadius: BorderRadius.circular(SizeConfig.w(8)),
                  ),
                  child: Text(
                    "Total: ₹${NumberFormat('#,##,###').format(totalSalesAmount)}",
                    style: AppTextStyles.captionText(color: Colors.grey),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Icon(
                  Icons.folder,
                  size: SizeConfig.w(16),
                  color: Colors.grey[600],
                ),
                SizedBox(width: SizeConfig.w(8)),
                Flexible(
                  child: Text(
                    "Sales Quantity: ${NumberFormat('#,##,###').format(salesData.data?.totalNetSlsQty ?? 0)}",
                    style: AppTextStyles.bodyText(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
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
                final color = percentage >= 100
                    ? Colors.green
                    : percentage >= 80
                    ? Colors.orange
                    : Colors.red;
                return Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              category.category as String,
                              style: AppTextStyles.bodyText(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${percentage.toStringAsFixed(1)}%",
                                  style: AppTextStyles.captionText(),
                                ),
                                Text(
                                  " ₹${NumberFormat('#,##,###').format(categoryTotalAmount)}",
                                  style: AppTextStyles.bodyText(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: SizeConfig.h(6),
                        borderRadius: BorderRadius.circular(SizeConfig.w(3)),
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

      return Card(
        color: Colors.white,
        // margin: EdgeInsets.symmetric(vertical: SizeConfig.h(8)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subordinates Sales vs Promise",
                style: AppTextStyles.subheadlineText(),
              ),

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

  Widget _buildBranchPerformanceCard() {
    return Obx(() {
      if (totalSalesController.isLoading.value ||
          subordinatesAggregationController.isLoading.value) {
        return _buildLoadingCard(); // Assume this is defined elsewhere for loading state
      } // Assume this is defined elsewhere

      // Aggregate total branch performance from subordinates
      final data =
          subordinatesAggregationController.subordinatesResponse.value?.data;
      final List<AggModel.Subordinate> subordinates = data?.subordinates ?? [];
      final totalBranchPerformance = subordinates.fold<double>(
        0.0,
        (sum, subordinate) =>
            sum + (subordinate.sales.totalSales.totalAmount ?? 0),
      );

      final target = promiseController
          .monthPromiseSum
          .value; // Example monthly target for branch performance; replace with dynamic value
      final performanceScore =
          (totalBranchPerformance / target) *
          100; // Percentage of target achieved
      // final remaining = target - totalBranchPerformance;
      // final totalPurchase =
      //     totalSalesController.totalPurchaseAmountMonthly.value ?? 0.0;
      // final customersServed =
      //     totalSalesController.customersServedMonthly.value ?? 0;
      // final netProfit = totalSalesController.netProfitMonthly.value ?? 0.0;

      // Current date and time (12:08 PM IST on Friday, October 03, 2025)
      final now = DateTime(2025, 10, 3, 12, 8); // Hardcoded for this example
      final formattedDateTime = DateFormat(
        'EEEE, MMMM dd, yyyy hh:mm a',
      ).format(now);

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.w(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Branch Performance",
                    style: AppTextStyles.subheadlineText(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(8),
                      vertical: SizeConfig.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(SizeConfig.w(8)),
                    ),
                    child: Text(
                      "Live Updates",
                      style: AppTextStyles.captionText(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.w(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Data as of: $formattedDateTime IST",
                  //   style: AppTextStyles.captionText(color: Colors.grey),
                  // ),
                  // SizedBox(height: SizeConfig.h(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: SizeConfig.w(8)),
                              Text(
                                "Today's Sales",
                                style: AppTextStyles.captionText(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.h(4)),
                          Text(
                            // "₹${NumberFormat("#,##,###").format(totalSalesController.salesData.value?.totalNetAmount)}",
                            (totalSalesController
                                            .salesData
                                            .value
                                            ?.totalNetAmount ??
                                        0.0) >
                                    0
                                ? "₹${(NumberFormat('#,##,###').format(totalSalesController.salesData.value?.totalNetAmount))}"
                                : "₹0",

                            style: AppTextStyles.subheadlineText(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: SizeConfig.w(8)),
                              Text(
                                "Month To Date",
                                style: AppTextStyles.captionText(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.h(4)),
                          Text(
                            (totalSalesController
                                            .salesData
                                            .value
                                            ?.totalNetAmount ??
                                        0.0) >
                                    0
                                ? "₹${(NumberFormat('#,##,###').format(totalSalesController.thisMonthSalesData.value?.totalNetAmount))}"
                                : "₹0",
                            style: AppTextStyles.subheadlineText(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(16)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildIncentiveDashboardCard() {
    return Obx(() {
      // Check loading state for both controllers
      if (subordinatesSalesVsPromiseController.isLoading.value ||
          totalSalesController.isLoading.value) {
        return _buildLoadingCard();
      }

      // Monthly metrics for "My Incentives" tab
      final myIncentive = totalSalesController.myIncentiveThisMonth.value ?? 0.0;
      final target = promiseController.monthPromiseSum.value; // Example monthly target
      final achievementPercentage = (myIncentive / target) * 100;
      final remaining = target - myIncentive;

      // Team leaderboard data from subordinatesSalesVsPromiseController
      final data = subordinatesSalesVsPromiseController
          .subordinatesSalesVsPromiseData
          .value
          ?.data;
      final List<SalesModel.Subordinate> subordinates =
          data?.subordinates ?? [];
      final sortedSubordinates =
          subordinates
              .where((subordinate) => subordinate.totalSales != null)
              .toList()
            ..sort((a, b) => (b.totalSales ?? 0).compareTo(a.totalSales ?? 0));
      final teamRank =
          sortedSubordinates.indexWhere(
            (sub) => sub.totalSales == myIncentive.toInt(),
          ) +
          1;

      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        child: DefaultTabController(
          length: 2, // Two tabs: My Incentives and Team Leaderboard
          initialIndex: 0, // Start with My Incentives
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(SizeConfig.w(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Incentive Dashboard",
                      style: AppTextStyles.subheadlineText(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(8),
                        vertical: SizeConfig.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(SizeConfig.w(8)),
                      ),
                      child: Text(
                        "Live Updates",
                        style: AppTextStyles.captionText(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TabBar(
                    dividerHeight: 0,
                    labelColor: Colors.blue[700],
                    unselectedLabelColor: Colors.grey[600],
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    labelPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(16),
                      vertical: SizeConfig.h(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.h(4)),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "My Incentives",
                          style: AppTextStyles.bodyText(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Team Leaderboard",
                        style: AppTextStyles.bodyText(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.h(450), // Adjustable height for the tab view
                child: TabBarView(
                  children: [
                    _buildMyIncentivesView(
                      myIncentive: myIncentive,
                      target: target,
                      achievementPercentage: achievementPercentage,
                      remaining: remaining,
                      teamRank: teamRank,
                      totalPurchaseAmount:
                          totalSalesController.totalPurchaseAmountMonthly.value,
                      customersServed:
                          totalSalesController.customersServedMonthly.value,
                      netProfit: totalSalesController.netProfitMonthly.value,
                    ),
                    _buildTeamLeaderboardView(sortedSubordinates),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMyIncentivesView({
    required double myIncentive,
    required double target,
    required double achievementPercentage,
    required double remaining,
    required int teamRank,
    double? totalPurchaseAmount,
    int? customersServed,
    double? netProfit,
  }) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.w(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.currency_rupee,
                        color: Colors.green[700],
                        size: SizeConfig.w(18),
                      ),
                      SizedBox(width: SizeConfig.w(8)),
                      Text(
                        "This Month",
                        style: AppTextStyles.captionText(color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(4)),
                  Text(
                    "₹${NumberFormat("#,##,###").format(myIncentive)}",
                    style: AppTextStyles.subheadlineText(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: Colors.blue[700],
                        size: SizeConfig.w(18),
                      ),
                      SizedBox(width: SizeConfig.w(8)),
                      Text(
                        "Target",
                        style: AppTextStyles.captionText(color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(4)),
                  Text(
                    "₹${NumberFormat("#,##,###").format(target)}",
                    style: AppTextStyles.subheadlineText(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.orange[700],
                        size: SizeConfig.w(20),
                      ),
                      SizedBox(width: SizeConfig.w(8)),
                      Text(
                        "Achievement",
                        style: AppTextStyles.captionText(color: Colors.orange),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(4)),
                  Text(
                    "${achievementPercentage.toStringAsFixed(1)}%",
                    style: AppTextStyles.subheadlineText(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.h(16)),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Progress to Target",
                  style: AppTextStyles.bodyText(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: SizeConfig.h(8)),
                LinearProgressIndicator(
                  value: achievementPercentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                  minHeight: SizeConfig.h(10),
                  borderRadius: BorderRadius.circular(SizeConfig.w(5)),
                ),
                SizedBox(height: SizeConfig.h(8)),
                Text(
                  "Remaining: ₹${NumberFormat('#,##,###').format(remaining)} to reach target",
                  style: AppTextStyles.captionText(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLeaderboardView(
    List<SalesModel.Subordinate> sortedSubordinates,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedSubordinates.length,
            itemBuilder: (context, index) {
              final subordinate = sortedSubordinates[index];
              final rank = index + 1;
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
                padding: EdgeInsets.all(SizeConfig.w(5)),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(SizeConfig.w(5)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.w(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(

                                  backgroundColor: rank == 1
                                      ? Colors.yellow[700]
                                      : rank == 2
                                      ? Colors.grey[400]
                                      : rank == 3
                                      ? Colors.brown[400]
                                      : Colors.transparent,
                                  child: Text(
                                    '#$rank',
                                    style: TextStyle(
                                      color: rank <= 3
                                          ? Colors.black
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.w(8)),
                                Text(
                                  subordinate.name ?? 'N/A',
                                  style: AppTextStyles.bodyText(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "₹${NumberFormat('#,##,###').format(totalSales)}",
                              style: AppTextStyles.subheadlineText(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.h(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Target: ₹${NumberFormat('#,##,###').format(totalPromise)}",
                              style: AppTextStyles.captionText(),
                            ),
                            Text(
                              "${percentage.toStringAsFixed(1)}%",
                              style: AppTextStyles.captionText(
                                color: Colors.grey,
                              ),
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
                          minHeight: SizeConfig.h(8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        SizedBox(height: SizeConfig.h(4)),
                        Text(
                          "Remaining: ₹${NumberFormat('#,##,###').format(totalPromise - totalSales)}",
                          style: AppTextStyles.captionText(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculateIncentive(double sales) {
    double incentive = sales * 0.01;

    return incentive;
  }

  Widget _buildLoadingCard() => Card(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SizeConfig.w(5)),
    ),
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.w(16)),
      child: Center(child: CircularProgressIndicator()),
    ),
  );

  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.w(12)),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(16)),
        child: Center(
          child: Text(
            "Error: $message",
            style: AppTextStyles.bodyText(color: Colors.red),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3, // Allow multiple lines for longer error messages
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.w(12)),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(16)),
        child: Center(
          child: Text(
            message,
            style: AppTextStyles.bodyText(color: Colors.grey),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3, // Allow multiple lines for longer messages
          ),
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
                      height: 70,
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
                      height: 70,
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
