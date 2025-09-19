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

class RegionalSalesHeadScreen extends StatefulWidget {
  const RegionalSalesHeadScreen({super.key});

  @override
  State<RegionalSalesHeadScreen> createState() =>
      _RegionalSalesHeadScreenState();
}

class _RegionalSalesHeadScreenState extends State<RegionalSalesHeadScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      body: Container(),
    );
  }

  // Widget for Quick Actions section
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        "label": "Regional Reports",
        "description": "Approve regional summaries",
        "icon": Icons.grading_outlined,
      },
      {
        "label": "Manage Coordinators",
        "description": "Oversee coordinator performance",
        "icon": Icons.group_add_outlined,
      },
      {
        "label": "Market Insights",
        "description": "View market analysis",
        "icon": Icons.insights_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: SizeConfig.w(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.h(16)),
        ...actions
            .map(
              (action) => _buildQuickActionButton(
                action["label"] as String,
                action["description"] as String,
                action["icon"] as IconData,
              ),
            )
            .toList(),
      ],
    );
  }

  // Helper widget for individual quick action buttons
  Widget _buildQuickActionButton(
    String label,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: SizeConfig.h(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle action tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(16)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.w(10)),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue.shade800,
                  size: SizeConfig.w(24),
                ),
              ),
              SizedBox(width: SizeConfig.w(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: SizeConfig.w(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(4)),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: SizeConfig.w(13),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: SizeConfig.w(16),
              ),
            ],
          ),
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
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.h(16)),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                    Text(
                      "Article A",
                      style: TextStyle(fontSize: SizeConfig.w(14)),
                    ),
                    Text(
                      "150 units",
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
                    Text(
                      "Article B",
                      style: TextStyle(fontSize: SizeConfig.w(14)),
                    ),
                    Text(
                      "230 units",
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
}
