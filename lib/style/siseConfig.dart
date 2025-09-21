import 'package:flutter/cupertino.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double baseDimension; // Use the shorter side as base
  static late bool isPortrait;
  static late bool isMobile;
  static late bool isTablet;
  static late bool isDesktop;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    isPortrait = screenWidth < screenHeight;
    baseDimension = isPortrait ? screenWidth : screenHeight; // Use shorter side
    isMobile = baseDimension < 600;
    isTablet = baseDimension >= 600 && baseDimension < 1024;
    isDesktop = baseDimension >= 1024;
  }

  static double w(double width) => baseDimension * (width / 375); // Scale based on base
  static double h(double height) => baseDimension * (height / 812); // Scale based on base
}