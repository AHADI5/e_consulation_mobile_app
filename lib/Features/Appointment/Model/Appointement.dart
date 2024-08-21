class Appointment {
  final int timePeriodID;
  final String doctorEmail;
  final String patientEmail;
  final String means;

  Appointment({
    required this.timePeriodID,
    required this.doctorEmail,
    required this.patientEmail,
    required this.means,
  });

  // Factory method to create an instance of Appointment from JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      timePeriodID: json['timePeriodID'],
      doctorEmail: json['doctorEmail'],
      patientEmail: json['patientEmail'],
      means: json['means'],
    );
  }

  // Method to convert an Appointment instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'timePeriodID': timePeriodID,
      'doctorEmail': doctorEmail,
      'patientEmail': patientEmail,
      'means': means,
    };
  }
}
