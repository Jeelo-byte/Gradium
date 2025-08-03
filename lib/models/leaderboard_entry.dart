class LeaderboardEntry {
  final String userId;
  final String username;
  final double score; // Assuming score is still needed for internal logic
  final String gpa;
  final DateTime lastUpdated;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
    required this.gpa,
    required this.lastUpdated,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'],
      username: json['username'],
      score: (json['score'] as num).toDouble(), // Ensure score is a double
      gpa: json['gpa'],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'score': score,
      'gpa': gpa,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}