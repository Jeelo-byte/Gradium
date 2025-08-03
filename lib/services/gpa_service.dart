import '../models/assignment.dart';
import '../models/class.dart';

class GpaService {
  // Calculate unweighted GPA (4.0 scale)
  static double calculateUnweightedGpa(List<Class> classes) {
    double totalPoints = 0.0;
    int totalCredits = 0;

    for (Class classItem in classes) {
      if (classItem.currentGrade != null && classItem.credits != null) {
        double gpaPoints = _gradeToGpaPoints(classItem.currentGrade!);
        totalPoints += gpaPoints * classItem.credits!;
        totalCredits += classItem.credits!.toInt();
      }
    }

    if (totalCredits == 0) return 0.0;
    return double.parse((totalPoints / totalCredits).toStringAsFixed(3));
  }

  // Calculate weighted GPA (5.0 scale)
  static double calculateWeightedGpa(List<Class> classes) {
    double totalPoints = 0.0;
    int totalCredits = 0;

    for (Class classItem in classes) {
      if (classItem.currentGrade != null && classItem.credits != null && classItem.weight != null) {
        double gpaPoints = _gradeToWeightedGpaPoints(classItem.currentGrade!, classItem.weight!);
        totalPoints += gpaPoints * classItem.credits!;
        totalCredits += classItem.credits!.toInt();
      }
    }

    if (totalCredits == 0) return 0.0;
    return double.parse((totalPoints / totalCredits).toStringAsFixed(3));
  }

  // Convert grade percentage to unweighted GPA points
  static double _gradeToGpaPoints(double grade) {
    if (grade >= 90) return 4.0;
    if (grade >= 80) return 3.0;
    if (grade >= 70) return 2.0;
    return 0.0;
  }

  // Convert grade percentage to weighted GPA points
  static double _gradeToWeightedGpaPoints(double grade, double weight) {
    double basePoints = _gradeToGpaPoints(grade);
    
    // Apply weight based on course type
    if (weight >= 6.0) {
      // AP/IB/Dual Credit courses
      return basePoints + 1.0; // Add 1.0 for weighted courses
    } else if (weight >= 5.0) {
      // Honors courses
      return basePoints + 0.5; // Add 0.5 for honors courses
    } else {
      // Regular courses
      return basePoints;
    }
  }

  // Calculate GPA from assignments
  static double calculateGpaFromAssignments(List<Assignment> assignments) {
    double totalPoints = 0.0;
    int totalAssignments = 0;

    for (Assignment assignment in assignments) {
      if (assignment.countsTowardsGpa && assignment.gpaPoints != null) {
        totalPoints += assignment.gpaPoints!;
        totalAssignments++;
      }
    }

    if (totalAssignments == 0) return 0.0;
    return double.parse((totalPoints / totalAssignments).toStringAsFixed(3));
  }

  // What-if GPA calculation for hypothetical scenarios
  static double calculateWhatIfGpa(List<Assignment> assignments, List<Assignment> hypotheticalAssignments) {
    List<Assignment> allAssignments = [...assignments, ...hypotheticalAssignments];
    return calculateGpaFromAssignments(allAssignments);
  }

  // Get GPA letter grade
  static String getGpaLetterGrade(double gpa) {
    if (gpa >= 3.7) return 'A';
    if (gpa >= 3.3) return 'A-';
    if (gpa >= 3.0) return 'B+';
    if (gpa >= 2.7) return 'B';
    if (gpa >= 2.3) return 'B-';
    if (gpa >= 2.0) return 'C+';
    if (gpa >= 1.7) return 'C';
    if (gpa >= 1.3) return 'C-';
    if (gpa >= 1.0) return 'D+';
    if (gpa >= 0.7) return 'D';
    return 'F';
  }

  // Get GPA description
  static String getGpaDescription(double gpa) {
    if (gpa >= 3.7) return 'Excellent';
    if (gpa >= 3.3) return 'Very Good';
    if (gpa >= 3.0) return 'Good';
    if (gpa >= 2.7) return 'Above Average';
    if (gpa >= 2.0) return 'Average';
    if (gpa >= 1.7) return 'Below Average';
    return 'Needs Improvement';
  }
} 