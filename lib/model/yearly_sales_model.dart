class SalesComparisonResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SalesComparisonData data;
  final String timestamp;

  SalesComparisonResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SalesComparisonResponse.fromJson(Map<String, dynamic> json) {
    return SalesComparisonResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: SalesComparisonData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class SalesComparisonData {
  final int financialYear;
  final List<SalesPhase> phases;
  final String message;

  SalesComparisonData({
    required this.financialYear,
    required this.phases,
    required this.message,
  });

  factory SalesComparisonData.fromJson(Map<String, dynamic> json) {
    return SalesComparisonData(
      financialYear: json['financialYear'],
      phases: (json['data'] as List)
          .map((e) => SalesPhase.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }
}

class SalesPhase {
  final String phase;
  final String startDate;
  final String endDate;
  final double totalSaleThisYear;
  final int netQtyThisYear;
  final int numberOfBillsThisYear;
  final double totalSaleLastYear;
  final int netQtyLastYear;
  final int numberOfBillsLastYear;

  SalesPhase({
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

  factory SalesPhase.fromJson(Map<String, dynamic> json) {
    return SalesPhase(
      phase: json['phase'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      totalSaleThisYear: (json['totalSaleThisYear'] ?? 0).toDouble(),
      netQtyThisYear: json['netQtyThisYear'] ?? 0,
      numberOfBillsThisYear: json['numberOfBillsThisYear'] ?? 0,
      totalSaleLastYear: (json['totalSaleLastYear'] ?? 0).toDouble(),
      netQtyLastYear: json['netQtyLastYear'] ?? 0,
      numberOfBillsLastYear: json['numberOfBillsLastYear'] ?? 0,
    );
  }
}
