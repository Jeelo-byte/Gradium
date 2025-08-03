class Class {
  final String id;
  final String name;
  final String teacher;
  final String period;
  final String location;
  final double? currentGrade; // Optional, can be null if not available yet
  final String? courseCode;
  final String? building;
  final String? days;
  final String? markingPeriods;
  final String? room;
  final String? status;
  final double? weight;
  final double? credits;
  final String? lastUpdated;

  Class({
    required this.id,
    required this.name,
    required this.teacher,
    required this.period,
    required this.location,
    this.currentGrade,
    this.courseCode,
    this.building,
    this.days,
    this.markingPeriods,
    this.room,
    this.status,
    this.weight,
    this.credits,
    this.lastUpdated,
  });

  // Factory constructor for creating a Class from JSON (e.g., from HAC API)
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['courseCode'] ?? json['classId'] ?? '', // Use courseCode as ID if available
      name: json['courseName'] ?? json['name'] ?? '',
      teacher: json['teacher'] ?? '',
      period: json['periods'] ?? json['period'] ?? '',
      location: json['room'] ?? json['location'] ?? '',
      currentGrade: json['grade'] != null && json['grade'].toString().isNotEmpty 
          ? double.tryParse(json['grade'].toString()) : null,
      courseCode: json['courseCode'],
      building: json['building'],
      days: json['days'],
      markingPeriods: json['markingPeriods'],
      room: json['room'],
      status: json['status'],
      weight: json['weight'] != null ? double.tryParse(json['weight'].toString()) : null,
      credits: json['credits'] != null ? double.tryParse(json['credits'].toString()) : null,
      lastUpdated: json['lastUpdated'],
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
      'courseCode': courseCode,
      'building': building,
      'days': days,
      'markingPeriods': markingPeriods,
      'room': room,
      'status': status,
      'weight': weight,
      'credits': credits,
      'lastUpdated': lastUpdated,
    };
  }

  // Method to create a copy of the class with updated values
  Class copyWith({
    String? id,
    String? name,
    String? teacher,
    String? period,
    String? location,
    double? currentGrade,
    String? courseCode,
    String? building,
    String? days,
    String? markingPeriods,
    String? room,
    String? status,
    double? weight,
    double? credits,
    String? lastUpdated,
  }) {
    return Class(
      id: id ?? this.id,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      period: period ?? this.period,
      location: location ?? this.location,
      currentGrade: currentGrade ?? this.currentGrade,
      courseCode: courseCode ?? this.courseCode,
      building: building ?? this.building,
      days: days ?? this.days,
      markingPeriods: markingPeriods ?? this.markingPeriods,
      room: room ?? this.room,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      credits: credits ?? this.credits,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
