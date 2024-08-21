import 'package:doctor_app/Features/Authentification/Screens/login.dart';
import 'package:flutter/material.dart';

import 'Features/Authentification/Screens/Loading_screen.dart';


// Create this screen

void main() {
  runApp(const MedicalApp());
}

class MedicalApp extends StatelessWidget {
  const MedicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical App',

       debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),

      },
    );
  }
}

