class BranchManagerSalesVsPromiseModel {
  final bool success;
  final int statusCode;
  final String message;
  final SalesData data;
  final String timestamp;

  BranchManagerSalesVsPromiseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory BranchManagerSalesVsPromiseModel.fromJson(Map<String, dynamic> json) {
    return BranchManagerSalesVsPromiseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: SalesData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }
}

class SalesData {
  final List<BranchData> branchData;
  final Totals totals;
  final WeeklyData thisWeek;
  final WeeklyData lastWeek;

  SalesData({
    required this.branchData,
    required this.totals,
    required this.thisWeek,
    required this.lastWeek,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      branchData: (json['branchData'] as List)
          .map((e) => BranchData.fromJson(e))
          .toList(),
      totals: Totals.fromJson(json['totals']),
      thisWeek: WeeklyData.fromJson(json['thisWeek']),
      lastWeek: WeeklyData.fromJson(json['lastWeek']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchData': branchData.map((e) => e.toJson()).toList(),
      'totals': totals.toJson(),
      'thisWeek': thisWeek.toJson(),
      'lastWeek': lastWeek.toJson(),
    };
  }
}

class BranchData {
  final String branchAlias;
  final int? promised;
  final int actualSales;

  BranchData({
    required this.branchAlias,
    this.promised,
    required this.actualSales,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      branchAlias: json['branchAlias'],
      promised: json['promised'],
      actualSales: json['actualSales'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchAlias': branchAlias,
      'promised': promised,
      'actualSales': actualSales,
    };
  }
}

class Totals {
  final int? totalPromise;
  final int totalSales;

  Totals({
    this.totalPromise,
    required this.totalSales,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalPromise: json['totalPromise'],
      totalSales: json['totalSales'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPromise': totalPromise,
      'totalSales': totalSales,
    };
  }
}

class WeeklyData {
  final List<BranchData> branchData;
  final Totals totals;

  WeeklyData({
    required this.branchData,
    required this.totals,
  });

  factory WeeklyData.fromJson(Map<String, dynamic> json) {
    return WeeklyData(
      branchData: (json['branchData'] as List)
          .map((e) => BranchData.fromJson(e))
          .toList(),
      totals: Totals.fromJson(json['totals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchData': branchData.map((e) => e.toJson()).toList(),
      'totals': totals.toJson(),
    };
  }
}
