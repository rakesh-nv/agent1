// promise_actual_model.dart

class PromiseActualResponse {
  final bool success;
  final int statusCode;
  final String message;
  final Data data;
  final String timestamp;

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
      data: Data.fromJson(json['data']),
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

class Data {
  final int year;
  final String month;
  final List<Location> locations;
  final String createdAt;
  final String updatedAt;

  Data({
    required this.year,
    required this.month,
    required this.locations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      year: json['year'] ?? 0,
      month: json['month'] ?? '',
      locations: (json['locations'] as List)
          .map((e) => Location.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "year": year,
      "month": month,
      "locations": locations.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}

class Location {
  final String location;
  final List<DailyValue> dailyValues;

  Location({
    required this.location,
    required this.dailyValues,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      location: json['location'] ?? '',
      dailyValues: (json['dailyValues'] as List)
          .map((e) => DailyValue.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "location": location,
      "dailyValues": dailyValues.map((e) => e.toJson()).toList(),
    };
  }
}

class DailyValue {
  final String date;
  final int promise;
  final int actual;

  DailyValue({
    required this.date,
    required this.promise,
    required this.actual,
  });

  factory DailyValue.fromJson(Map<String, dynamic> json) {
    return DailyValue(
      date: json['date'] ?? '',
      promise: json['promise'] ?? 0,
      actual: json['actual'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "promise": promise,
      "actual": actual,
    };
  }
}
