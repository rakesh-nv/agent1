class SubordinatesAggregationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SubordinatesData data;
  final String timestamp;

  SubordinatesAggregationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory SubordinatesAggregationResponse.fromJson(Map<String, dynamic> json) {
    return SubordinatesAggregationResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: SubordinatesData.fromJson(json['data']),
      timestamp: json['timestamp'],
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

class SubordinatesData {
  final List<Subordinate> subordinates;

  SubordinatesData({required this.subordinates});

  factory SubordinatesData.fromJson(Map<String, dynamic> json) {
    return SubordinatesData(
      subordinates: (json['subordinates'] as List)
          .map((e) => Subordinate.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"subordinates": subordinates.map((e) => e.toJson()).toList()};
  }
}

class Subordinate {
  final String name;
  final String email;
  final String lastLogin;
  final bool isAllBranches;
  final bool isAllCategories;
  final List<String>? branches;
  final dynamic categories; // can be "All Categories" or List<String>
  final Sales sales;

  Subordinate({
    required this.name,
    required this.email,
    required this.lastLogin,
    required this.isAllBranches,
    required this.isAllCategories,
    required this.branches,
    required this.categories,
    required this.sales,
  });

  factory Subordinate.fromJson(Map<String, dynamic> json) {
    return Subordinate(
      name: json['name'],
      email: json['email'],
      lastLogin: json['lastLogin'],
      isAllBranches: json['isAllBranches'],
      isAllCategories: json['isAllCategories'],
      branches: json['branches'] != null
          ? List<String>.from(json['branches'])
          : [],
      categories: json['categories'],
      sales: Sales.fromJson(json['sales']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "lastLogin": lastLogin,
      "isAllBranches": isAllBranches,
      "isAllCategories": isAllCategories,
      "branches": branches,
      "categories": categories,
      "sales": sales.toJson(),
    };
  }
}

class Sales {
  final List<BranchSales> branchSales;
  final List<CategorySales> categorySales;
  final TotalSales totalSales;

  Sales({
    required this.branchSales,
    required this.categorySales,
    required this.totalSales,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      branchSales: (json['branchSales'] as List)
          .map((e) => BranchSales.fromJson(e))
          .toList(),
      categorySales: (json['categorySales'] as List)
          .map((e) => CategorySales.fromJson(e))
          .toList(),
      totalSales: TotalSales.fromJson(json['totalSales']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "branchSales": branchSales.map((e) => e.toJson()).toList(),
      "categorySales": categorySales.map((e) => e.toJson()).toList(),
      "totalSales": totalSales.toJson(),
    };
  }
}

class BranchSales {
  final int totalAmount;
  final int totalNetSlsQty;
  final String branchAlias;

  BranchSales({
    required this.totalAmount,
    required this.totalNetSlsQty,
    required this.branchAlias,
  });

  factory BranchSales.fromJson(Map<String, dynamic> json) {
    return BranchSales(
      totalAmount: json['totalAmount'],
      totalNetSlsQty: json['totalNetSlsQty'],
      branchAlias: json['branchAlias'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalAmount": totalAmount,
      "totalNetSlsQty": totalNetSlsQty,
      "branchAlias": branchAlias,
    };
  }
}

class CategorySales {
  final int totalAmount;
  final int totalNetSlsQty;
  final String category;

  CategorySales({
    required this.totalAmount,
    required this.totalNetSlsQty,
    required this.category,
  });

  factory CategorySales.fromJson(Map<String, dynamic> json) {
    return CategorySales(
      totalAmount: json['totalAmount'],
      totalNetSlsQty: json['totalNetSlsQty'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalAmount": totalAmount,
      "totalNetSlsQty": totalNetSlsQty,
      "category": category,
    };
  }
}

class TotalSales {
  final int totalAmount;
  final int totalNetSlsQty;

  TotalSales({required this.totalAmount, required this.totalNetSlsQty});

  factory TotalSales.fromJson(Map<String, dynamic> json) {
    return TotalSales(
      totalAmount: json['totalAmount'],
      totalNetSlsQty: json['totalNetSlsQty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"totalAmount": totalAmount, "totalNetSlsQty": totalNetSlsQty};
  }
}
