import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/assignment.dart';
import '../models/class.dart';
import '../models/user_profile.dart';
import '../models/school_credential.dart';
import '../models/leaderboard_entry.dart';
import 'hac_api_service.dart';
import 'data_service.dart';
import 'gpa_service.dart';

class AcademicService {
  final HacApiService _hacApiService = HacApiService();
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sync all academic data from HAC API
  Future<Map<String, dynamic>> syncAcademicData() async {
    try {
      final credentials = await DataService.getCredentials();
      if (credentials == null) {
        throw Exception('No school credentials found');
      }

      // Fetch all data from HAC API
      final studentInfo = await _hacApiService.getStudentInfo(
        credentials.username, 
        credentials.password
      );
      
      final gpaData = await _hacApiService.getStudentGpa(
        credentials.username, 
        credentials.password
      );
      
      final scheduleData = await _hacApiService.getStudentSchedule(
        credentials.username, 
        credentials.password
      );
      
      final currentClassesData = await _hacApiService.getCurrentClasses(
        credentials.username, 
        credentials.password
      );

      // Process and cache the data
      final classes = _processScheduleData(scheduleData);
      final assignments = _processCurrentClassesData(currentClassesData);
      
      // Cache the processed data
      await DataService.cacheClasses(classes);
      await DataService.cacheAssignments(assignments);
      await DataService.updateLastSync();

      // Update user profile with latest info
      await _updateUserProfile(studentInfo, gpaData);

      return {
        'success': true,
        'classes': classes,
        'assignments': assignments,
        'studentInfo': studentInfo,
        'gpaData': gpaData,
      };
    } catch (e) {
      // If sync fails, return cached data
      final cachedClasses = await DataService.getCachedClasses();
      final cachedAssignments = await DataService.getCachedAssignments();
      
      return {
        'success': false,
        'error': e.toString(),
        'classes': cachedClasses,
        'assignments': cachedAssignments,
        'message': 'Unable to load grades. Showing cached data.',
      };
    }
  }

  // Process schedule data from HAC API
  List<Class> _processScheduleData(Map<String, dynamic> scheduleData) {
    final List<Class> classes = [];
    final studentSchedule = scheduleData['studentSchedule'] as List?;

    if (studentSchedule != null) {
      for (var classData in studentSchedule) {
        classes.add(Class.fromJson(classData));
      }
    }

    return classes;
  }

  // Process current classes data from HAC API
  List<Assignment> _processCurrentClassesData(Map<String, dynamic> currentClassesData) {
    final List<Assignment> assignments = [];
    final currentClasses = currentClassesData['currentClasses'] as List?;

    if (currentClasses != null) {
      for (var classData in currentClasses) {
        final classId = classData['name'] ?? '';
        final assignmentsList = classData['assignments'] as List?;

        if (assignmentsList != null) {
          for (var assignmentData in assignmentsList) {
            assignmentData['classId'] = classId;
            assignments.add(Assignment.fromJson(assignmentData));
          }
        }
      }
    }

    return assignments;
  }

  // Update user profile with latest information
  Future<void> _updateUserProfile(Map<String, dynamic> studentInfo, Map<String, dynamic> gpaData) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final profile = UserProfile(
      id: user.id,
      username: studentInfo['name'] ?? user.email?.split('@').first,
      optInLeaderboard: false, // Default to false for privacy
      nameVisibility: 'full',
      gpaVisibility: 'hidden',
    );

    // Update profile in Supabase
    await _supabase
        .from('profiles')
        .upsert(profile.toJson())
        .eq('id', user.id);

