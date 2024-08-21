import 'package:flutter/material.dart';
import 'package:doctor_app/Features/Authentification/Services/auth_service.dart';

// Models for request data (replace with actual imports)
import '../Model/Models.dart';

class DoctorRegistrationForm extends StatefulWidget {
  @override
  _DoctorRegistrationFormState createState() => _DoctorRegistrationFormState();
}

class _DoctorRegistrationFormState extends State<DoctorRegistrationForm> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _quarterController = TextEditingController();
  final _avenueController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final AuthService _doctorService = AuthService();

  final Map<String, List<TimeOfDay>> _schedule = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  void _selectTime(BuildContext context, String day) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _schedule[day]!.add(picked);
      });
    }
  }

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
              controller: _phoneController,
              labelText: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Professional Information'),
        content: Column(
          children: [
            _buildTextField(
              controller: _specialtyController,
              labelText: 'Specialty',
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
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Schedule Setup'),
        content: Column(
          children: _schedule.keys.map((day) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _selectTime(context, day),
                      icon: const Icon(Icons.add, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      label: const Text('Add Time Slot'),
                    ),
                    const SizedBox(width: 20),
                    Wrap(
                      spacing: 10.0,
                      children: _schedule[day]!.map((time) {
                        return Chip(
                          label: Text(time.format(context)),
                          onDeleted: () {
                            setState(() {
                              _schedule[day]!.remove(time);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
        isActive: _currentStep >= 4,
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
        // Create DoctorDto
        DoctorDto doctorDto = DoctorDto(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneController.text,
          specialty: _specialtyController.text,
        );

        // Create Address
        Address address = Address(
          quarter: _quarterController.text,
          avenue: _avenueController.text,
          houseNumber: int.parse(_houseNumberController.text),
        );

        // Create NewAccount
        NewAccount newAccount = NewAccount(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Create Schedule
        List<Schedule> schedules = _schedule.keys.map((day) {
          List<TimeSlot> timeSlots = [
            TimeSlot(
              date: DateTime.now(), // Replace with actual date if needed
              isFree: true,
              timePeriods: _schedule[day]!.map((time) {
                return TimePeriod(
                  start: DateTime(2024, 1, 1, time.hour, time.minute),
                  end: DateTime(2024, 1, 1, time.hour + 1, time.minute), // Adjust end time as needed
                  isTaken: false
                );
              }).toList(),
            ),
          ];

          return Schedule(timeSlots: timeSlots);
        }).toList();

        // Create DoctorRegistrationRequest
        DoctorRegistrationRequest request = DoctorRegistrationRequest(
          doctorDto: doctorDto,
          address: address,
          scheduleList: schedules,
          newAccount: newAccount,
        );

        // Handle form submission
        // For example, send request to your API
        // Handle form submission using service
        bool success = await _doctorService.createDoctorAccount(request);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor registered successfully!')),
          );
          Navigator.pop(context); // Optionally navigate back
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to register doctor.')),
          );
        }
        print(request.toJson());
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
        title: const Text('Register Doctor Account'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
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
                  ),
                  child: Text(_currentStep == _getSteps().length - 1 ? 'Submit' : 'Next'),
                ),
                ElevatedButton(
                  onPressed: details.onStepCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Back'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
