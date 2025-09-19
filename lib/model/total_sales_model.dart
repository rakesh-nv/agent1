class SalesDataResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SalesData data;
  final String timestamp;

  SalesDataResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SalesDataResponse.fromJson(Map<String, dynamic> json) {
    return SalesDataResponse(
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
  final double totalPurchaseAmount;
  final int customersServed;
  final double netProfit;

  SalesData({
    required this.totalNetAmount,
    required this.totalNetSlsQty,
    required this.totalNetSlsValue,
    required this.gp,
    required this.totalPurchaseAmount,
    required this.customersServed,
    required this.netProfit,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      totalNetAmount: (json['totalNetAmount'] as num).toDouble(),
      totalNetSlsQty: json['totalNetSlsQty'],
      totalNetSlsValue: (json['totalNetSlsValue'] as num).toDouble(),
      gp: (json['gp'] as num).toDouble(),
      totalPurchaseAmount: (json['totalPurchaseAmount'] as num? ?? 0.0).toDouble(),
      customersServed: (json['customersServed'] as int? ?? 0).toInt(),
      netProfit: (json['netProfit'] as num? ?? 0.0).toDouble(),
    );
  }
}
