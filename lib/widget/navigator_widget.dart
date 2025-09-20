import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 🔹 Screens
import 'package:mbindiamy/screen/sales/sales_dashboard_screen.dart';
import 'package:mbindiamy/screen/profile.dart';

import 'package:mbindiamy/screen/login.dart';
import 'package:mbindiamy/screen/sales/stafNotInBranch/purchase/regional_purchase_head_dashboard.dart';
import 'package:mbindiamy/screen/sales/stafNotInBranch/regional_manager_dashboard.dart';
import 'package:mbindiamy/screen/sales/stafInBranch/branch_manager_dashboard.dart';

// 🔹 Utils
import 'package:mbindiamy/style/appstyle.dart';
import 'package:mbindiamy/utils/app_constants.dart';

// 🔹 Controllers
import 'package:mbindiamy/controllers/login_controller.dart';

import '../screen/businessHead/business_head_dashboard.dart';

class MenuItem {
  final String label;
  final IconData icon;
  final Widget route;
  final String routeName;
  final List<MenuItem>? children;

  MenuItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.routeName,
    this.children,
  });
}

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({super.key});

  final ScrollController _scrollController = ScrollController();
  static const double _kDrawerWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    AppStyle.init(context);
    final appStyle = AppStyle(context);

    // ✅ Static menu items
    final List<MenuItem> menuItems = [
      MenuItem(
        label: 'Dashboard',
        icon: Icons.dashboard,
        route: const SalesAgentDashBoard(), // Default placeholder
        routeName: 'Dashboard',
      ),
      MenuItem(
        label: 'Profile',
        icon: Icons.person,
        route: const ProfileScreen(),
        routeName: 'Profile',
      ),
    ];

    final bool isDesktop = AppStyle.isDesktop;

    final Widget drawerContent = Column(
      children: [
        SizedBox(
          height: AppStyle.screenHeight * 0.15,
          child: DrawerHeader(
            decoration: BoxDecoration(color: AppStyle.backgroundColor),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Menu',
                style: AppStyle.headTextStyle().copyWith(
                  color: AppStyle.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: menuItems.map((item) {
                if (item.children?.isNotEmpty ?? false) {
                  return _buildExpandableSection(context, item, appStyle);
                } else {
                  return _buildNavTile(context, item, appStyle);
                }
              }).toList(),
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: EdgeInsets.only(bottom: AppStyle.h(40)),
          child: Builder(
            builder: (BuildContext logoutContext) {
              final LoginController loginController = Get.find();
              return ListTile(
                leading: Icon(Icons.logout, size: AppStyle.w(24)),
                title: Text('Logout', style: AppStyle.normalTextStyle()),
                onTap: () async {
                  await loginController.logout();
                  if (!isDesktop && Navigator.canPop(logoutContext)) {
                    Navigator.pop(logoutContext);
                  }
                  ScaffoldMessenger.of(logoutContext).showSnackBar(
                    SnackBar(
                      content: Text('Logged out successfully', style: AppStyle.normalTextStyle()),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
    return isDesktop
        ? SizedBox(
            width: _kDrawerWidth,
            child: Drawer(backgroundColor: AppStyle.backgroundColor, child: drawerContent),
          )
        : Drawer(backgroundColor: AppStyle.backgroundColor, child: drawerContent);
  }
  /// 🔹 Navigation Tile
  Widget _buildNavTile(BuildContext context, MenuItem item, AppStyle appStyle) {
    return ListTile(
      leading: Icon(item.icon, size: AppStyle.w(24)),
      title: Text(item.label, style: AppStyle.normalTextStyle()),
      onTap: () async {
        if (!AppStyle.isDesktop && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // ✅ Handle Dashboard redirection based on grade
        if (item.label == "Dashboard") {
          final box = Hive.box('myBox');
          final userGrade = box.get(AppConstants.userGrade);
          print("User Grade: $userGrade");
          switch (userGrade) {
            case "Grade 1":
              Get.offAll(() => const BusinessHeadDashboard());
              break;
            case "Grade 2":
              Get.offAll(() => const RegionalPurchaseHeadDashboard());
              break;
            case "Grade 3":
              Get.offAll(() => const BranchManagerDashboard());
              break;
            case "Grade 4":
              Get.offAll(() => const SalesAgentDashBoard());
              break;
            case "Grade 5":
              Get.offAll(() => const SalesAgentDashBoard());
              break;
            case "Grade 6":
              Get.offAll(() => const SalesAgentDashBoard());
              break;
            case "Grade 7":
              Get.offAll(() => const SalesAgentDashBoard());
              break;
            default:
              Get.offAll(() => const LoginScreen());
          }
        } else {
          // Normal navigation
          Navigator.push(context, MaterialPageRoute(builder: (_) => item.route));
        }
      },
    );
  }

  /// 🔹 Expandable Section
  Widget _buildExpandableSection(BuildContext context, MenuItem item, AppStyle appStyle) {
    return ExpansionTile(
      leading: Icon(item.icon, size: AppStyle.w(24)),
      title: Text(item.label, style: AppStyle.normalTextStyle()),
      children: (item.children ?? []).map((childItem) {
        return _buildTile(context, childItem, appStyle);
      }).toList(),
    );
  }

  /// 🔹 Sub-menu Tile
  Widget _buildTile(BuildContext context, MenuItem item, AppStyle appStyle) {
    return Padding(
      padding: EdgeInsets.only(left: AppStyle.w(16)),
      child: ListTile(
        leading: Icon(item.icon, size: AppStyle.w(20)),
        title: Text(
          item.label,
          style: AppStyle.normalTextStyle().copyWith(fontSize: AppStyle.w(14)),
        ),
        onTap: () {
          if (!AppStyle.isDesktop && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => item.route));
        },
      ),
    );
  }
}
