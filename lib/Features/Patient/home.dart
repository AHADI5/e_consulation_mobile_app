import 'package:flutter/material.dart';
import 'package:doctor_app/Features/Patient/drawer_menu.dart';
import 'package:doctor_app/Features/Patient/search.dart';


import '../Doctor/Screens/Doctor_info.dart';
import '../UserManagment/Model/Models.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: ListView(
        children: [
          _buildDoctorTile(
            context,
            'Dr. John Doe',
            'Cardiologue',
            'assets/doctor.webp',
            4.8, // Star rating
            45, // Number of reviews
          ),
          _buildDoctorTile(
            context,
            'Dr. Jane Smith',
            'Dermatologue',
            'assets/doctor.webp',
            4.5, // Star rating
            30, // Number of reviews
          ),
          // Add more doctors here
        ],
      ),
    );
  }

  Widget _buildDoctorTile(
      BuildContext context,
      String name,
      String specialty,
      String profilePic,
      double rating, // Star rating
      int reviews, // Number of reviews
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(profilePic),
              radius: 30,
            ),
            title: Text(name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(specialty),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(width: 4),
                    const Text("|"),
                    const SizedBox(width: 4),
                    Text('$reviews avis'),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.favorite_border),
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
                    doctorName: name,
                    specialty: specialty,
                    profilePic: profilePic,
                    address: '123 Rue de la Santé, Paris',
                    reviews: rating,
                    experience: 15, // Example data, can be dynamic
                    consultations: 500, // Example data, can be dynamic
                    isFavorite: true, // Example data, can be dynamic
                    schedule: [
                      Schedule(
                        timeSlots: [
                          TimeSlot(
                            date: DateTime.now(),
                            isFree: true,
                            timePeriods: [
                              TimePeriod(
                                start: DateTime.now().add(Duration(hours: 1)),
                                end: DateTime.now().add(Duration(hours: 2)),
                                isTaken: true,
                              ),
                              TimePeriod(
                                start: DateTime.now().add(Duration(hours: 2)),
                                end: DateTime.now().add(Duration(hours: 3)),
                                isTaken: false,
                              ),
                              TimePeriod(
                                start: DateTime.now().add(Duration(hours: 3)),
                                end: DateTime.now().add(Duration(hours: 4)),
                                isTaken: false,
                              ),
                            ],
                          ),
                          // Add more TimeSlot entries here
                        ],
                      ),
                      // Add more Schedule entries here if needed
                    ],
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
