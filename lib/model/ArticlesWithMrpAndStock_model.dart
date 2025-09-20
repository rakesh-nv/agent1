class ArticleWithMrpAndStockResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<Data>? data;
  final String? timestamp;

  const ArticleWithMrpAndStockResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
    this.timestamp,
  });

  factory ArticleWithMrpAndStockResponse.fromJson(Map<String, dynamic> json) {
    return ArticleWithMrpAndStockResponse(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((v) => Data.fromJson(v as Map<String, dynamic>))
          .toList(),
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
      'timestamp': timestamp,
    };
  }
}

class Data {
  final double? itemMRP;
  final int? stockQty;
  final String? articleNo;
  final String? category;
  final String? productName; // New field
  final String? soldTodayLocation; // New field

  const Data({
    this.itemMRP,
    this.stockQty,
    this.articleNo,
    this.category,
    this.productName,
    this.soldTodayLocation,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      itemMRP: (json['itemMRP'] as num?)?.toDouble(),
      stockQty: json['stockQty'] as int?,
      articleNo: json['articleNo'] as String?,
      category: json['category'] as String?,
      productName: json['productName'] as String?, // Parse new field
      soldTodayLocation: json['soldTodayLocation'] as String?, // Parse new field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemMRP': itemMRP,
      'stockQty': stockQty,
      'articleNo': articleNo,
      'category': category,
      'productName': productName, // Include new field in toJson
      'soldTodayLocation': soldTodayLocation, // Include new field in toJson
    };
  }
}
