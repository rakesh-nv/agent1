class ReportingManagerResponse {
  bool? success;
  int? statusCode;
  String? message;
  ReportingManagerData? data;
  String? timestamp;

  ReportingManagerResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
    this.timestamp,
  });

  ReportingManagerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? ReportingManagerData.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['statusCode'] = statusCode;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    result['timestamp'] = timestamp;
    return result;
  }
}

class ReportingManagerData {
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? password;
  String? userType;
  String? grade;
  String? reportingTo;
  bool? isAllBranches;
  bool? isAllCategories;
  List<String>? selectedCategories;
  List<String>? selectedBranches;
  bool? isBlocked;
  String? templateId;
  String? createdAt;
  String? updatedAt;
  String? resetPasswordToken;
  String? resetPasswordExpires;
  int? v;

  ReportingManagerData({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.password,
    this.userType,
    this.grade,
    this.reportingTo,
    this.isAllBranches,
    this.isAllCategories,
    this.selectedCategories,
    this.selectedBranches,
    this.isBlocked,
    this.templateId,
    this.createdAt,
    this.updatedAt,
    this.resetPasswordToken,
    this.resetPasswordExpires,
    this.v,
  });

  ReportingManagerData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    userType = json['userType'];
    grade = json['grade'];
    reportingTo = json['reportingTo'];
    isAllBranches = json['isAllBranches'];
    isAllCategories = json['isAllCategories'];
    selectedCategories = json['selectedCategories'] != null
        ? List<String>.from(json['selectedCategories'])
        : [];
    selectedBranches = json['selectedBranches'] != null
        ? List<String>.from(json['selectedBranches'])
        : [];
    isBlocked = json['isBlocked'];
    templateId = json['templateId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    resetPasswordToken = json['resetPasswordToken'];
    resetPasswordExpires = json['resetPasswordExpires'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['_id'] = id;
    result['name'] = name;
    result['email'] = email;
    result['mobile'] = mobile;
    result['password'] = password;
    result['userType'] = userType;
    result['grade'] = grade;
    result['reportingTo'] = reportingTo;
    result['isAllBranches'] = isAllBranches;
    result['isAllCategories'] = isAllCategories;
    result['selectedCategories'] = selectedCategories;
    result['selectedBranches'] = selectedBranches;
    result['isBlocked'] = isBlocked;
    result['templateId'] = templateId;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    result['resetPasswordToken'] = resetPasswordToken;
    result['resetPasswordExpires'] = resetPasswordExpires;
    result['__v'] = v;
    return result;
  }
}
