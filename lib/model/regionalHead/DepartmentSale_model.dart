class DepartmentSalesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<DepartmentSalesData> data;
  final String? timestamp;

  DepartmentSalesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    this.timestamp,
  });

  factory DepartmentSalesResponse.fromJson(Map<String, dynamic> json) {
    return DepartmentSalesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => DepartmentSalesData.fromJson(e))
              .toList() ??
          [],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'timestamp': timestamp,
    };
  }
}

class DepartmentSalesData {
  final int totalAmount;
  final int totalNetSlsQty;
  final String department;

  DepartmentSalesData({
    required this.totalAmount,
    required this.totalNetSlsQty,
    required this.department,
  });

  factory DepartmentSalesData.fromJson(Map<String, dynamic> json) {
    return DepartmentSalesData(
      totalAmount: json['totalAmount'] ?? 0,
      totalNetSlsQty: json['totalNetSlsQty'] ?? 0,
      department: json['department'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'totalNetSlsQty': totalNetSlsQty,
      'department': department,
    };
  }
}
