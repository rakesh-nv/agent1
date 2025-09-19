import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbindiamy/branch/stafInBranch/salesAgentScreen.dart';

import '../stafNotInBranch/purchase/branchPurchaseCoordinator.dart';
import '../stafNotInBranch/purchase/purchaseHead.dart';
import '../stafNotInBranch/purchase/regionalPurchaseLead.dart';
import '../stafNotInBranch/sales/branchSalesCoordinator.dart';
import '../stafNotInBranch/sales/branchSalesHead.dart';
import 'billingManager.dart';

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

class BranchManagerScreen extends StatefulWidget {
  const BranchManagerScreen({super.key});

  @override
  State<BranchManagerScreen> createState() => _BranchManagerScreenState();
}

class _BranchManagerScreenState extends State<BranchManagerScreen> {
  int currentSet = 0; // For Promise vs Actual pagination
  int currentIndex = 0; // For Top Articles pagination
  final PageController _pageController = PageController();
  final ScrollController _mainScrollController =
      ScrollController(); // Added for main scrollbar

  // final PromiseActualController promiseController = Get.find<PromiseActualController>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await _loadPromiseActualData();
    // });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mainScrollController.dispose(); // Dispose main scroll controller
    super.dispose();
  }

  // Future<void> _loadPromiseActualData() async {
  //   try {
  //     await promiseController.loadPromiseActualData();
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to load promise vs actual data: $e");
  //   }
  // }

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

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.w(24),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(8)),
                  Text(
                    'Select a dashboard',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: SizeConfig.w(16),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Branch Manager Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BranchManagerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Billing Manager Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BillingManagerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Sales Agent Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesAgentScreen()),
                );
                // Already on Sales Agent Dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_center),
              title: const Text('Purchase Head Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurchaseHeadScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: const Text('Regional Purchase Manager Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegionalPurchaseLeadScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Branch Purchase Coordinator Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BranchPurchaseCoordinatorScreen(),
                  ),
                );
                // Already on Branch Purchase Coordinator Dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Branch Sales Coordinator'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BranchSalesCoordinatorScreen(),
                  ),
                );
                // Already on Branch Purchase Coordinator Dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Branch Sales Head'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BranchSalesHeadScreen(),
                  ),
                );
                // Already on Branch Purchase Coordinator Dashboard
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Regional Sales Head'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegionalPurchaseLeadScreen(),
                  ),
                );
                // Already on Branch Purchase Coordinator Dashboard
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        toolbarHeight: SizeConfig.h(100),
        flexibleSpace: Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: SizeConfig.h(8),
          ),
          color: Colors.green.shade700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Vishal Sharma",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.w(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.h(4)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "BID: XN12",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: SizeConfig.w(14),
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.h(4)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Reporting: Anjali Mehera",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: SizeConfig.w(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.bell,
                    color: Colors.white,
                    size: SizeConfig.w(24),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: SizeConfig.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Revenue Card
            _buildInfoCard(
              "Today's Revenue",
              "₹2,45,000",
              "+15.2%",
              Icons.attach_money,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Customers Served Card
            _buildInfoCard(
              "Customers Served",
              "156",
              "+8.5%",
              Icons.people_alt,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Units Sold Card
            _buildInfoCard(
              "Units Sold",
              "324",
              "+22.1%",
              Icons.shopping_cart,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // My Incentive Card
            _buildInfoCard(
              "My Incentive",
              "₹28,500",
              "81.4% of target",
              Icons.trending_up,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // // Article-wise Search & Stock View
            // _buildArticleSearchStockView(context),
            // SizedBox(height: SizeConfig.h(16)),

            // Sales Comparison Card
            _buildSalesComparisonCard(),
            SizedBox(height: SizeConfig.h(16)),

            // Category-wise Sales Card
            _buildCategoryWiseSalesCard(),
            SizedBox(height: SizeConfig.h(16)),

            // My Branch Performance Card
            _buildMyBranchPerformanceCard(),
            SizedBox(height: SizeConfig.h(16)),
            // Promise vs Actual Section
            // _buildPromiseVsActual(),
            SizedBox(height: SizeConfig.h(16)),

            // Customer Analytics Card
            _buildCustomerAnalyticsCard(),
            SizedBox(height: SizeConfig.h(16)),
          ],
        ),
      ),
    );
  }

  // Widget _buildPromiseVsActual() {
  //   final List<Map<String, dynamic>> staticDailyValues = [
  //     {
  //       "date": DateFormat(
  //         'MMM yyyy',
  //       ).format(DateTime(DateTime.now().year, DateTime.now().month, 21)),
  //       "day": "Sun",
  //       "promise": 600000.0,
  //       "actual": 580000.0,
  //     },
  //     {
  //       "date": DateFormat(
  //         'MMM yyyy',
  //       ).format(DateTime(DateTime.now().year, DateTime.now().month, 22)),
  //       "day": "Mon",
  //       "promise": 620000.0,
  //       "actual": 630000.0,
  //     },
  //     {
  //       "date": DateFormat(
  //         'MMM yyyy',
  //       ).format(DateTime(DateTime.now().year, DateTime.now().month, 23)),
  //       "day": "Tue",
  //       "promise": 590000.0,
  //       "actual": 550000.0,
  //     },
  //     {
  //       "date": DateFormat(
  //         'MMM yyyy',
  //       ).format(DateTime(DateTime.now().year, DateTime.now().month, 24)),
  //       "day": "Wed",
  //       "promise": 610000.0,
  //       "actual": 610000.0,
  //     },
  //     {
  //       "date": DateFormat(
  //         'MMM yyyy',
  //       ).format(DateTime(DateTime.now().year, DateTime.now().month, 25)),
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
  //         'dd MMM yyyy',
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
  //                   child: Text(
  //                     "No promise vs actual data for this month.",
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.w(16),
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 )
  //               : ScrollConfiguration(
  //                   behavior: ScrollConfiguration.of(
  //                     context,
  //                   ).copyWith(scrollbars: false),
  //                   child: ListView.separated(
  //                     scrollDirection: Axis.horizontal,
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: SizeConfig.w(10),
  //                     ),
  //                     itemCount: currentData.length,
  //                     separatorBuilder: (_, __) =>
  //                         SizedBox(width: SizeConfig.w(10)),
  //                     itemBuilder: (context, index) {
  //                       final item = currentData[index];
  //                       final percent = item['percent'] as int;
  //                       final color = percent >= 100
  //                           ? Colors.green
  //                           : percent >= 80
  //                           ? Colors.orange
  //                           : Colors.red;
  //
  //                       return _buildDailyPromiseActualCard(item, color);
  //                     },
  //                   ),
  //                 ),
  //         ),
  //         SizedBox(height: SizeConfig.h(16)),
  //         // Total Promise vs Actual Card
  //         // Card(
  //         //   elevation: 2,
  //         //   shape: RoundedRectangleBorder(
  //         //     borderRadius: BorderRadius.circular(12),
  //         //   ),
  //         //   child: Padding(
  //         //     padding: EdgeInsets.all(SizeConfig.w(16)),
  //         //     child: Column(
  //         //       crossAxisAlignment: CrossAxisAlignment.start,
  //         //       children: [
  //         //         Text(
  //         //           "Overall Promise vs Actual",
  //         //           style: TextStyle(
  //         //             fontSize: SizeConfig.w(18),
  //         //             fontWeight: FontWeight.bold,
  //         //           ),
  //         //         ),
  //         //         SizedBox(height: SizeConfig.h(12)),
  //         //         Row(
  //         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //           children: [
  //         //             Column(
  //         //               crossAxisAlignment: CrossAxisAlignment.start,
  //         //               children: [
  //         //                 Text(
  //         //                   "Total Promise",
  //         //                   style: TextStyle(
  //         //                     fontSize: SizeConfig.w(14),
  //         //                     color: Colors.grey[700],
  //         //                   ),
  //         //                 ),
  //         //                 SizedBox(height: SizeConfig.h(4)),
  //         //                 Text(
  //         //                   "₹${totalPromise.toStringAsFixed(2)}",
  //         //                   style: TextStyle(
  //         //                     fontSize: SizeConfig.w(18),
  //         //                     fontWeight: FontWeight.bold,
  //         //                   ),
  //         //                 ),
  //         //               ],
  //         //             ),
  //         //             Column(
  //         //               crossAxisAlignment: CrossAxisAlignment.end,
  //         //               children: [
  //         //                 Text(
  //         //                   "Total Actual",
  //         //                   style: TextStyle(
  //         //                     fontSize: SizeConfig.w(14),
  //         //                     color: Colors.grey[700],
  //         //                   ),
  //         //                 ),
  //         //                 SizedBox(height: SizeConfig.h(4)),
  //         //                 Text(
  //         //                   "₹${totalActual.toStringAsFixed(2)}",
  //         //                   style: TextStyle(
  //         //                     fontSize: SizeConfig.w(18),
  //         //                     fontWeight: FontWeight.bold,
  //         //                   ),
  //         //                 ),
  //         //               ],
  //         //             ),
  //         //           ],
  //         //         ),
  //         //         SizedBox(height: SizeConfig.h(12)),
  //         //         Container(
  //         //           width: double.infinity,
  //         //           padding: EdgeInsets.symmetric(vertical: SizeConfig.h(8)),
  //         //           decoration: BoxDecoration(
  //         //             color: totalColor.withOpacity(0.15),
  //         //             borderRadius: BorderRadius.circular(8),
  //         //           ),
  //         //           child: Center(
  //         //             child: Text(
  //         //               "Overall Achievement: $totalPercent%",
  //         //               style: TextStyle(
  //         //                 color: totalColor,
  //         //                 fontWeight: FontWeight.bold,
  //         //                 fontSize: SizeConfig.w(16),
  //         //               ),
  //         //             ),
  //         //           ),
  //         //         ),
  //         //       ],
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDailyPromiseActualCard(Map<String, dynamic> item, Color color) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: SizeConfig.w(160), // Adjust width as needed
        padding: EdgeInsets.all(SizeConfig.w(6)),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  item['date'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.w(14),
                  ),
                ),
                SizedBox(height: SizeConfig.h(2)),
                Text(
                  item['day'] as String,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.w(10),
                  ),
                ),
              ],
            ),
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
            Container(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(3.2)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  "${item['percent']}%",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.w(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String subText,
    IconData icon, {
    bool isPositive = true,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(16)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.w(10)),
              decoration: BoxDecoration(
                color: isPositive ? Colors.blue.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isPositive ? Colors.blue.shade800 : Colors.red.shade800,
                size: SizeConfig.w(24),
              ),
            ),
            SizedBox(width: SizeConfig.w(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: SizeConfig.w(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(8)),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: SizeConfig.w(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(4)),
                  Text(
                    subText,
                    style: TextStyle(
                      fontSize: SizeConfig.w(13),
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(8),
                    vertical: SizeConfig.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Limited Access",
                    style: TextStyle(
                      fontSize: SizeConfig.w(12),
                      color: Colors.grey[700],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today",
                        style: TextStyle(
                          fontSize: SizeConfig.w(14),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "₹2,45,000",
                        style: TextStyle(
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yesterday",
                        style: TextStyle(
                          fontSize: SizeConfig.w(14),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "₹2,12,000",
                        style: TextStyle(
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(12)),
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: SizeConfig.w(16),
                ),
                SizedBox(width: SizeConfig.w(4)),
                Text(
                  "+15.6% vs yesterday (₹33,000)",
                  style: TextStyle(
                    fontSize: SizeConfig.w(13),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryWiseSalesCard() {
    final List<Map<String, dynamic>> categories = [
      {"name": "Electronics", "percentage": 35, "value": "₹125,000"},
      {"name": "Clothing", "percentage": 27, "value": "₹95,000"},
      {"name": "Home & Garden", "percentage": 19, "value": "₹68,000"},
      {"name": "Books", "percentage": 12, "value": "₹42,000"},
      {"name": "Sports", "percentage": 7, "value": "₹25,000"},
    ];

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
                      Icons.bar_chart,
                      size: SizeConfig.w(20),
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "Category-wise Sales",
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
                  child: Text(
                    "Limited Access",
                    style: TextStyle(
                      fontSize: SizeConfig.w(12),
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
                  "Total: ₹355,000",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(12)),
            ...categories.map((category) {
              return Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.h(8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category["name"] as String,
                          style: TextStyle(fontSize: SizeConfig.w(14)),
                        ),
                        Text(
                          "${category["percentage"] as int}% ${category["value"] as String}",
                          style: TextStyle(
                            fontSize: SizeConfig.w(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.h(4)),
                    LinearProgressIndicator(
                      value: (category["percentage"] as int) / 100,
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
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMyBranchPerformanceCard() {
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
                      Icons.apartment,
                      size: SizeConfig.w(20),
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: SizeConfig.w(8)),
                    Text(
                      "My Branch Performance",
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
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Own Branch",
                    style: TextStyle(
                      fontSize: SizeConfig.w(12),
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(16)),
            Container(
              padding: EdgeInsets.all(SizeConfig.w(12)),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: SizeConfig.w(18),
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: SizeConfig.w(8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mumbai Central Branch",
                        style: TextStyle(
                          fontSize: SizeConfig.w(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Code: MBC-001",
                        style: TextStyle(
                          fontSize: SizeConfig.w(12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Sales",
                        style: TextStyle(
                          fontSize: SizeConfig.w(14),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "₹2,45,000",
                        style: TextStyle(
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Month to Date",
                        style: TextStyle(
                          fontSize: SizeConfig.w(14),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "₹3,250,000",
                        style: TextStyle(
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(16)),
            Text(
              "Monthly Target Progress",
              style: TextStyle(
                fontSize: SizeConfig.w(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: SizeConfig.h(4)),
            LinearProgressIndicator(
              value: 0.813, // 81.3%
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
              minHeight: SizeConfig.h(10),
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: SizeConfig.h(4)),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "81.3%",
                style: TextStyle(
                  fontSize: SizeConfig.w(14),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Text(
              "Remaining: ₹750,000",
              style: TextStyle(
                fontSize: SizeConfig.w(13),
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),
            Row(
              children: [
                Icon(
                  Icons.group,
                  size: SizeConfig.w(16),
                  color: Colors.grey[600],
                ),
                SizedBox(width: SizeConfig.w(8)),
                Text(
                  "Team Size: 12",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(width: SizeConfig.w(24)),
                Icon(
                  Icons.people_alt,
                  size: SizeConfig.w(16),
                  color: Colors.grey[600],
                ),
                SizedBox(width: SizeConfig.w(8)),
                Text(
                  "Customers Today: 156",
                  style: TextStyle(
                    fontSize: SizeConfig.w(14),
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
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
              value: 0.13, // 13% for new, so remaining is repeat
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
