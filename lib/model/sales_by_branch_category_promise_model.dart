// class PurchasePromiseModel {
//   final bool success;
//   final int statusCode;
//   final String message;
//   final List<PromiseData> data;
//
//   PurchasePromiseModel({
//     required this.success,
//     required this.statusCode,
//     required this.message,
//     required this.data,
//   });
//
//   factory PurchasePromiseModel.fromJson(Map<String, dynamic> json) {
//     return PurchasePromiseModel(
//       success: json['success'],
//       statusCode: json['statusCode'],
//       message: json['message'],
//       data: (json['data'] as List)
//           .map((e) => PromiseData.fromJson(e))
//           .toList(),
//     );
//   }
// }
//
// class PromiseData {
//   final String date;
//   final double promisedPurchase;
//   final double netAmount;
//
//   PromiseData({
//     required this.date,
//     required this.promisedPurchase,
//     required this.netAmount,
//   });
//
//   factory PromiseData.fromJson(Map<String, dynamic> json) {
//     return PromiseData(
//       date: json['date'],
//       promisedPurchase: (json['promisedPurchase'] as num).toDouble(),
//       netAmount: (json['netAmount'] as num).toDouble(),
//     );
//   }
// }
