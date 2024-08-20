import 'package:flutter/material.dart';

import 'drawer_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'PILLAR MULENDA',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('pillarmulenda@gmail.com'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle logout or other actions
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
