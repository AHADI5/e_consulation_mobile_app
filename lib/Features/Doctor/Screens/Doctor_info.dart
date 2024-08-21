import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Add this package for loaders
import 'package:intl/intl.dart';

import '../../Appointment/Model/Appointement.dart';
import '../../Appointment/Screen/AppList.dart';
import '../../Appointment/Services/service.dart';
import '../../Authentification/Services/auth_service.dart';
import '../../UserManagment/Model/Models.dart';

class DoctorInfoPage extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String address;
  final double reviews;
  final int experience;
  final int consultations;
  final bool isFavorite;
  final List<Schedule> schedule;
  final String email;

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
    required this.email,
  });

  @override
  _DoctorInfoPageState createState() => _DoctorInfoPageState();
}

class _DoctorInfoPageState extends State<DoctorInfoPage> {
  String selectedMeans = "PHYSICAL";
  bool isLoading = false; // To manage the loader state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Docteur'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorInfoSection(),
                const SizedBox(height: 20),
                _buildStatisticsSection(),
                const SizedBox(height: 20),
                _buildMeansSelectionSection(),
                const SizedBox(height: 20),
                _buildScheduleSection(context),
              ],
            ),
          ),
          if (isLoading) _buildLoaderOverlay(), // Loader overlay when isLoading is true
        ],
      ),
    );
  }

  Widget _buildLoaderOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: SpinKitCircle(
          color: Colors.blue, // Customize loader color
          size: 80.0,
        ),
      ),
    );
  }

  Widget _buildDoctorInfoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage("assets/doctor.webp"), // Replace with actual image asset
          radius: 40,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doctorName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.specialty,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  widget.address,
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
        _buildStatisticItem(Icons.star, widget.reviews.toString(), "Review"),
        _buildStatisticItem(Icons.work, '${widget.experience}', "Experience"),
        _buildStatisticItem(Icons.medical_services, '${widget.consultations}', "Consultations"),
        _buildStatisticItem(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border, "", "Favorite"),
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

  Widget _buildMeansSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choisissez le type de rendez-vous',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMeansOption(Icons.videocam, "VIDEO"),
            _buildMeansOption(Icons.message, "MESSAGE"),
            _buildMeansOption(Icons.person, "PHYSICAL"),
          ],
        ),
      ],
    );
  }

  Widget _buildMeansOption(IconData icon, String means) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMeans = means;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: selectedMeans == means ? Colors.blue : Colors.blueGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: selectedMeans == means ? Colors.white : Colors.blue,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            means,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selectedMeans == means ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Format for date
    final DateFormat timeFormat = DateFormat('HH:mm'); // Format for time

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horaires',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.schedule.expand((schedule) {
          return schedule.timeSlots.expand((timeSlot) {
            return timeSlot.timePeriods.map((period) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    '${dateFormat.format(timeSlot.date)} ${timeFormat.format(period.start)} - ${timeFormat.format(period.end)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    onPressed: period.isTaken
                        ? null
                        : () async {
                      if (period.id != null) {
                        await _bookAppointment(context, period.id!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: period.isTaken ? Colors.grey : Colors.blue,
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

  Future<void> _bookAppointment(BuildContext context, int timePeriodID) async {
    setState(() {
      isLoading = true; // Start the loader
    });

    AuthService authService = AuthService();

    // Fetch the patient email from the token
    String? patientEmail = await authService.getEmailFromToken();

    if (patientEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to retrieve patient email')),
      );
      setState(() {
        isLoading = false; // Stop the loader
      });
      return;
    }

    String doctorEmail = widget.email;
    String means = selectedMeans;

    Appointment appointment = Appointment(
      timePeriodID: timePeriodID,
      doctorEmail: doctorEmail,
      patientEmail: patientEmail,
      means: means,
    );

    try {
      AppointmentService appointmentService = AppointmentService();
      await appointmentService.createAppointment(appointment);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment booked successfully!')),
      );

      // Navigate to the list of appointments after successful booking
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AppointmentListPage(appointments: [],)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book appointment')),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop the loader
      });
    }
  }
}




