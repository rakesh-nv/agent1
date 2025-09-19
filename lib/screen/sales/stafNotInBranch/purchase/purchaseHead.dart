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

class PurchaseHeadScreen extends StatefulWidget {
  const PurchaseHeadScreen({super.key});

  @override
  State<PurchaseHeadScreen> createState() => _PurchaseHeadScreenState();
}

class _PurchaseHeadScreenState extends State<PurchaseHeadScreen> {
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
              "Overview of procurement metrics and supplier performance",
              style: TextStyle(
                fontSize: SizeConfig.w(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Total Procurement Card
            _infoCard(
              "Total Procurement",
              "\$12.8M",
              Icons.trending_up,
              Colors.blue.shade100,
              Colors.blue.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Global Suppliers Card
            _infoCard(
              "Global Suppliers",
              "284",
              Icons.language,
              Colors.green.shade100,
              Colors.green.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Cost Savings Card
            _infoCard(
              "Cost Savings",
              "\$2.1M",
              Icons.emoji_events,
              Colors.purple.shade100,
              Colors.purple.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Compliance Score Card
            _infoCard(
              "Compliance Score",
              "98%",
              Icons.shield,
              Colors.orange.shade100,
              Colors.orange.shade800,
            ),
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
}
