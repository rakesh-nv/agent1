import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle( // H1
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle( // H2
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    displaySmall: TextStyle( // H3
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle( // H4
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle( // H5
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    titleLarge: TextStyle( // H6
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyLarge: TextStyle( // Body1
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle( // Body2
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
    labelLarge: TextStyle( // Button Text
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodySmall: TextStyle( // Caption
      fontSize: 12.sp,
      color: Colors.grey,
    ),
  );
}
