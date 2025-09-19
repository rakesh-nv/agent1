class PromiseActualResponse {
  final bool success;
  final int statusCode;
  final String message;
  final PromiseActualData data;
  final DateTime timestamp;

  PromiseActualResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory PromiseActualResponse.fromJson(Map<String, dynamic> json) {
    return PromiseActualResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: PromiseActualData.fromJson(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class PromiseActualData {
  final int year;
  final String month;
  final List<LocationData> locations;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromiseActualData({
    required this.year,
    required this.month,
    required this.locations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromiseActualData.fromJson(Map<String, dynamic> json) {
    return PromiseActualData(
      year: json['year'] ?? 0,
      month: json['month'] ?? '',
      locations: (json['locations'] as List)
          .map((loc) => LocationData.fromJson(loc))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class LocationData {
  final String location;
  final List<DailyValue> dailyValues;

  LocationData({
    required this.location,
    required this.dailyValues,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      location: json['location'] ?? '',
      dailyValues: (json['dailyValues'] as List)
          .map((dv) => DailyValue.fromJson(dv))
          .toList(),
    );
  }
}

class DailyValue {
  final DateTime date;
  final double promise;
  final double actual;

  DailyValue({
    required this.date,
    required this.promise,
    required this.actual,
  });

  factory DailyValue.fromJson(Map<String, dynamic> json) {
    return DailyValue(
      date: DateTime.parse(json['date']),
      promise: (json['promise'] ?? 0).toDouble(),
      actual: (json['actual'] ?? 0).toDouble(),
    );
  }
}
