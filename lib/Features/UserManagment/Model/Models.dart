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
      'taken': isTaken,
    };
  }

  // Factory constructor to create a TimePeriod from JSON
  factory TimePeriod.fromJson(Map<String, dynamic> json) {
    return TimePeriod(
      start: DateTime.parse(json['startTime']),
      end: DateTime.parse(json['endTime']),
      isTaken: json['taken'],
    );
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

// Factory constructor to create a TimeSlot from JSON
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      date: DateTime.parse(json['date']),
      isFree: json['free'],
      timePeriods: (json['timePeriods'] as List)
          .map((item) => TimePeriod.fromJson(item))
          .toList(),
    );
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
  // Factory constructor to create a Schedule from JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      timeSlots: (json['timeSlots'] as List)
          .map((item) => TimeSlot.fromJson(item))
          .toList(),
    );
  }
}

class NewAccount {
  String email;
  String password;

  NewAccount({
    required this.email,
    required this.password,
  });

  // Convert NewAccount to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Create NewAccount from JSON
  factory NewAccount.fromJson(Map<String, dynamic> json) {
    return NewAccount(
      email: json['email'],
      password: json['password'],
    );
  }
}


class DoctorRegistrationRequest {
  final DoctorDto doctorDto;
  final Address address;  // Add Address field
  final List<Schedule> scheduleList;
  final NewAccount newAccount;

  DoctorRegistrationRequest({
    required this.doctorDto,
    required this.address,  // Include Address
    required this.scheduleList,
    required this.newAccount,
  });

  // Convert DoctorRegistrationRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorDto': doctorDto.toJson(),
      'address': address.toJson(),  // Add Address to JSON
      'scheduleList': scheduleList.map((schedule) => schedule.toJson()).toList(),
      'newAccount': newAccount.toJson(),
    };
  }

  // Create DoctorRegistrationRequest from JSON
  factory DoctorRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return DoctorRegistrationRequest(
      doctorDto: DoctorDto.fromJson(json['doctorDto']),
      address: Address.fromJson(json['address']),  // Parse Address from JSON
      scheduleList: (json['scheduleList'] as List)
          .map((item) => Schedule.fromJson(item))
          .toList(),
      newAccount: NewAccount.fromJson(json['newAccount']),
    );
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
  Address address; // Added Address field

  NewPatientRequest({
    required this.patientDto,
    required this.newAccount,
    required this.address, // Added Address parameter
  });

  Map<String, dynamic> toJson() {
    return {
      'patientDto': patientDto.toJson(),
      'newAccount': newAccount.toJson(),
      'address': address.toJson(), // Convert Address to JSON
    };
  }

  factory NewPatientRequest.fromJson(Map<String, dynamic> json) {
    return NewPatientRequest(
      patientDto: PatientDto.fromJson(json['patientDto']),
      newAccount: NewAccount.fromJson(json['newAccount']),
      address: Address.fromJson(json['address']), // Convert JSON to Address
    );
  }
}

class Address {
  final String quarter;
  final String avenue;
  final int houseNumber;

  Address({
    required this.quarter,
    required this.avenue,
    required this.houseNumber,
  });

  // Convert Address to JSON
  Map<String, dynamic> toJson() {
    return {
      'quarter': quarter,
      'avenue': avenue,
      'houseNumber': houseNumber,
    };
  }

  // Create Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      quarter: json['quarter'],
      avenue: json['avenue'],
      houseNumber: json['houseNumber'],
    );
  }
}
