import '../../UserManagment/Model/Models.dart';

class Doctor {
  final int doctorId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String specialty;
  //final ProfilePic profilePic;
  final List<Schedule> schedules;

  Doctor({
    required this.doctorId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.specialty,
   // required this.profilePic,
    required this.schedules,
  });

  // Add factory constructor for creating a Doctor from JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      specialty: json['specialty'],

      schedules: (json['schedules'] as List)
          .map((schedule) => Schedule.fromJson(schedule))
          .toList(),
    );
  }

  // Method to convert a Doctor object to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'specialty': specialty,
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
    };
  }
}
