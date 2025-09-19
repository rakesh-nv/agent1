import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesByBranchCategoryResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SalesByBranchCategoryData data;

  SalesByBranchCategoryResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SalesByBranchCategoryResponse.fromJson(Map<String, dynamic> json) {
    return SalesByBranchCategoryResponse(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: SalesByBranchCategoryData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SalesByBranchCategoryData {
  final double totalSales;
  final int totalNetSlsQty;
  final List<BranchSales> branchSales;
  final List<CategorySales> categorySales;

  SalesByBranchCategoryData({
    required this.totalSales,
    required this.totalNetSlsQty,
    required this.branchSales,
    required this.categorySales,
  });

  factory SalesByBranchCategoryData.fromJson(Map<String, dynamic> json) {
    return SalesByBranchCategoryData(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
      totalNetSlsQty: json['totalNetSlsQty'] as int? ?? 0,
      branchSales: (json['branchSales'] as List<dynamic>?)
              ?.map((e) => BranchSales.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categorySales: (json['categorySales'] as List<dynamic>?)
              ?.map((e) => CategorySales.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalNetSlsQty': totalNetSlsQty,
      'branchSales': branchSales.map((e) => e.toJson()).toList(),
      'categorySales': categorySales.map((e) => e.toJson()).toList(),
    };
  }
}

class BranchSales {
  final double totalAmount;
  final int totalNetSlsQty;
  final String branchAlias;

  BranchSales({
    required this.totalAmount,
    required this.totalNetSlsQty,
    required this.branchAlias,
  });

  factory BranchSales.fromJson(Map<String, dynamic> json) {
    return BranchSales(
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalNetSlsQty: json['totalNetSlsQty'] as int? ?? 0,
      branchAlias: json['branchAlias'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'totalNetSlsQty': totalNetSlsQty,
      'branchAlias': branchAlias,
    };
  }
}

class CategorySales {
  final double totalAmount;
  final int totalNetSlsQty;
  final String category;

  CategorySales({
    required this.totalAmount,
    required this.totalNetSlsQty,
    required this.category,
  });

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalNetSlsQty: json['totalNetSlsQty'] as int? ?? 0,
      category: json['category'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'totalNetSlsQty': totalNetSlsQty,
      'category': category,
    };
  }
}

class BranchPerformance {
  final String name;
  final double actual;
  final double promised;
  final Color color;

  const BranchPerformance({
    required this.name,
    required this.actual,
    required this.promised,
    this.color = const Color(0xFF0F7CFF),
  });
}

extension INR on num {
  String format() {
    final f = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
    return f.format(this);
  }
}