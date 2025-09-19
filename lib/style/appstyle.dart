import 'package:flutter/material.dart';

class AppStyle {
  static late double _screenWidth;
  static late double _screenHeight;

  // Default font sizes before initialization
  static double headFontSize = 22.0;
  static double normalFontSize = 16.0;

  static final Color appBarColor = const Color(0xFFC83D15);

  
  static final Color backgroundColor = const Color(0xFFF4F6F8);
  static final Color appBarTextColor = Colors.white;
  static final Color textColor = Colors.black;

  // Default padding
  double get defaultPadding => w(16);

  AppStyle(BuildContext context) {
    _initialize(context);
  }

  /// Static init method (can be called in main.dart before runApp)
  static void init(BuildContext context) {
    _initialize(context);
  }

  /// Common initializer for both constructor & static init
  static void _initialize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    double textScale = mediaQuery.textScaleFactor;
    bool isPortrait = mediaQuery.orientation == Orientation.portrait;
    double baseHeight = 896; // iPhone 14 Pro height
    double baseWidth = 414; // iPhone 14 Pro width

    double scaleFactor = isPortrait
        ? _screenHeight / baseHeight
        : _screenWidth / baseWidth;

    // Font size calculations
    headFontSize = (22 * scaleFactor) * textScale;
    headFontSize = headFontSize.clamp(16 * textScale, 28 * textScale);

    normalFontSize = (16 * scaleFactor) * textScale;
    normalFontSize = normalFontSize.clamp(14 * textScale, 24 * textScale);
  }

  // Responsive height scaling
  static double h(double height) {
    return height * (_screenHeight / 896);
  }

  // Responsive width scaling
  static double w(double width) {
    return width * (_screenWidth / 414);
  }

  // Device type checks
  static bool get isMobile => _screenWidth < 600;
  static bool get isTablet => _screenWidth >= 600 && _screenWidth < 1024;
  static bool get isDesktop => _screenWidth >= 1024;

  // Screen dimensions
  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  static TextStyle headTextStyle() {
    return TextStyle(
      fontSize: headFontSize,
      color: textColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
    );
  }

  static TextStyle normalTextStyle() {
    return TextStyle(
      fontSize: normalFontSize,
      color: textColor,
      fontFamily: 'Roboto',
    );
  }

  PreferredSizeWidget getAppBar(String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(h(80)),
      child: Container(
        padding: EdgeInsets.only(
          top: h(40),
          left: w(defaultPadding),
          right: w(defaultPadding),
          bottom: h(20),
        ),
        decoration: BoxDecoration(
          color: appBarColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: headTextStyle().copyWith(
              color: appBarTextColor,
              fontSize: headFontSize * 0.9,
            ),
          ),
        ),
      ),
    );
  }
}
