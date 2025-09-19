class SalesByDateModel {
  final bool success;
  final int statusCode;
  final String message;
  final SalesData data;
  final String timestamp;

  SalesByDateModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SalesByDateModel.fromJson(Map<String, dynamic> json) {
    return SalesByDateModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: SalesData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class SalesData {
  final double totalNetAmount;
  final int totalNetSlsQty;
  final double totalNetSlsValue;
  final double gp;

  SalesData({
    required this.totalNetAmount,
    required this.totalNetSlsQty,
    required this.totalNetSlsValue,
    required this.gp,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      totalNetAmount: (json['totalNetAmount'] as num).toDouble(),
      totalNetSlsQty: json['totalNetSlsQty'],
      totalNetSlsValue: (json['totalNetSlsValue'] as num).toDouble(),
      gp: (json['gp'] as num).toDouble(),
    );
  }
}
