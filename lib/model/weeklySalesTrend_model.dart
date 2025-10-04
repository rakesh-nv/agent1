class WeeklySalesTrendResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SalesData? data;
  final String? timestamp;

  WeeklySalesTrendResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.timestamp,
  });

  factory WeeklySalesTrendResponse.fromJson(Map<String, dynamic> json) {
    return WeeklySalesTrendResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? SalesData.fromJson(json['data']) : null,
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.toJson(),
      'timestamp': timestamp,
    };
  }
}

class SalesData {
  final List<DaySales> thisWeek;
  final List<DaySales> lastWeek;
  final SalesSummary summary;

  SalesData({
    required this.thisWeek,
    required this.lastWeek,
    required this.summary,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      thisWeek: (json['thisWeek'] as List<dynamic>)
          .map((e) => DaySales.fromJson(e))
          .toList(),
      lastWeek: (json['lastWeek'] as List<dynamic>)
          .map((e) => DaySales.fromJson(e))
          .toList(),
      summary: SalesSummary.fromJson(json['summary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thisWeek': thisWeek.map((e) => e.toJson()).toList(),
      'lastWeek': lastWeek.map((e) => e.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }
}

class DaySales {
  final String day;
  final String date;
  final int sales;

  DaySales({
    required this.day,
    required this.date,
    required this.sales,
  });

  factory DaySales.fromJson(Map<String, dynamic> json) {
    return DaySales(
      day: json['day'] ?? '',
      date: json['date'] ?? '',
      sales: json['sales'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date,
      'sales': sales,
    };
  }
}

class SalesSummary {
  final int thisWeekTotal;
  final int lastWeekTotal;
  final double thisWeekAverage;
  final double lastWeekAverage;

  SalesSummary({
    required this.thisWeekTotal,
    required this.lastWeekTotal,
    required this.thisWeekAverage,
    required this.lastWeekAverage,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    return SalesSummary(
      thisWeekTotal: json['thisWeekTotal'] ?? 0,
      lastWeekTotal: json['lastWeekTotal'] ?? 0,
      thisWeekAverage:
      (json['thisWeekAverage'] as num?)?.toDouble() ?? 0.0,
      lastWeekAverage:
      (json['lastWeekAverage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thisWeekTotal': thisWeekTotal,
      'lastWeekTotal': lastWeekTotal,
      'thisWeekAverage': thisWeekAverage,
      'lastWeekAverage': lastWeekAverage,
    };
  }
}
