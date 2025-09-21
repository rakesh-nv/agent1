import 'package:flutter/material.dart';
import 'package:mbindiamy/style/appstyle.dart';

import '../branch/stafInBranch/billingManager.dart'; // Assuming SizeConfig is defined here

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userId;
  final String? reportingTo;
  final bool showUserId;
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.userId,
    this.reportingTo,
    this.showUserId = true,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize SizeConfig if not already done
    SizeConfig.init(context);
    final appStyle = AppStyle(context);
    final isLandscape = SizeConfig.screenWidth > SizeConfig.screenHeight;
    final paddingTop = SizeConfig.h(isLandscape ? 20 : 45); // Reduced top padding in landscape
    final paddingHorizontal = appStyle.defaultPadding;
    final paddingBottom = SizeConfig.h(isLandscape ? 10 : 20);

    return Container(
      padding: EdgeInsets.only(
        top: paddingTop,
        left: paddingHorizontal,
        right: paddingHorizontal,
        bottom: paddingBottom,
      ),
      decoration: BoxDecoration(color: AppStyle.appBarColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: AppStyle.appBarTextColor,
                  size: SizeConfig.w(isLandscape ? 20 : 24), // Responsive icon size
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              SizedBox(width: SizeConfig.w(8)), // Consistent spacing
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: AppStyle.headTextStyle().copyWith(
                      color: AppStyle.appBarTextColor,
                      fontSize: SizeConfig.w(AppStyle.headFontSize * (isLandscape ? 0.7 : 0.8)).clamp(14, 20), // Clamped for landscape
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showUserId)
                    Text(
                      userId,
                      style: AppStyle.normalTextStyle().copyWith(
                        color: AppStyle.appBarTextColor,
                        fontSize: SizeConfig.w(AppStyle.normalFontSize * (isLandscape ? 0.5 : 0.6)).clamp(10, 14), // Clamped for landscape
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (reportingTo != null && reportingTo!.isNotEmpty)
                    Text(
                      'Reporting To: $reportingTo',
                      style: AppStyle.normalTextStyle().copyWith(
                        color: AppStyle.appBarTextColor,
                        fontSize: SizeConfig.w(AppStyle.normalFontSize * (isLandscape ? 0.6 : 0.7)).clamp(10, 14), // Clamped for landscape
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppStyle.appBarTextColor,
              size: SizeConfig.w(isLandscape ? 20 : 24), // Responsive icon size
            ),
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(SizeConfig.h(120)); // Dynamic height based on orientation
}