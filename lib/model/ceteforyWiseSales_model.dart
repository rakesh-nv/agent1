class categoryWiseSalesModal {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;
  String? timestamp;

  categoryWiseSalesModal(
      {this.success, this.statusCode, this.message, this.data, this.timestamp});

  categoryWiseSalesModal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  int? totalSales;
  int? totalNetSlsQty;
  List<BranchSales>? branchSales;
  List<CategorySales>? categorySales;

  Data(
      {this.totalSales,
        this.totalNetSlsQty,
        this.branchSales,
        this.categorySales});

  Data.fromJson(Map<String, dynamic> json) {
    totalSales = json['totalSales'];
    totalNetSlsQty = json['totalNetSlsQty'];
    if (json['branchSales'] != null) {
      branchSales = <BranchSales>[];
      json['branchSales'].forEach((v) {
        branchSales!.add(new BranchSales.fromJson(v));
      });
    }
    if (json['categorySales'] != null) {
      categorySales = <CategorySales>[];
      json['categorySales'].forEach((v) {
        categorySales!.add(new CategorySales.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalSales'] = this.totalSales;
    data['totalNetSlsQty'] = this.totalNetSlsQty;
    if (this.branchSales != null) {
      data['branchSales'] = this.branchSales!.map((v) => v.toJson()).toList();
    }
    if (this.categorySales != null) {
      data['categorySales'] =
          this.categorySales!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BranchSales {
  int? totalAmount;
  int? totalNetSlsQty;
  String? branchAlias;

  BranchSales({this.totalAmount, this.totalNetSlsQty, this.branchAlias});

  BranchSales.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalNetSlsQty = json['totalNetSlsQty'];
    branchAlias = json['branchAlias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    data['totalNetSlsQty'] = this.totalNetSlsQty;
    data['branchAlias'] = this.branchAlias;
    return data;
  }
}

class CategorySales {
  int? totalAmount;
  int? totalNetSlsQty;
  String? category;

  CategorySales({this.totalAmount, this.totalNetSlsQty, this.category});

  CategorySales.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalNetSlsQty = json['totalNetSlsQty'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    data['totalNetSlsQty'] = this.totalNetSlsQty;
    data['category'] = this.category;
    return data;
  }
}