    // Store locally
    await DataService.storeUserProfile(profile);
  }

  // Get cached academic data
  Future<Map<String, dynamic>> getCachedAcademicData() async {
    final classes = await DataService.getCachedClasses();
    final assignments = await DataService.getCachedAssignments();
    final profile = await DataService.getUserProfile();

    return {
      'classes': classes,
      'assignments': assignments,
      'profile': profile,
    };
  }

  // Calculate GPAs
  Future<Map<String, double>> calculateGpas(List<Class> classes) async {
    final unweightedGpa = GpaService.calculateUnweightedGpa(classes);
    final weightedGpa = GpaService.calculateWeightedGpa(classes);

    return {
      'unweighted': unweightedGpa,
      'weighted': weightedGpa,
    };
  }

  // Update leaderboard participation
  Future<void> updateLeaderboardParticipation({
    required bool optIn,
    required String nameVisibility,
    required String gpaVisibility,
    double? gpa,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Update profile
    await _supabase
        .from('profiles')
        .update({
          'opt_in_leaderboard': optIn,
          'name_visibility': nameVisibility,
          'gpa_visibility': gpaVisibility,
        })
        .eq('id', user.id);

    // Update leaderboard scores if opting in
    if (optIn && gpa != null) {
      await _supabase
          .from('leaderboard_scores')
          .upsert({
            'user_id': user.id,
            'encrypted_gpa': gpa.toString(), // In production, this should be encrypted
            'last_updated': DateTime.now().toIso8601String(),
          })
          .eq('user_id', user.id);
    } else if (!optIn) {
      // Remove from leaderboard if opting out
      await _supabase
          .from('leaderboard_scores')
          .delete()
          .eq('user_id', user.id);
    }

    // Update local profile
    final profile = await DataService.getUserProfile();
    if (profile != null) {
      final updatedProfile = profile.copyWith(
        optInLeaderboard: optIn,
        nameVisibility: nameVisibility,
        gpaVisibility: gpaVisibility,
      );
      await DataService.storeUserProfile(updatedProfile);
    }
  }

  // Get leaderboard data
  Future<List<LeaderboardEntry>> getLeaderboardData() async {
    final response = await _supabase
        .from('leaderboard_scores')
        .select('''
          user_id,
          encrypted_gpa,
          last_updated,
          profiles!inner(
            username,
            name_visibility,
            gpa_visibility
          )
        ''')
        .order('encrypted_gpa', ascending: false);

    final List<LeaderboardEntry> entries = [];
    
    for (var row in response) {
      final profile = row['profiles'] as Map<String, dynamic>;
      final gpa = double.tryParse(row['encrypted_gpa'] ?? '0') ?? 0.0;
      
      entries.add(LeaderboardEntry(
        userId: row['user_id'],
        username: _getDisplayName(profile['name_visibility'], profile['username']),
        gpa: _getDisplayGpa(profile['gpa_visibility'], gpa),
        rank: entries.length + 1,
        lastUpdated: DateTime.parse(row['last_updated']),
      ));
    }

    return entries;
  }

  // Helper method to get display name based on visibility settings
  String _getDisplayName(String visibility, String? username) {
    switch (visibility) {
      case 'full':
        return username ?? 'Anonymous';
      case 'nickname':
        return username?.split(' ').first ?? 'Anonymous';
      case 'anonymized':
        return 'Student ${username?.hashCode.toString().substring(0, 4)}';
      default:
        return 'Anonymous';
    }
  }

  // Helper method to get display GPA based on visibility settings
  String _getDisplayGpa(String visibility, double gpa) {
    switch (visibility) {
      case 'exact':
        return gpa.toStringAsFixed(3);
      case 'range':
        if (gpa >= 3.7) return '3.7+';
        if (gpa >= 3.3) return '3.3-3.69';
        if (gpa >= 3.0) return '3.0-3.29';
        if (gpa >= 2.7) return '2.7-2.99';
        if (gpa >= 2.0) return '2.0-2.69';
        return '< 2.0';
      case 'hidden':
      default:
        return '***';
    }
  }

  // Store school credentials
  Future<void> storeSchoolCredentials(String username, String password) async {
    final credentials = SchoolCredential(
      username: username,
      password: password,
      district: 'Frisco ISD',
    );
    
    await DataService.storeCredentials(credentials);
  }

  // Clear all data (for logout)
  Future<void> clearAllData() async {
    await DataService.clearAllData();
  }
} 