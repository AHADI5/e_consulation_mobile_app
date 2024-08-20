class User {
  final String email;
  final String password;

  User({
    required this.email,
    required this.password,
  });

  // Factory method to create a User instance from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['username'],
      password: json['password'],
    );
  }

  // Convert a User instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'username': email,
      'password': password,
    };
  }
}
