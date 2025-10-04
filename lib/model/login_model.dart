// class LoginResponse {
//   final bool success;
//   final int statusCode;
//   final String message;
//   final LoginData? data;
//   final String? timestamp;
//
//   LoginResponse({
//     required this.success,
//     required this.statusCode,
//     required this.message,
//     this.data,
//     this.timestamp,
//   });
//
//   LoginResponse copyWith({
//     bool? success,
//     int? statusCode,
//     String? message,
//     LoginData? data,
//     String? timestamp,
//   }) {
//     return LoginResponse(
//       success: success ?? this.success,
//       statusCode: statusCode ?? this.statusCode,
//       message: message ?? this.message,
//       data: data ?? this.data,
//       timestamp: timestamp ?? this.timestamp,
//     );
//   }
//
//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       success: json["success"] ?? false,
//       statusCode: json["statusCode"] ?? 0,
//       message: json["message"] ?? "",
//       data: json["data"] != null ? LoginData.fromJson(json["data"]) : null,
//       timestamp: json["timestamp"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "statusCode": statusCode,
//     "message": message,
//     "data": data?.toJson(),
//     "timestamp": timestamp,
//   };
// }
//
// class LoginData {
//   final String token;
//   final User user;
//
//   LoginData({required this.token, required this.user});
//
//   LoginData copyWith({String? token, User? user}) {
//     return LoginData(token: token ?? this.token, user: user ?? this.user);
//   }
//
//   factory LoginData.fromJson(Map<String, dynamic> json) {
//     return LoginData(
//       token: json["token"] ?? "",
//       user: User.fromJson(json["user"]),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
// }
//
// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String mobile;
//   final String userType;
//   final String grade;
//   final String reportingTo;
//   final bool isAllBranches;
//   final bool isAllCategories;
//   final List<String> selectedBranches;
//   final List<String> selectedCategories;
//   final List<String> selectedBranchAliases;
//   final List<String> selectedCategoryNames;
//   final Template templateId;
//   final bool isBlocked;
//   final String lastLogin;
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.mobile,
//     required this.userType,
//     required this.grade,
//     required this.reportingTo,
//     required this.isAllBranches,
//     required this.isAllCategories,
//     required this.selectedBranches,
//     required this.selectedCategories,
//     required this.selectedBranchAliases,
//     required this.selectedCategoryNames,
//     required this.templateId,
//     required this.isBlocked,
//     required this.lastLogin,
//   });
//
//   User copyWith({
//     String? id,
//     String? name,
//     String? email,
//     String? mobile,
//     String? userType,
//     String? grade,
//     String? reportingTo,
//     bool? isAllBranches,
//     bool? isAllCategories,
//     List<String>? selectedBranches,
//     List<String>? selectedCategories,
//     List<String>? selectedBranchAliases,
//     List<String>? selectedCategoryNames,
//     Template? templateId,
//     bool? isBlocked,
//     String? lastLogin,
//   }) {
//     return User(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       mobile: mobile ?? this.mobile,
//       userType: userType ?? this.userType,
//       grade: grade ?? this.grade,
//       reportingTo: reportingTo ?? this.reportingTo,
//       isAllBranches: isAllBranches ?? this.isAllBranches,
//       isAllCategories: isAllCategories ?? this.isAllCategories,
//       selectedBranches: selectedBranches ?? this.selectedBranches,
//       selectedCategories: selectedCategories ?? this.selectedCategories,
//       selectedBranchAliases:
//           selectedBranchAliases ?? this.selectedBranchAliases,
//       selectedCategoryNames:
//           selectedCategoryNames ?? this.selectedCategoryNames,
//       templateId: templateId ?? this.templateId,
//       isBlocked: isBlocked ?? this.isBlocked,
//       lastLogin: lastLogin ?? this.lastLogin,
//     );
//   }
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json["id"] ?? "",
//       name: json["name"] ?? "",
//       email: json["email"] ?? "",
//       mobile: json["mobile"] ?? "",
//       userType: json["userType"] ?? "",
//       grade: json["grade"] ?? "",
//       reportingTo: json["reportingTo"] ?? "",
//       isAllBranches: json["isAllBranches"] ?? false,
//       isAllCategories: json["isAllCategories"] ?? false,
//       selectedBranches: List<String>.from(json["selectedBranches"] ?? []),
//       selectedCategories: List<String>.from(json["selectedCategories"] ?? []),
//       selectedBranchAliases: List<String>.from(
//         json["selectedBranchAliases"] ?? [],
//       ),
//       selectedCategoryNames: List<String>.from(
//         json["selectedCategoryNames"] ?? [],
//       ),
//       templateId: Template.fromJson(json["templateId"]),
//       isBlocked: json["isBlocked"] ?? false,
//       lastLogin: json["lastLogin"] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "email": email,
//     "mobile": mobile,
//     "userType": userType,
//     "grade": grade,
//     "reportingTo": reportingTo,
//     "isAllBranches": isAllBranches,
//     "isAllCategories": isAllCategories,
//     "selectedBranches": selectedBranches,
//     "selectedCategories": selectedCategories,
//     "selectedBranchAliases": selectedBranchAliases,
//     "selectedCategoryNames": selectedCategoryNames,
//     "templateId": templateId.toJson(),
//     "isBlocked": isBlocked,
//     "lastLogin": lastLogin,
//   };
// }
//
// class Template {
//   final String id;
//   final String templateName;
//   final bool categoryAccess;
//   final bool branchAccess;
//   final bool articleAccess;
//   final bool overallSalesAccess;
//   final bool mrpSummaryAccess;
//   final bool summaryYtdOnlineAccess;
//   final bool onlineDataAccess;
//   final bool costAccess;
//   final bool supplierAccessCreate;
//   final bool purchaseCategoryAccess;
//   final bool purchaseArticleAccess;
//   final bool purchaseBranchAccess;
//   final bool purchaseDoneReportAccess;
//   final bool isOnlineBuyer;
//   final bool channelReportAccess;
//   final String createdAt;
//   final String updatedAt;
//
//   Template({
//     required this.id,
//     required this.templateName,
//     required this.categoryAccess,
//     required this.branchAccess,
//     required this.articleAccess,
//     required this.overallSalesAccess,
//     required this.mrpSummaryAccess,
//     required this.summaryYtdOnlineAccess,
//     required this.onlineDataAccess,
//     required this.costAccess,
//     required this.supplierAccessCreate,
//     required this.purchaseCategoryAccess,
//     required this.purchaseArticleAccess,
//     required this.purchaseBranchAccess,
//     required this.purchaseDoneReportAccess,
//     required this.isOnlineBuyer,
//     required this.channelReportAccess,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Template.fromJson(Map<String, dynamic> json) {
//     return Template(
//       id: json["_id"] ?? "",
//       templateName: json["templateName"] ?? "",
//       categoryAccess: json["categoryAccess"] ?? false,
//       branchAccess: json["branchAccess"] ?? false,
//       articleAccess: json["articleAccess"] ?? false,
//       overallSalesAccess: json["overallSalesAccess"] ?? false,
//       mrpSummaryAccess: json["mrpSummaryAccess"] ?? false,
//       summaryYtdOnlineAccess: json["summaryYtdOnlineAccess"] ?? false,
//       onlineDataAccess: json["onlineDataAccess"] ?? false,
//       costAccess: json["costAccess"] ?? false,
//       supplierAccessCreate: json["supplierAccessCreate"] ?? false,
//       purchaseCategoryAccess: json["purchaseCategoryAccess"] ?? false,
//       purchaseArticleAccess: json["purchaseArticleAccess"] ?? false,
//       purchaseBranchAccess: json["purchaseBranchAccess"] ?? false,
//       purchaseDoneReportAccess: json["purchaseDoneReportAccess"] ?? false,
//       isOnlineBuyer: json["isOnlineBuyer"] ?? false,
//       channelReportAccess: json["channelReportAccess"] ?? false,
//       createdAt: json["createdAt"] ?? "",
//       updatedAt: json["updatedAt"] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "templateName": templateName,
//     "categoryAccess": categoryAccess,
//     "branchAccess": branchAccess,
//     "articleAccess": articleAccess,
//     "overallSalesAccess": overallSalesAccess,
//     "mrpSummaryAccess": mrpSummaryAccess,
//     "summaryYtdOnlineAccess": summaryYtdOnlineAccess,
//     "onlineDataAccess": onlineDataAccess,
//     "costAccess": costAccess,
//     "supplierAccessCreate": supplierAccessCreate,
//     "purchaseCategoryAccess": purchaseCategoryAccess,
//     "purchaseArticleAccess": purchaseArticleAccess,
//     "purchaseBranchAccess": purchaseBranchAccess,
//     "purchaseDoneReportAccess": purchaseDoneReportAccess,
//     "isOnlineBuyer": isOnlineBuyer,
//     "channelReportAccess": channelReportAccess,
//     "createdAt": createdAt,
//     "updatedAt": updatedAt,
//   };
// }


