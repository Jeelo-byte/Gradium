class Assignment {
  final String id;
  final String classId; // Link to the Class this assignment belongs to
  final String name;
  final String category;
  final double totalPoints;
  final double? receivedPoints; // Can be null for ungraded assignments
  final String? score; // Raw score from API (can be "CNS", "CWS", "INS", etc.)
  final String status; // e.g., "Graded", "Due", "Missing", "CNS", "CWS", "INS"
  final DateTime? dateAssigned;
  final DateTime? dateDue;
  final bool isHypothetical; // For what-if simulator

  Assignment({
    required this.id,
    required this.classId,
    required this.name,
    required this.category,
    required this.totalPoints,
    this.receivedPoints,
    this.score,
    required this.status,
    this.dateAssigned,
    this.dateDue,
    this.isHypothetical = false,
  });

  // Factory constructor for creating an Assignment from JSON (e.g., from HAC API)
  factory Assignment.fromJson(Map<String, dynamic> json) {
    String? score = json['score']?.toString();
    double? receivedPoints;
    
    // Handle different score types
    if (score != null && score.isNotEmpty) {
      if (score == 'CNS' || score == 'CWS' || score == 'INS') {
        // These don't count towards GPA
        receivedPoints = null;
      } else {
        receivedPoints = double.tryParse(score);
      }
    }

    return Assignment(
      id: json['name'] ?? '', // Use name as ID for now
      classId: json['classId'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      totalPoints: (json['totalPoints'] as num?)?.toDouble() ?? 0.0,
      receivedPoints: receivedPoints,
      score: score,
      status: _determineStatus(score),
      dateAssigned: json['dateAssigned'] != null 
          ? DateTime.tryParse(json['dateAssigned']) : null,
      dateDue: json['dateDue'] != null 
          ? DateTime.tryParse(json['dateDue']) : null,
      isHypothetical: json['isHypothetical'] ?? false,
    );
  }

  // Helper method to determine status based on score
  static String _determineStatus(String? score) {
    if (score == null || score.isEmpty) return 'Due';
    if (score == 'CNS') return 'Currently Not Scored';
    if (score == 'CWS') return 'Completed With Score';
    if (score == 'INS') return 'Incomplete';
    return 'Graded';
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
      'score': score,
      'status': status,
      'dateAssigned': dateAssigned?.toIso8601String(),
      'dateDue': dateDue?.toIso8601String(),
      'isHypothetical': isHypothetical,
    };
  }

  // Helper to calculate the score percentage for the assignment
  double? get scorePercentage {
    if (receivedPoints == null || totalPoints == 0) return null;
    return (receivedPoints! / totalPoints) * 100;
  }

  // Check if assignment counts towards GPA
  bool get countsTowardsGpa {
    if (score == null || score!.isEmpty) return false;
    return score != 'CNS' && score != 'CWS';
  }

  // Get GPA points for this assignment (0 for INS, null for CNS/CWS)
  double? get gpaPoints {
    if (!countsTowardsGpa) return null;
    if (score == 'INS') return 0.0;
    if (receivedPoints == null) return null;
    
    double percentage = (receivedPoints! / totalPoints) * 100;
    if (percentage >= 90) return 4.0;
    if (percentage >= 80) return 3.0;
    if (percentage >= 70) return 2.0;
    return 0.0;
  }

  // Method to create a copy of the assignment with updated values
  Assignment copyWith({
    String? id,
    String? classId,
    String? name,
    String? category,
    double? totalPoints,
    double? receivedPoints,
    String? score,
    String? status,
    DateTime? dateAssigned,
    DateTime? dateDue,
    bool? isHypothetical,
  }) {
    return Assignment(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      category: category ?? this.category,
      totalPoints: totalPoints ?? this.totalPoints,
      receivedPoints: receivedPoints ?? this.receivedPoints,
      score: score ?? this.score,
      status: status ?? this.status,
      dateAssigned: dateAssigned ?? this.dateAssigned,
      dateDue: dateDue ?? this.dateDue,
      isHypothetical: isHypothetical ?? this.isHypothetical,
    );
  }
}
