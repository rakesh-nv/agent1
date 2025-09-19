import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mbindiamy/widget/custom_drawer.dart';

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

class BranchSalesHeadScreen extends StatefulWidget {
  const BranchSalesHeadScreen({super.key});

  @override
  State<BranchSalesHeadScreen> createState() => _BranchSalesHeadScreenState();
}

class _BranchSalesHeadScreenState extends State<BranchSalesHeadScreen> {
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
      drawer: const CustomDrawer(), // Use the new CustomDrawer widget

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
            Text(
              "Regional sales performance and branch oversight",
              style: TextStyle(
                fontSize: SizeConfig.w(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),
            SizedBox(height: SizeConfig.h(16)),

            // Sales Comparison (Today vs Yesterday) Card
            _buildInfoCard(
              "Total Sales Amount(Today)",
              "4,52,850",
              "+8.3% vs Yesterday",
              Icons.compare_arrows,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Customers Served Card
            _buildInfoCard(
              "Unit Sold(Today)",
              "15,000",
              "+1,200 new this month",
              Icons.people_alt,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Category-wise Sales Card
            _buildInfoCard(
              "Total Incentive(Today)",
              "28,450",
              "+1,200 new this month",
              Icons.category,
              isPositive: true,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // // Article-wise Search & Stock View
            // _buildArticleSearchStockView(context),
            // SizedBox(height: SizeConfig.h(16)),
            // // Existing Quick Actions Section
            // _buildQuickActions(context),
            // SizedBox(height: SizeConfig.h(16)),
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
                      fontSize: SizeConfig.w(24),
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
}
