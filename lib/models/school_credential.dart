class SchoolCredential {
  final String schoolId;
  final String username;
  final String password;

  SchoolCredential({
    required this.schoolId,
    required this.username,
    required this.password,
  });

  factory SchoolCredential.fromJson(Map<String, dynamic> json) {
    return SchoolCredential(
      schoolId: json['schoolId'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schoolId': schoolId,
      'username': username,
      'password': password,
    };
  }
}
