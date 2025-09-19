// filter_model.dart

class FilterResponse {
  final bool success;
  final int statusCode;
  final String message;
  final FilterData data;

  FilterResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FilterResponse.fromJson(Map<String, dynamic> json) {
    return FilterResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: FilterData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class FilterData {
  final List<String> suppliers;
  final List<String> destinations;
  final List<String> branches;

  FilterData({
    required this.suppliers,
    required this.destinations,
    required this.branches,
  });

  factory FilterData.fromJson(Map<String, dynamic> json) {
    return FilterData(
      suppliers: List<String>.from(json['suppliers'] ?? []),
      destinations: List<String>.from(json['destinations'] ?? []),
      branches: List<String>.from(json['branches'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suppliers': suppliers,
      'destinations': destinations,
      'branches': branches
    };
  }
}
