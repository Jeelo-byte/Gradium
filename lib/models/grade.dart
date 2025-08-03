class Grade {
  final String id;
  final String assignmentId;
  final double score;
  final double total;
  final String classId;
  final double semesterGrade;
  final double gpaContributionUnweighted;
  final double gpaContributionWeighted;

  Grade({
    required this.id,
    required this.assignmentId,
    required this.score,
    required this.total,
    required this.classId,
    required this.semesterGrade,
    required this.gpaContributionUnweighted,
    required this.gpaContributionWeighted,
  });

  // Factory constructor for creating a Grade from JSON
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      score: (json['score'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      classId: json['classId'] as String,
      semesterGrade: (json['semesterGrade'] as num).toDouble(),
      gpaContributionUnweighted: (json['gpaContributionUnweighted'] as num).toDouble(),
      gpaContributionWeighted: (json['gpaContributionWeighted'] as num).toDouble(),
    );
  }

  // Method to convert a Grade object to JSON (e.g., for local caching)
  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'semesterGrade': semesterGrade,
      'gpaContributionUnweighted': gpaContributionUnweighted, // Consider adding toJson for other fields as needed
      'gpaContributionWeighted': gpaContributionWeighted, // Consider adding toJson for other fields as needed
    };
  }

  // Helper function to calculate unweighted GPA points based on the given scale
  double calculateUnweightedPoints(double grade) {
    if (grade >= 90) return 4.0;
    if (grade >= 80) return 3.0;
    if (grade >= 70) return 2.0;
    return 0.0;
  }

  // Helper function to calculate weighted GPA points (example - needs actual weighting logic)
  double calculateWeightedPoints(double grade, {double weightFactor = 1.0}) {
    // This is a placeholder. Real implementation would depend on course type (AP, IB, etc.)
    // and the specific weighting scale (e.g., AP may add +1 point to unweighted).
    final double unweightedPoints = calculateUnweightedPoints(grade);
    return unweightedPoints * weightFactor; // Example: apply a weight factor
  }


}
