import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String? username;
  final String? avatarUrl;
  final bool optInLeaderboard;
  final String nameVisibility;
  final String gpaVisibility;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.username,
    this.avatarUrl,
    this.optInLeaderboard = false,
    this.nameVisibility = 'full',
    this.gpaVisibility = 'hidden',
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      username: map['username'],
      avatarUrl: map['avatar_url'],
      optInLeaderboard: map['opt_in_leaderboard'] ?? false,
      nameVisibility: map['name_visibility'] ?? 'full',
      gpaVisibility: map['gpa_visibility'] ?? 'hidden',
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'opt_in_leaderboard': optInLeaderboard,
      'name_visibility': nameVisibility,
      'gpa_visibility': gpaVisibility,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Method to create a default profile for a new user if needed
  static UserProfile fromAuthUser(User user) {
    return UserProfile(
      id: user.id,
      username: user.email?.split('@').first, // Use email prefix as default username
      avatarUrl: user.userMetadata?['avatar_url'],
      optInLeaderboard: false,
      nameVisibility: 'full',
      gpaVisibility: 'hidden',
    );
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    bool? optInLeaderboard,
    String? nameVisibility,
    String? gpaVisibility,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      optInLeaderboard: optInLeaderboard ?? this.optInLeaderboard,
      nameVisibility: nameVisibility ?? this.nameVisibility,
      gpaVisibility: gpaVisibility ?? this.gpaVisibility,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
