import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Define a model for Appointment
class AppointmentResp {
    final int appointmentID;
    final DateTime startTime;
    final DateTime endTime;
    final String appointmentState;
    final String means;

    AppointmentResp({
        required this.appointmentID,
                required this.startTime,
                required this.endTime,
                required this.appointmentState,
                required this.means,
    });

    factory AppointmentResp.fromJson(Map<String, dynamic> json) {
        return AppointmentResp(
                appointmentID: json['appointmentID'],
                startTime: DateTime.parse(json['startTime']),
                endTime: DateTime.parse(json['endTime']),
                appointmentState: json['appointmentState'],
                means: json['means'],
    );
    }
}

class AppointmentListPage extends StatelessWidget {
    final List<AppointmentResp> appointments;

  const AppointmentListPage({super.key, required this.appointments});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
                appBar: AppBar(
                title: const Text('My Appointments'),
      ),
        body: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4,
                    child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                    'Appointment ${appointment.appointmentID}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
            Text(
                    'Start: ${DateFormat('yyyy-MM-dd HH:mm').format(appointment.startTime)}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
            Text(
                    'End: ${DateFormat('yyyy-MM-dd HH:mm').format(appointment.endTime)}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
            Text(
                    'State: ${appointment.appointmentState}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
            Text(
                    'Means: ${appointment.means}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            trailing: _buildActionButton(appointment.appointmentState),
            ),
          );
        },
      ),
    );
    }

    Widget _buildActionButton(String state) {
        switch (state) {
            case 'PENDING':
                return ElevatedButton(
                        onPressed: () {
                // Handle action for pending appointment
            },
            child: const Text('Confirm'),
        );
            case 'CONFIRMED':
                return const Text(
                    'Confirmed',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        );
            case 'CANCELLED':
                return const Text(
                    'Cancelled',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
            default:
                return const SizedBox.shrink(); // Empty widget if state is unknown
        }
    }
}
