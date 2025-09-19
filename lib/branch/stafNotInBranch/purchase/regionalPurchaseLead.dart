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

class RegionalPurchaseLeadScreen extends StatefulWidget {
  const RegionalPurchaseLeadScreen({super.key});

  @override
  State<RegionalPurchaseLeadScreen> createState() =>
      _RegionalPurchaseLeadScreenState();
}

class _RegionalPurchaseLeadScreenState
    extends State<RegionalPurchaseLeadScreen> {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: SizeConfig.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Regional operations overview",
              style: TextStyle(
                fontSize: SizeConfig.w(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Regional Staff Card
            _infoCard(
              "Regional Staff",
              "45",
              Icons.people,
              Colors.blue.shade100,
              Colors.blue.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Active Branches Card
            _infoCard(
              "Active Branches",
              "12",
              Icons.business,
              Colors.green.shade100,
              Colors.green.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Monthly Budget Card
            _infoCard(
              "Monthly Budget",
              "\$2.4M",
              Icons.attach_money,
              Colors.purple.shade100,
              Colors.purple.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Performance Card
            _infoCard(
              "Performance",
              "94%",
              Icons.track_changes,
              Colors.orange.shade100,
              Colors.orange.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Management Actions Section
            _buildManagementActions(context),
            SizedBox(height: SizeConfig.h(16)),
          ],
        ),
      ),
    );
  }

  // Helper widget for info cards (simplified for this dashboard)
  Widget _infoCard(
    String title,
    String value,
    IconData icon,
    Color iconBgColor,
    Color iconColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(16)),
        child: Row(
          children: [
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
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(SizeConfig.w(8)),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: SizeConfig.w(24)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Management Actions section
  Widget _buildManagementActions(BuildContext context) {
    final actions = [
      {"label": "Approve Purchase Orders", "icon": Icons.check_circle},
      {"label": "Review Vendor Contracts", "icon": Icons.assignment},
      {"label": "Monitor Budget Usage", "icon": Icons.money},
      {"label": "Generate Performance Report", "icon": Icons.description},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Management Actions",
          style: TextStyle(
            fontSize: SizeConfig.w(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.h(16)),
        ...actions
            .map(
              (action) => _buildManagementActionButton(
                action["label"] as String,
                action["icon"] as IconData,
              ),
            )
            .toList(),
      ],
    );
  }

  // Helper widget for individual management action buttons
  Widget _buildManagementActionButton(String label, IconData icon) {
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
              Icon(icon, color: Colors.blue.shade800, size: SizeConfig.w(24)),
              SizedBox(width: SizeConfig.w(16)),
              Text(
                label,
                style: TextStyle(
                  fontSize: SizeConfig.w(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
