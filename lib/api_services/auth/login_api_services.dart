import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../model/login_model.dart';

class LoginApiService {
  final String baseUrl = "https://reports-mb-dev-backend.cstechns.com/api/auth/login";

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("--------Login response status----------: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("--------Login response status----------: ${response.body}");
        final jsonData = jsonDecode(response.body);
        // print("Parsed JSON: $jsonData");
        return LoginResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception("Invalid credentials. Please check email/password.");
      } else if (response.statusCode == 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception(
          "Login failed. Status code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
