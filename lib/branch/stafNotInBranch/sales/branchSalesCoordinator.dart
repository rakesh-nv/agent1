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

class BranchSalesCoordinatorScreen extends StatefulWidget {
  const BranchSalesCoordinatorScreen({super.key});

  @override
  State<BranchSalesCoordinatorScreen> createState() =>
      _BranchSalesCoordinatorScreenState();
}

class _BranchSalesCoordinatorScreenState
    extends State<BranchSalesCoordinatorScreen> {
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
        toolbarHeight: SizeConfig.h(150),
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
              "Sales department overview and coordination",
              style: TextStyle(
                fontSize: SizeConfig.w(14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Daily Orders Card
            _infoCard(
              "Daily Orders",
              "147",
              Icons.calendar_today,
              Colors.blue.shade100,
              Colors.blue.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Pending Approvals Card
            _infoCard(
              "Pending Approvals",
              "12",
              Icons.schedule,
              Colors.orange.shade100,
              Colors.orange.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Active Agents Card
            _infoCard(
              "Active Agents",
              "36",
              Icons.people,
              Colors.green.shade100,
              Colors.green.shade800,
            ),
            SizedBox(height: SizeConfig.h(16)),

            // Quick Actions Section
            _buildQuickActions(context),
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
      elevation: 2,
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

  // Widget for Quick Actions section
  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        "label": "Assign Tasks",
        "description": "Delegate work to agents",
        "icon": Icons.person_add_alt_1,
      },
      {
        "label": "Approve Orders",
        "description": "Review pending orders",
        "icon": Icons.check_circle_outline,
      },
      {
        "label": "Track Deliveries",
        "description": "Monitor delivery status",
        "icon": Icons.location_on,
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
      elevation: 2,
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
}
