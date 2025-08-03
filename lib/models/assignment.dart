class Assignment {
  final String id;
  final String classId; // Link to the Class this assignment belongs to
  final String name;
  final String category;
  final double totalPoints;
  final double receivedPoints;
  final String status; // e.g., "Graded", "Due", "Missing", "CNS", "CWS", "INS"
  final DateTime dueDate;
  final bool isHypothetical; // For what-if simulator

  Assignment({
    required this.id,
    required this.classId,
    required this.name,
    required this.category,
    required this.totalPoints,
    required this.receivedPoints,
    required this.status,
    required this.dueDate,
    this.isHypothetical = false,
  });

  // Factory constructor for creating an Assignment from JSON (e.g., from HAC API)
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['assignmentId'] as String, // Assuming an ID field from the API
      classId: json['classId'] as String, // Assuming a class ID link from the API
      name: json['name'] as String,
      category: json['category'] as String,
      totalPoints: (json['totalPoints'] as num).toDouble(),
      receivedPoints: (json['receivedPoints'] as num).toDouble(),
      status: json['status'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      isHypothetical: json['isHypothetical'] ?? false,
    );
  }

  // Method to convert an Assignment object to JSON (e.g., for local caching)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'name': name,
      'category': category,
      'totalPoints': totalPoints,
      'receivedPoints': receivedPoints,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'isHypothetical': isHypothetical,
    };
  }

  // Helper to calculate the score percentage for the assignment
  double get scorePercentage => (receivedPoints / totalPoints) * 100;

  // Method to create a copy of the assignment with updated values
  Assignment copyWith({
    String? id,
    String? classId,
    String? name,
    String? category,
    double? totalPoints,
    double? receivedPoints,
    String? status,
    DateTime? dueDate,
    bool? isHypothetical,
  }) {
    return Assignment(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      category: category ?? this.category,
      totalPoints: totalPoints ?? this.totalPoints,
      receivedPoints: receivedPoints ?? this.receivedPoints,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      isHypothetical: isHypothetical ?? this.isHypothetical,
    );
  }
}
