// class SalesByBranchCategoryModel {
//   final bool success;
//   final int statusCode;
//   final String message;
//   final SalesData data;
//
//   SalesByBranchCategoryModel({
//     required this.success,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });
//
//   factory SalesByBranchCategoryModel.fromJson(Map<String, dynamic> json) {
//     return SalesByBranchCategoryModel(
//       success: json['success'],
//       statusCode: json['statusCode'],
//       message: json['message'],
//       data: SalesData.fromJson(json['data']),
//     );
//   }
// }
//
// class SalesData {
//   final double totalSales;
//   final double totalNetSlsQty;
//   final List<BranchSales> branchSales;
//   final List<CategorySales> categorySales;
//
//   SalesData({
//     required this.totalSales,
//     required this.totalNetSlsQty,
//     required this.branchSales,
//     required this.categorySales,
//   });
//
//   factory SalesData.fromJson(Map<String, dynamic> json) {
//     return SalesData(
//       totalSales: (json['totalSales'] as num).toDouble(),
//       totalNetSlsQty: (json['totalNetSlsQty'] as num).toDouble(),
//       branchSales: (json['branchSales'] as List)
//           .map((e) => BranchSales.fromJson(e))
//           .toList(),
//       categorySales: (json['categorySales'] as List)
//           .map((e) => CategorySales.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
// class BranchSales {
//   final double totalAmount;
//   final double totalNetSlsQty;
//   final String branchAlias;
//
//   BranchSales({
//     required this.totalAmount,
//     required this.totalNetSlsQty,
//     required this.branchAlias,
//   });
//
//   factory BranchSales.fromJson(Map<String, dynamic> json) {
//     return BranchSales(
//       totalAmount: (json['totalAmount'] as num).toDouble(),
//       totalNetSlsQty: (json['totalNetSlsQty'] as num).toDouble(),
//       branchAlias: json['branchAlias'],
//     );
//   }
// }
//
// class CategorySales {
//   final double totalAmount;
//   final double totalNetSlsQty;
//   final String category;
//
//   CategorySales({
//     required this.totalAmount,
//     required this.totalNetSlsQty,
//     required this.category,
//   });
//
//   factory CategorySales.fromJson(Map<String, dynamic> json) {
//     return CategorySales(
//       totalAmount: (json['totalAmount'] as num).toDouble(),
//       totalNetSlsQty: (json['totalNetSlsQty'] as num).toDouble(),
//       category: json['category'],
//     );
//   }
// }
