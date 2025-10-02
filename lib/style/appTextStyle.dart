import 'dart:ui';

import 'package:flutter/material.dart';

import 'siseConfig.dart';

class AppTextStyles {
  static double get headline => SizeConfig.isDesktop
      ? 22
      : SizeConfig.isTablet
      ? 20
      : 18;
  static double get subheadline => SizeConfig.isDesktop
      ? 18
      : SizeConfig.isTablet
      ? 16
      : 14;
  static double get body => SizeConfig.isDesktop
      ? 16
      : SizeConfig.isTablet
      ? 14
      : 12;
  static double get caption => SizeConfig.isDesktop
      ? 14
      : SizeConfig.isTablet
      ? 12
      : 10;
  static double get small => SizeConfig.isDesktop
      ? 12
      : SizeConfig.isTablet
      ? 10
      : 8;

  static TextStyle headlineText({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: SizeConfig.w(
        headline,
      ).clamp(12, 24), // Clamp to prevent oversized text
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle subheadlineText({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: SizeConfig.w(subheadline).clamp(10, 20),
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyText({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: SizeConfig.w(body).clamp(8, 18),
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle captionText({
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: SizeConfig.w(caption).clamp(6, 16),
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle smallText({
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: SizeConfig.w(small).clamp(6, 14),
      fontWeight: fontWeight,
      color: color,
    );
  }
}
