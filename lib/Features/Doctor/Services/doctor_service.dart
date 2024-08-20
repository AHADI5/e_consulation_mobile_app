import 'dart:convert';
import 'package:doctor_app/Features/Authentification/Services/auth_service.dart';
import 'package:doctor_app/constant.dart';
import 'package:http/http.dart' as http;

import '../Model/DoctorResponse.dart';

class DoctorService {
  final String allDoctorsUrl = allDoctorsEndPoint; // Replace with your API base URL

  Future<String> _getToken() async {
    return await AuthService().getAuthToken() ?? '';
  }

  Future<List<Doctor>> fetchDoctors() async {
    // Fetch the token asynchronously
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse(allDoctorsUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Doctor> doctors = body.map((dynamic item) => Doctor.fromJson(item)).toList();
      print(doctors);
      return doctors;
    } else {
      throw Exception('Failed to load doctors');
    }
  }
}
