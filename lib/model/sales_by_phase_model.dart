class SalesByPhaseResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SalesByPhaseData data;
  final String timestamp;

  SalesByPhaseResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SalesByPhaseResponse.fromJson(Map<String, dynamic> json) {
    return SalesByPhaseResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: SalesByPhaseData.fromJson(json['data']),
      timestamp: json['timestamp'],
    );
  }
}

class SalesByPhaseData {
  final String currentPhase;
  final int phase1;
  final int phase2;
  final int phase3;
  final int phase4;

  SalesByPhaseData({
    required this.currentPhase,
    required this.phase1,
    required this.phase2,
    required this.phase3,
    required this.phase4,
  });

  factory SalesByPhaseData.fromJson(Map<String, dynamic> json) {
    return SalesByPhaseData(
      currentPhase: json['currentPhase'],
      phase1: json['phase1'],
      phase2: json['phase2'],
      phase3: json['phase3'],
      phase4: json['phase4'],
    );
  }
}
