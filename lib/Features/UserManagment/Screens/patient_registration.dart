import 'package:flutter/material.dart';
import 'package:doctor_app/Features/Authentification/Services/auth_service.dart'; // Adjust import according to your project structure
import '../Model/Models.dart'; // Import your models

class PatientRegistrationForm extends StatefulWidget {
  const PatientRegistrationForm({super.key});

  @override
  _PatientRegistrationFormState createState() => _PatientRegistrationFormState();
}

class _PatientRegistrationFormState extends State<PatientRegistrationForm> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // State to manage the loading indicator

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _quarterController = TextEditingController();
  final _avenueController = TextEditingController();
  final _houseNumberController = TextEditingController();

  final AuthService _patientService = AuthService(); // Replace with your API endpoint

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('Personal Information'),
        content: Column(
          children: [
            _buildTextField(
              controller: _firstNameController,
              labelText: 'First Name',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _lastNameController,
              labelText: 'Last Name',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _genderController,
              labelText: 'Gender',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _birthDateController,
              labelText: 'Birth Date (YYYY-MM-DD)',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Account Information'),
        content: Column(
          children: [
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Address Information'),
        content: Column(
          children: [
            _buildTextField(
              controller: _quarterController,
              labelText: 'Quarter',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _avenueController,
              labelText: 'Avenue',
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _houseNumberController,
              labelText: 'House Number',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Future<void> _continue() async {
    if (_currentStep < _getSteps().length - 1) {
      setState(() => _currentStep += 1);
    } else {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true; // Set loading to true before making the request
        });

        // Create PatientDto
        PatientDto patientDto = PatientDto(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          gender: _genderController.text,
          birthDate: _birthDateController.text,
          phoneNumber: _phoneController.text,
        );

        // Create NewAccount
        NewAccount newAccount = NewAccount(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Create Address
        Address address = Address(
          quarter: _quarterController.text,
          avenue: _avenueController.text,
          houseNumber: int.parse(_houseNumberController.text),
        );

        // Create NewPatientRequest
        NewPatientRequest request = NewPatientRequest(
          patientDto: patientDto,
          newAccount: newAccount,
          address: address,
        );

        // Handle form submission using service
        bool success = await _patientService.createPatientAccount(request);
        setState(() {
          _isLoading = false; // Set loading to false after the request is completed
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient registered successfully!')),
          );
          Navigator.pop(context); // Optionally navigate back
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to register patient.')),
          );
        }
      }
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Patient Account'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Loader displayed while loading
      )
          : Form(
        key: _formKey,
        child: Stepper(
          steps: _getSteps(),
          currentStep: _currentStep,
          onStepContinue: _continue,
          onStepCancel: _cancel,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Continue'),
                ),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _quarterController.dispose();
    _avenueController.dispose();
    _houseNumberController.dispose();
    super.dispose();
  }
}
