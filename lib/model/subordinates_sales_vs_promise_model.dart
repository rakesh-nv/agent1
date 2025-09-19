class SubordinatesSalesVsPromiseModel {
  bool? success;
  int? statusCode;
  String? message;
  Data? data;
  String? timestamp;

  SubordinatesSalesVsPromiseModel({
    this.success,
    this.statusCode,
    this.message,
    this.data,
    this.timestamp,
  });

  SubordinatesSalesVsPromiseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['statusCode'] = statusCode;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    map['timestamp'] = timestamp;
    return map;
  }
}

class Data {
  int? count;
  int? totalSales;
  int? totalPromise;
  List<Subordinate>? subordinates;

  Data({this.count, this.totalSales, this.totalPromise, this.subordinates});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    totalSales = json['totalSales'];
    totalPromise = json['totalPromise'];
    if (json['subordinates'] != null) {
      subordinates = <Subordinate>[];
      json['subordinates'].forEach((v) {
        subordinates!.add(Subordinate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['count'] = count;
    map['totalSales'] = totalSales;
    map['totalPromise'] = totalPromise;
    if (subordinates != null) {
      map['subordinates'] = subordinates!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Subordinate {
  String? name;
  String? email;
  String? lastLogin;
  List<Branch>? branches;
  int? totalSales;
  int? totalPromise;

  Subordinate({
    this.name,
    this.email,
    this.lastLogin,
    this.branches,
    this.totalSales,
    this.totalPromise,
  });

  Subordinate.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    lastLogin = json['lastLogin'];
    if (json['branches'] != null) {
      branches = <Branch>[];
      json['branches'].forEach((v) {
        branches!.add(Branch.fromJson(v));
      });
    }
    totalSales = json['totalSales'];
    totalPromise = json['totalPromise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['name'] = name;
    map['email'] = email;
    map['lastLogin'] = lastLogin;
    if (branches != null) {
      map['branches'] = branches!.map((v) => v.toJson()).toList();
    }
    map['totalSales'] = totalSales;
    map['totalPromise'] = totalPromise;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subordinate &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}

class Branch {
  String? branchAlias;
  int? promised;
  int? actualSales;

  Branch({this.branchAlias, this.promised, this.actualSales});

  Branch.fromJson(Map<String, dynamic> json) {
    branchAlias = json['branchAlias'];
    promised = json['promised'];
    actualSales = json['actualSales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['branchAlias'] = branchAlias;
    map['promised'] = promised;
    map['actualSales'] = actualSales;
    return map;
  }
}
