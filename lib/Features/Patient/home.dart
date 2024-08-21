import 'package:flutter/material.dart';
import 'package:doctor_app/Features/Patient/drawer_menu.dart';
import 'package:doctor_app/Features/Patient/search.dart';
import '../Doctor/Model/DoctorResponse.dart';
import '../Doctor/Screens/Doctor_info.dart';
import '../Doctor/Services/doctor_service.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DoctorService _doctorService;
  late Future<List<Doctor>> _doctors;

  @override
  void initState() {
    super.initState();
    _doctorService = DoctorService();
    _doctors = _doctorService.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docteurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DoctorSearchDelegate(),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Doctor>>(
        future: _doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildDoctorTile(context, snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDoctorTile(BuildContext context, Doctor doctor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: const AssetImage('assets/doctor.webp'), // Use default image
              radius: 30,
            ),
            title: Text('${doctor.firstName} ${doctor.lastName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor.specialty),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4.5 ? Icons.star : Icons.star_border, // Default rating
                          color: Colors.yellow,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(width: 4),
                    const Text("|"),
                    const SizedBox(width: 4),
                    const Text('30 avis'), // Default number of reviews
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                // Handle adding to favorites
              },
            ),
            onTap: () {
              // Navigate to DoctorInfoPage when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorInfoPage(
                    doctorName: '${doctor.firstName} ${doctor.lastName}',
                    specialty: doctor.specialty,
               // Default image
                    address: '123 Rue de la Santé, Paris',
                    reviews: 4.5, // Default rating
                    experience: 15, // Example data, can be dynamic
                    consultations: 500, // Example data, can be dynamic
                    isFavorite: true, // Example data, can be dynamic
                    schedule: doctor.schedules, email: doctor.email,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity, // Make the button as wide as the card
              child: ElevatedButton(
                onPressed: () {
                  // Handle appointment booking
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: const Color(0xFFE3F2FD), // Near-blue white color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Reduced border radius
                  ),
                ),
                child: const Text(
                  'Prendre un rendez-vous',
                  style: TextStyle(
                    color: Colors.blue, // Text color to match the theme
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