class LoginResponse {
  final bool success;
  final int statusCode;
  final String message;
  final LoginData? data;
  final String? timestamp;

  LoginResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] ?? false,
      statusCode: json["statusCode"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"] != null ? LoginData.fromJson(json["data"]) : null,
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
    "timestamp": timestamp,
  };

  /// ✅ Added copyWith
  LoginResponse copyWith({
    bool? success,
    int? statusCode,
    String? message,
    LoginData? data,
    String? timestamp,
  }) {
    return LoginResponse(
      success: success ?? this.success,
      statusCode: statusCode ?? this.statusCode,
      message: message ?? this.message,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class LoginData {
  final String token;
  final User user;

  LoginData({required this.token, required this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json["token"] ?? "",
      user: User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };

  /// ✅ Added copyWith
  LoginData copyWith({
    String? token,
    User? user,
  }) {
    return LoginData(
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String userType;
  final String grade;
  final String reportingTo;
  final bool isAllBranches;
  final bool isAllCategories;
  final List<String> selectedBranches;
  final List<String> selectedCategories;
  final List<String> selectedBranchAliases;
  final List<String> selectedCategoryNames;
  final Template templateId;
  final bool isBlocked;
  final String lastLogin;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.userType,
    required this.grade,
    required this.reportingTo,
    required this.isAllBranches,
    required this.isAllCategories,
    required this.selectedBranches,
    required this.selectedCategories,
    required this.selectedBranchAliases,
    required this.selectedCategoryNames,
    required this.templateId,
    required this.isBlocked,
    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
      userType: json["userType"] ?? "",
      grade: json["grade"] ?? "",
      reportingTo: json["reportingTo"] ?? "",
      isAllBranches: json["isAllBranches"] ?? false,
      isAllCategories: json["isAllCategories"] ?? false,
      selectedBranches: List<String>.from(json["selectedBranches"] ?? []),
      selectedCategories: List<String>.from(json["selectedCategories"] ?? []),
      selectedBranchAliases:
      List<String>.from(json["selectedBranchAliases"] ?? []),
      selectedCategoryNames:
      List<String>.from(json["selectedCategoryNames"] ?? []),
      templateId: json["templateId"] != null
          ? Template.fromJson(json["templateId"])
          : Template.empty(),
      isBlocked: json["isBlocked"] ?? false,
      lastLogin: json["lastLogin"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "userType": userType,
    "grade": grade,
    "reportingTo": reportingTo,
    "isAllBranches": isAllBranches,
    "isAllCategories": isAllCategories,
    "selectedBranches": selectedBranches,
    "selectedCategories": selectedCategories,
    "selectedBranchAliases": selectedBranchAliases,
    "selectedCategoryNames": selectedCategoryNames,
    "templateId": templateId.toJson(),
    "isBlocked": isBlocked,
    "lastLogin": lastLogin,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };

  /// ✅ Added copyWith
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    String? userType,
    String? grade,
    String? reportingTo,
    bool? isAllBranches,
    bool? isAllCategories,
    List<String>? selectedBranches,
    List<String>? selectedCategories,
    List<String>? selectedBranchAliases,
    List<String>? selectedCategoryNames,
    Template? templateId,
    bool? isBlocked,
    String? lastLogin,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      userType: userType ?? this.userType,
      grade: grade ?? this.grade,
      reportingTo: reportingTo ?? this.reportingTo,
      isAllBranches: isAllBranches ?? this.isAllBranches,
      isAllCategories: isAllCategories ?? this.isAllCategories,
      selectedBranches: selectedBranches ?? this.selectedBranches,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedBranchAliases:
      selectedBranchAliases ?? this.selectedBranchAliases,
      selectedCategoryNames:
      selectedCategoryNames ?? this.selectedCategoryNames,
      templateId: templateId ?? this.templateId,
      isBlocked: isBlocked ?? this.isBlocked,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Template {
  final String id;
  final String templateName;
  final bool categoryAccess;
  final bool branchAccess;
  final bool articleAccess;
  final bool overallSalesAccess;
  final bool mrpSummaryAccess;
  final bool summaryYtdOnlineAccess;
  final bool onlineDataAccess;
  final bool costAccess;
  final bool supplierAccessCreate;
  final bool purchaseCategoryAccess;
  final bool purchaseArticleAccess;
  final bool purchaseBranchAccess;
  final bool purchaseDoneReportAccess;
  final bool isOnlineBuyer;
  final bool channelReportAccess;
  final String createdAt;
  final String updatedAt;

  Template({
    required this.id,
    required this.templateName,
    required this.categoryAccess,
    required this.branchAccess,
    required this.articleAccess,
    required this.overallSalesAccess,
    required this.mrpSummaryAccess,
    required this.summaryYtdOnlineAccess,
    required this.onlineDataAccess,
    required this.costAccess,
    required this.supplierAccessCreate,
    required this.purchaseCategoryAccess,
    required this.purchaseArticleAccess,
    required this.purchaseBranchAccess,
    required this.purchaseDoneReportAccess,
    required this.isOnlineBuyer,
    required this.channelReportAccess,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json["_id"] ?? "",
      templateName: json["templateName"] ?? "",
      categoryAccess: json["categoryAccess"] ?? false,
      branchAccess: json["branchAccess"] ?? false,
      articleAccess: json["articleAccess"] ?? false,
      overallSalesAccess: json["overallSalesAccess"] ?? false,
      mrpSummaryAccess: json["mrpSummaryAccess"] ?? false,
      summaryYtdOnlineAccess: json["summaryYtdOnlineAccess"] ?? false,
      onlineDataAccess: json["onlineDataAccess"] ?? false,
      costAccess: json["costAccess"] ?? false,
      supplierAccessCreate: json["supplierAccessCreate"] ?? false,
      purchaseCategoryAccess: json["purchaseCategoryAccess"] ?? false,
      purchaseArticleAccess: json["purchaseArticleAccess"] ?? false,
      purchaseBranchAccess: json["purchaseBranchAccess"] ?? false,
      purchaseDoneReportAccess: json["purchaseDoneReportAccess"] ?? false,
      isOnlineBuyer: json["isOnlineBuyer"] ?? false,
      channelReportAccess: json["channelReportAccess"] ?? false,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "templateName": templateName,
    "categoryAccess": categoryAccess,
    "branchAccess": branchAccess,
    "articleAccess": articleAccess,
    "overallSalesAccess": overallSalesAccess,
    "mrpSummaryAccess": mrpSummaryAccess,
    "summaryYtdOnlineAccess": summaryYtdOnlineAccess,
    "onlineDataAccess": onlineDataAccess,
    "costAccess": costAccess,
    "supplierAccessCreate": supplierAccessCreate,
    "purchaseCategoryAccess": purchaseCategoryAccess,
    "purchaseArticleAccess": purchaseArticleAccess,
    "purchaseBranchAccess": purchaseBranchAccess,
    "purchaseDoneReportAccess": purchaseDoneReportAccess,
    "isOnlineBuyer": isOnlineBuyer,
    "channelReportAccess": channelReportAccess,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };

  factory Template.empty() => Template(
    id: "",
    templateName: "",
    categoryAccess: false,
    branchAccess: false,
    articleAccess: false,
    overallSalesAccess: false,
    mrpSummaryAccess: false,
    summaryYtdOnlineAccess: false,
    onlineDataAccess: false,
    costAccess: false,
    supplierAccessCreate: false,
    purchaseCategoryAccess: false,
    purchaseArticleAccess: false,
    purchaseBranchAccess: false,
    purchaseDoneReportAccess: false,
    isOnlineBuyer: false,
    channelReportAccess: false,
    createdAt: "",
    updatedAt: "",
  );
}
