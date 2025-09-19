class TopArticlesResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<ArticleData> data;
  final DateTime timestamp;

  TopArticlesResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory TopArticlesResponse.fromJson(Map<String, dynamic> json) {
    return TopArticlesResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => ArticleData.fromJson(item))
          .toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

  class ArticleData {
    final double gp;
    final String articleNo;
    final int netAmount;
    final int netQuantity;
    final String img;

    ArticleData({
      required this.gp,
      required this.articleNo,
      required this.netAmount,
      required this.netQuantity,
      required this.img,
    });

    factory ArticleData.fromJson(Map<String, dynamic> json) {
      return ArticleData(
        gp: (json['gp'] ?? 0).toDouble(),
        articleNo: json['articleNo'] ?? '',
        netAmount: json['netAmount'] ?? 0,
        netQuantity: json['netQuantity'] ?? 0,
        img: json['img'] ?? '',
      );
    }
  }
