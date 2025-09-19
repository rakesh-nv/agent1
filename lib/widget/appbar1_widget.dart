import 'package:flutter/material.dart';
import 'package:mbindiamy/style/appstyle.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationPressed;

  const CustomAppBar1({
    super.key,
    required this.title,
    this.onNotificationPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppStyle.h(120)); // Use AppStyle for responsive height

  @override
  Widget build(BuildContext context) {
    // Initialize AppStyle
    AppStyle.init(context);

    return Container(
      padding: EdgeInsets.only(
        top: AppStyle.h(40),
        left: AppStyle.w(16),
        right: AppStyle.w(16),
        bottom: AppStyle.h(20),
      ),
      decoration: BoxDecoration(
        color:Colors.blue, // Use AppStyle color
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(30),
        //   bottomRight: Radius.circular(30),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: AppStyle.appBarTextColor, // Use AppStyle color
                  size: AppStyle.w(24), // Responsive icon size
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              Text(
                title,
                style: AppStyle.headTextStyle().copyWith(
                  color: AppStyle.appBarTextColor, // Use AppStyle color
                  fontSize: AppStyle.headFontSize * 0.9, // Slightly smaller than headFontSize
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppStyle.appBarTextColor, // Use AppStyle color
              size: AppStyle.w(24), // Responsive icon size
            ),
            onPressed: onNotificationPressed ?? () {},
          ),
        ],
      ),
    );
  }
}