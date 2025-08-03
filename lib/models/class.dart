class Class {
  final String id;
  final String name;
  final String teacher;
  final String period;
  final String location;
  final double? currentGrade; // Optional, can be null if not available yet

  Class({
    required this.id,
    required this.name,
    required this.teacher,
    required this.period,
    required this.location,
    this.currentGrade,
  });

  // Factory constructor for creating a Class from JSON (e.g., from HAC API)
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['classId'] as String, // Assuming an ID field from the API
      name: json['name'] as String,
      teacher: json['teacher'] as String,
      period: json['period'] as String,
      location: json['location'] as String,
      currentGrade: (json['currentGrade'] as num?)?.toDouble(), // Handle nullability and type casting
    );
  }

  // Method to convert a Class object to JSON (e.g., for local caching)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'period': period,
    };
  }
}
class Class {
  final String id;
  final String name;
  final String teacher;
  final String period;
  final String location;
  final double? currentGrade; // Optional, can be null if not available yet

  Class({
    required this.id,
    required this.name,
    required this.teacher,
    required this.period,
    required this.location,
    this.currentGrade,
  });

  // Factory constructor for creating a Class from JSON (e.g., from HAC API)
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['classId'] as String, // Assuming an ID field from the API
      name: json['name'] as String,
      teacher: json['teacher'] as String,
      period: json['period'] as String,
      location: json['location'] as String,
      currentGrade: (json['currentGrade'] as num?)?.toDouble(), // Handle nullability and type casting
    );
  }

  // Method to convert a Class object to JSON (e.g., for local caching)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'period': period,
      'location': location,
      'currentGrade': currentGrade,
    };
  }
}
