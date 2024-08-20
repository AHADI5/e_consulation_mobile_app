import 'dart:core';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant.dart';
import '../../UserManagment/Model/Models.dart';
import '../Model/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


// AuthService
class AuthService {
  static const String _tokenKey = "auth_token";

  // Login method
  Future<bool> login(User user) async {
    const url = authUrl;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      print(JwtDecoder.decode(token));
      await _saveToken(token);
      return true;
    } else {
      print("Failed to login: ${response.body}");
      return false;
    }
  }

  // Get the auth token from SharedPreferences
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save the auth token in SharedPreferences
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Logout method
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  // Method to extract data from token
  Future<Map<String, dynamic>> decodeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception("No token found");
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken;
  }

  Future<String?> getEmailFromToken() async {
    final decodedToken = await decodeToken();
    return decodedToken['sub'];
  }

  Future<String?> getRoleFromToken() async {
    final decodedToken = await decodeToken();
    return decodedToken['role'];
  }

  // Fetch user data based on role
  Future<dynamic> fetchUserData() async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception("No token found");
    }

    final email = await getEmailFromToken();
    final role = await getRoleFromToken();

    if (email == null) {
      throw Exception("No email found in token");
    }
    if (role == null) {
      throw Exception("No role found in token");
    }

    String endpointUrl;
    if (role == 'DOCTOR') {
      endpointUrl = 'https://yourbackendurl.com/api/doctors/$email';
    } else if (role == 'PATIENT') {
      endpointUrl = 'https://yourbackendurl.com/api/patients/$email';
    } else {
      throw Exception('Unknown role: $role');
    }

    final response = await http.get(
      Uri.parse(endpointUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (role == 'DOCTOR') {
        return DoctorDto.fromJson(jsonDecode(response.body));
      } else if (role == 'PATIENT') {
        return PatientDto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Unknown role: $role');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // Method to create a new doctor account
  Future<bool> createDoctorAccount(
      DoctorRegistrationRequest doctorRequest) async {
    final response = await http.post(
      Uri.parse(doctorEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(doctorRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return true; // Account created successfully
    } else {
      print('Failed to create doctor account: ${response.body}');
      return false;
    }
  }

  // Method to create a new patient account
  Future<bool> createPatientAccount(NewPatientRequest patientRequest) async {
    final response = await http.post(
      Uri.parse(patientEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(patientRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return true; // Account created successfully
    } else {
      print('Failed to create patient account: ${response.body}');
      return false;
    }
  }
}













