class ProfileUpdateResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileUpdateData data;
  final String timestamp;

  ProfileUpdateResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ProfileUpdateData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }
}

class ProfileUpdateData {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String userType;
  final String grade;
  final String reportingTo;
  final bool isAllBranches;
  final bool isAllCategories;
  final List<String> selectedCategories;
  final List<String> selectedBranches;
  final bool isBlocked;
  final String lastLogin;
  final String templateId;
  final String createdAt;
  final String updatedAt;
  final int v;

  ProfileUpdateData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.userType,
    required this.grade,
    required this.reportingTo,
    required this.isAllBranches,
    required this.isAllCategories,
    required this.selectedCategories,
    required this.selectedBranches,
    required this.isBlocked,
    required this.lastLogin,
    required this.templateId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ProfileUpdateData.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      password: json['password'] ?? '',
      userType: json['userType'] ?? '',
      grade: json['grade'] ?? '',
      reportingTo: json['reportingTo'] ?? '',
      isAllBranches: json['isAllBranches'] ?? false,
      isAllCategories: json['isAllCategories'] ?? false,
      selectedCategories: List<String>.from(json['selectedCategories'] ?? []),
      selectedBranches: List<String>.from(json['selectedBranches'] ?? []),
      isBlocked: json['isBlocked'] ?? false,
      lastLogin: json['lastLogin'] ?? '',
      templateId: json['templateId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'userType': userType,
      'grade': grade,
      'reportingTo': reportingTo,
      'isAllBranches': isAllBranches,
      'isAllCategories': isAllCategories,
      'selectedCategories': selectedCategories,
      'selectedBranches': selectedBranches,
      'isBlocked': isBlocked,
      'lastLogin': lastLogin,
      'templateId': templateId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'id': id,
    };
  }
}
