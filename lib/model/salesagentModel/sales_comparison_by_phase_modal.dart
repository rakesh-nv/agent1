class SalesComparisonByPhaseResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SalesComparisonByPhaseData data;
  final String timestamp;

  SalesComparisonByPhaseResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SalesComparisonByPhaseResponse.fromJson(Map<String, dynamic> json) {
    return SalesComparisonByPhaseResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SalesComparisonByPhaseData.fromJson(json['data']),
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "data": data.toJson(),
      "timestamp": timestamp,
    };
  }
}

class SalesComparisonByPhaseData {
  final int financialYear;
  final List<SalesComparisonByPhaseItem> data;
  final String message;

  SalesComparisonByPhaseData({
    required this.financialYear,
    required this.data,
    required this.message,
  });

  factory SalesComparisonByPhaseData.fromJson(Map<String, dynamic> json) {
    return SalesComparisonByPhaseData(
      financialYear: json['financialYear'] ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((e) => SalesComparisonByPhaseItem.fromJson(e))
          .toList(),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "financialYear": financialYear,
      "data": data.map((e) => e.toJson()).toList(),
      "message": message,
    };
  }
}

class SalesComparisonByPhaseItem {
  final String phase;
  final String startDate;
  final String endDate;
  final double totalSaleThisYear;
  final int netQtyThisYear;
  final int numberOfBillsThisYear;
  final double totalSaleLastYear;
  final int netQtyLastYear;
  final int numberOfBillsLastYear;

  SalesComparisonByPhaseItem({
    required this.phase,
    required this.startDate,
    required this.endDate,
    required this.totalSaleThisYear,
    required this.netQtyThisYear,
    required this.numberOfBillsThisYear,
    required this.totalSaleLastYear,
    required this.netQtyLastYear,
    required this.numberOfBillsLastYear,
  });

  factory SalesComparisonByPhaseItem.fromJson(Map<String, dynamic> json) {
    return SalesComparisonByPhaseItem(
      phase: json['phase'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalSaleThisYear: (json['totalSaleThisYear'] as num?)?.toDouble() ?? 0.0,
      netQtyThisYear: json['netQtyThisYear'] ?? 0,
      numberOfBillsThisYear: json['numberOfBillsThisYear'] ?? 0,
      totalSaleLastYear: (json['totalSaleLastYear'] as num?)?.toDouble() ?? 0.0,
      netQtyLastYear: json['netQtyLastYear'] ?? 0,
      numberOfBillsLastYear: json['numberOfBillsLastYear'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "phase": phase,
      "startDate": startDate,
      "endDate": endDate,
      "totalSaleThisYear": totalSaleThisYear,
      "netQtyThisYear": netQtyThisYear,
      "numberOfBillsThisYear": numberOfBillsThisYear,
      "totalSaleLastYear": totalSaleLastYear,
      "netQtyLastYear": netQtyLastYear,
      "numberOfBillsLastYear": numberOfBillsLastYear,
    };
  }
}
