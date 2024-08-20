import 'package:doctor_app/Features/Patient/drawer_menu.dart';
import 'package:flutter/material.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
          // Replace with dynamic favorite doctors
          ListTile(
            title: const Text('Dr. John Doe'),
            subtitle: const Text('Cardiologist'),
            onTap: () {
              // Handle doctor detail view
            },
          ),
          ListTile(
            title: const Text('Dr. Jane Smith'),
            subtitle: const Text('Dermatologist'),
            onTap: () {
              // Handle doctor detail view
            },
          ),
        ],
      ),
    );
  }
}
