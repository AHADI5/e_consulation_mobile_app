import 'package:flutter/material.dart';
import 'package:doctor_app/Features/Patient/drawer_menu.dart';

class AppointmentRequest {
  final int id;
  final String patientName;
  final DateTime appointmentDate;
  final String reason;
  bool isAccepted;

  AppointmentRequest({
    required this.id,
    required this.patientName,
    required this.appointmentDate,
    required this.reason,
    this.isAccepted = false,
  });
}

class DoctorHomePage extends StatelessWidget {
  final List<AppointmentRequest> appointmentRequests = [
    AppointmentRequest(
      id: 1,
      patientName: 'Alice Johnson',
      appointmentDate: DateTime.now().add(Duration(days: 1)),
      reason: 'Routine check-up',
    ),
    AppointmentRequest(
      id: 2,
      patientName: 'Bob Williams',
      appointmentDate: DateTime.now().add(Duration(days: 2)),
      reason: 'Follow-up on blood test results',
    ),
    // Add more appointment requests as needed
  ];

  DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests de Rendez-vous'),
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: appointmentRequests.length,
        itemBuilder: (context, index) {
          return _buildAppointmentTile(context, appointmentRequests[index]);
        },
      ),
    );
  }

  Widget _buildAppointmentTile(BuildContext context, AppointmentRequest appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient: ${appointment.patientName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text('Date: ${appointment.appointmentDate}'),
            const SizedBox(height: 8.0),
            Text('Raison: ${appointment.reason}'),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _acceptAppointment(context, appointment);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Accepter'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _declineAppointment(context, appointment);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Décliner'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _acceptAppointment(BuildContext context, AppointmentRequest appointment) {
    appointment.isAccepted = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rendez-vous accepté pour ${appointment.patientName}')),
    );
  }

  void _declineAppointment(BuildContext context, AppointmentRequest appointment) {
    appointment.isAccepted = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rendez-vous décliné pour ${appointment.patientName}')),
    );
  }
}
