import 'dart:convert';
import 'package:doctor_app/Features/Authentification/Services/auth_service.dart';
import 'package:doctor_app/constant.dart';
import 'package:http/http.dart' as http;

import '../Model/Appointement.dart';
import '../Screen/AppList.dart';


class AppointmentService {
  //final String allAppointmentsUrl = allAppointmentsEndPoint; // Replace with your API endpoint for fetching appointments
  final String createAppointmentUrl = appointmentEndpoint; // API endpoint for creating an appointment

  Future<String> _getToken() async {
    return await AuthService().getAuthToken() ?? '';
  }

  // Fetch all appointments
  Future<List<AppointmentResp>> fetchAppointments() async {
    AuthService authService = AuthService();
    final String token = await _getToken();
    final String? email = await authService.getEmailFromToken();
    final String? role = await authService.getRoleFromToken();

    if (email == null || role == null) {
      throw Exception("No email or role found in token");
    }

    final response = await http.post(
      Uri.parse(allAppointment),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'role': role,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<AppointmentResp> appointments = body
          .map((dynamic item) => AppointmentResp.fromJson(item))
          .toList();
     print(appointments);
      return appointments;
    } else {
      throw Exception('Failed to load appointments');
    }
  }


  // Create a new appointment
  Future<Appointment> createAppointment(Appointment appointment) async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse(createAppointmentUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(appointment.toJson()),
    );

    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create appointment');
    }
  }
}
