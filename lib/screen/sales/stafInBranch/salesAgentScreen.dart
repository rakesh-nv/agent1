import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

class SalesAgentScreen extends StatefulWidget {
  const SalesAgentScreen({super.key});

  @override
  State<SalesAgentScreen> createState() => _SalesAgentScreenState();
}

class _SalesAgentScreenState extends State<SalesAgentScreen> {
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
          padding: EdgeInsets.only(left: 5),
          color: Colors.green.shade700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vishal Sharma",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "BID: XN12",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeConfig.w(14),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(4)),
                      Text(
                        "Reporting: Anjali Mehera",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: SizeConfig.w(14),
                        ),
                      ),
                    ],
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
            // Sales Info Cards
            Column(
              children: [
                _buildSalesInfoCard(
                  "Total Sell Amount",
                  "₹45,520",
                  "(24/7/2025)",
                  Icons.currency_rupee,
                  Colors.green.shade50,
                  Colors.green,
                ),
                SizedBox(height: SizeConfig.h(10)), // Vertical spacing
                _buildSalesInfoCard(
                  "Total Sell Quantity",
                  "156 units",
                  "(24/7/2025)",
                  Icons.shopping_cart,
                  Colors.blue.shade50,
                  Colors.blue,
                ),
                SizedBox(height: SizeConfig.h(10)), // Vertical spacing
                _buildSalesInfoCard(
                  "My Incentive",
                  "₹2,850",
                  "(24/7/2025)",
                  Icons.trending_up,
                  Colors.orange.shade50,
                  Colors.orange,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Sales Comparison Card
            _buildSalesComparisonCard(),
            SizedBox(height: SizeConfig.h(16)),

            // Category-wise Sales Card
            _buildCategoryWiseSalesCard(),
            SizedBox(height: SizeConfig.h(16)),

            // My Incentive Card
            _buildIncentiveViewCard(),
            SizedBox(height: SizeConfig.h(16)),

            // Article-wise Search & Stock View
            _buildArticleSearchStockView(context),
            SizedBox(height: SizeConfig.h(16)),
          ],
        ),
      ),
    );
  }
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
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Sales Comparison",
                        style: TextStyle(
                          fontSize: SizeConfig.w(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                  "Sales Agent",
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
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Today",
                          style: TextStyle(
                            fontSize: SizeConfig.w(14),
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(4)),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "₹45,520", // Adjusted static value for sales agent
                        style: TextStyle(
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Yesterday",
                          style: TextStyle(
                            fontSize: SizeConfig.w(14),
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(4)),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "₹42,100", // Adjusted static value for sales agent
                        style: TextStyle(
                          fontSize: SizeConfig.w(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
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
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "+8.1% vs yesterday (₹3,420)", // Adjusted static value
                    style: TextStyle(
                      fontSize: SizeConfig.w(13),
                      color: Colors.green,
                    ),
                  ),
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
    {"name": "Electronics", "percentage": 30, "value": "₹13,656"},
    {"name": "Clothing", "percentage": 25, "value": "₹11,380"},
    {"name": "Home & Garden", "percentage": 20, "value": "₹9,120"},
    {"name": "Books", "percentage": 15, "value": "₹6,840"},
    {"name": "Sports", "percentage": 10, "value": "₹4,560"},
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
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Category-wise Sales",
                        style: TextStyle(
                          fontSize: SizeConfig.w(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                  "Sales Agent",
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
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Total: ₹45,556", // Adjusted static value
                    style: TextStyle(
                      fontSize: SizeConfig.w(14),
                      color: Colors.grey[800],
                    ),
                  ),
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
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            category["name"] as String,
                            style: TextStyle(fontSize: SizeConfig.w(14)),
                          ),
                        ),
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

Widget _buildIncentiveViewCard() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.w(16)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.w(10)),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.trending_up,
              color: Colors.orange.shade800,
              size: SizeConfig.w(24),
            ),
          ),
          SizedBox(width: SizeConfig.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Incentive",
                  style: TextStyle(
                    fontSize: SizeConfig.w(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: SizeConfig.h(8)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "₹2,850",
                    style: TextStyle(
                      fontSize: SizeConfig.w(20),
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(4)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "75% of target",
                    style: TextStyle(
                      fontSize: SizeConfig.w(13),
                      color: Colors.orange,
                    ),
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

Widget _buildArticleSearchStockView(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Article-wise Search & Stock View",
        style: TextStyle(
          fontSize: SizeConfig.w(20),
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: SizeConfig.h(16)),
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search for Articles",
                style: TextStyle(
                  fontSize: SizeConfig.w(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: SizeConfig.h(8)),
              CupertinoSearchTextField(
                placeholder: "Enter article name or code",
                onChanged: (value) {
                  // Handle search input
                },
              ),
              SizedBox(height: SizeConfig.h(16)),
              // Static stock data example
              Text(
                "Current Stock (Example)",
                style: TextStyle(
                  fontSize: SizeConfig.w(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: SizeConfig.h(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Article A",
                        style: TextStyle(fontSize: SizeConfig.w(14)),
                      ),
                    ),
                  ),
                  Text(
                    "75 units", // Adjusted static value for sales agent
                    style: TextStyle(
                      fontSize: SizeConfig.w(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Article B",
                        style: TextStyle(fontSize: SizeConfig.w(14)),
                      ),
                    ),
                  ),
                  Text(
                    "110 units", // Adjusted static value for sales agent
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
      ),
    ],
  );
}

Widget _buildSalesInfoCard(
  String title,
  String value,
  String date,
  IconData icon,
  Color bgColor,
  Color iconColor,
) {
  return Card(
    color: bgColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(SizeConfig.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: SizeConfig.w(12),
                  color: Colors.grey[700],
                ),
              ),
              Icon(icon, size: SizeConfig.w(18), color: iconColor),
            ],
          ),
          SizedBox(height: SizeConfig.h(8)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: SizeConfig.w(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.h(4)),
          Text(
            date,
            style: TextStyle(
              fontSize: SizeConfig.w(10),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ),
  );
}
