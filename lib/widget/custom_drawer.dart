import 'package:flutter/material.dart';

import '../screen/sales/stafInBranch/billingManager.dart';
import '../screen/sales/stafInBranch/salesAgentScreen.dart';
import '../screen/sales/stafNotInBranch/purchase/branchPurchaseCoordinator.dart';
import '../screen/sales/stafNotInBranch/purchase/purchaseHead.dart';
import '../screen/sales/stafNotInBranch/sales/branchSalesCoordinator.dart';
import '../screen/sales/stafNotInBranch/sales/branchSalesHead.dart';
import '../screen/sales/stafNotInBranch/sales/regionalSalesHeadScreen.dart';

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

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // Initialize SizeConfig here

    return Drawer(
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
          // ListTile(
          //   leading: const Icon(Icons.business),
          //   title: const Text('Branch Manager Dashboard'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const BranchManagerScreen(),
          //       ),
          //     );
          //   },
          // ),
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
                MaterialPageRoute(
                  builder: (context) => const SalesAgentScreen(),
                ),
              );
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
          // ListTile(
          //   leading: const Icon(Icons.leaderboard),
          //   title: const Text('Regional Purchase Lead Dashboard'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const RegionalPurchaseLeadScreen(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: const Text('Branch Purchase Coordinator Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BranchPurchaseCoordinatorScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Branch Sales Head Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BranchSalesHeadScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Branch Sales Coordinator Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BranchSalesCoordinatorScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.area_chart),
            title: const Text('Regional Sales Head Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegionalSalesHeadScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
