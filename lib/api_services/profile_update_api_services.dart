import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/profile_update_model.dart';
import '../utils/app_constants.dart';

class ProfileUpdateApiServices {
  final String baseUrl = "https://reports-mb-dev-backend.cstechns.com/api/mobile/update-user";

  Future<ProfileUpdateResponse?> updateProfile({
    required String id,
    required String name,
    required String email,
    required String mobile,
  }) async {
    try {
      final box = Hive.box('myBox');
      final token = box.get(AppConstants.keyToken);
      print(id);
      print(name);
      print(email);
      print(mobile);
      print(token);
      if (token == null) {
        throw Exception("No token found. Please login first.");
      }

      final body = jsonEncode({"id": id, "name": name, "email": email, "mobile": mobile});

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProfileUpdateResponse.fromJson(data);
      } else {
        throw Exception("Failed to update profile: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in updateProfile: $e");
      return null;
    }
  }
}
