import 'package:flutter/material.dart';

import '../../UserManagment/Model/Models.dart';

class DoctorInfoPage extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String address;
  final double reviews;
  final int experience; // Years of experience
  final int consultations;
  final bool isFavorite;
  final List<Schedule> schedule; // Schedule list with time slots and availability

  const DoctorInfoPage({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.address,
    required this.reviews,
    required this.experience,
    required this.consultations,
    required this.isFavorite,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Docteur'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorInfoSection(),
            const SizedBox(height: 20),
            _buildStatisticsSection(),
            const SizedBox(height: 20),
            _buildScheduleSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(""),
          radius: 40,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              specialty,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  address,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatisticItem(Icons.star, reviews.toString(), "Review"),
        _buildStatisticItem(Icons.work, '$experience', "Experience"),
        _buildStatisticItem(Icons.medical_services, '$consultations', "Consultations"),
        _buildStatisticItem(
            isFavorite ? Icons.favorite : Icons.favorite_border, "", "Favorite"),
      ],
    );
  }

  Widget _buildStatisticItem(IconData icon, String value, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 30),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Text(
              "+",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horaires',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...schedule.expand((schedule) {
          return schedule.timeSlots.expand((timeSlot) {
            return timeSlot.timePeriods.map((period) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    '${timeSlot.date.toLocal().toShortDateString()} ${period.start.toLocal().toShortTimeString()} - ${period.end.toLocal().toShortTimeString()}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    onPressed: period.isTaken
                        ? null
                        : () {
                      // Handle booking action
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: period.isTaken ? Colors.grey : Colors.blue,
                    ),
                    child: Text(period.isTaken ? 'Réservé' : 'Réserver'),
                  ),
                ),
              );
            }).toList();
          }).toList();
        }).toList(),
      ],
    );
  }
}

extension DateTimeFormatting on DateTime {
  String toShortDateString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year}';
  }

  String toShortTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
