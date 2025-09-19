import 'package:flutter/material.dart';
import 'package:mbindiamy/style/appstyle.dart';

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
    final appStyle = AppStyle(context);
    return Container(
      padding: EdgeInsets.only(
        top: AppStyle.h(45),
        left: appStyle.defaultPadding,
        right: appStyle.defaultPadding,
        bottom: AppStyle.h(20),
      ),
      decoration: BoxDecoration(color:AppStyle.appBarColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: AppStyle.appBarTextColor),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: AppStyle.headTextStyle().copyWith(
                      color: AppStyle.appBarTextColor,
                      fontSize: AppStyle.headFontSize * 0.8,
                    ),
                  ),
                  if (showUserId)
                    Text(
                      userId,
                      style: AppStyle.normalTextStyle().copyWith(
                        color: AppStyle.appBarTextColor,
                        fontSize: AppStyle.normalFontSize * 0.8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (reportingTo != null && reportingTo!.isNotEmpty)
                    Text(
                      'Reporting To: $reportingTo',
                      style: AppStyle.normalTextStyle().copyWith(
                        color: AppStyle.appBarTextColor,
                        fontSize: AppStyle.normalFontSize * 0.7,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: AppStyle.appBarTextColor),
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppStyle.h(120));
}
