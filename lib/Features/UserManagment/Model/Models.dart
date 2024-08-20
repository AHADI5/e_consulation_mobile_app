// Models
class DoctorDto {
  String firstName;
  String lastName;
  String phoneNumber;
  String specialty;

  DoctorDto({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.specialty,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'specialty': specialty,
    };
  }

  factory DoctorDto.fromJson(Map<String, dynamic> json) {
    return DoctorDto(
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      specialty: json['specialty'],
    );
  }
}

class TimePeriod {
  DateTime start;
  DateTime end;
  bool isTaken;

  TimePeriod({
    required this.start,
    required this.end,
    required this.isTaken,
  });

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'isTaken': isTaken,
    };
  }
}

class TimeSlot {
  DateTime date;
  bool isFree;
  List<TimePeriod> timePeriods;

  TimeSlot({
    required this.date,
    required this.isFree,
    required this.timePeriods,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'isFree': isFree,
      'timePeriods': timePeriods.map((period) => period.toJson()).toList(),
    };
  }
}

class Schedule {
  List<TimeSlot> timeSlots;

  Schedule({
    required this.timeSlots,
  });

  Map<String, dynamic> toJson() {
    return {
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
    };
  }
}

class NewAccount {
  String email;
  String password;

  NewAccount({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class DoctorRegistrationRequest {
  DoctorDto doctorDto;
  List<Schedule> scheduleList;
  NewAccount newAccount;

  DoctorRegistrationRequest({
    required this.doctorDto,
    required this.scheduleList,
    required this.newAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorDto': doctorDto.toJson(),
      'scheduleList': scheduleList.map((schedule) => schedule.toJson()).toList(),
      'newAccount': newAccount.toJson(),
    };
  }
}

class PatientDto {
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String phoneNumber;

  PatientDto({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.phoneNumber,
  });

  // Convert a JSON map to a PatientDto instance
  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
    };
  }
}


class NewPatientRequest {
  PatientDto patientDto;
  NewAccount newAccount;

  NewPatientRequest({
    required this.patientDto,
    required this.newAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientDto': patientDto.toJson(),
      'newAccount': newAccount.toJson(),
    };
  }
}
