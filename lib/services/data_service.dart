import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/assignment.dart';
import '../models/class.dart';
import '../models/user_profile.dart';
import '../models/school_credential.dart';

class DataService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _classesKey = 'cached_classes';
  static const String _assignmentsKey = 'cached_assignments';
  static const String _userProfileKey = 'user_profile';
  static const String _credentialsKey = 'school_credentials';
  static const String _lastSyncKey = 'last_sync';

  // Cache classes locally
  static Future<void> cacheClasses(List<Class> classes) async {
    final prefs = await SharedPreferences.getInstance();
    final classesJson = classes.map((c) => c.toJson()).toList();
    await prefs.setString(_classesKey, jsonEncode(classesJson));
  }

  // Get cached classes
  static Future<List<Class>> getCachedClasses() async {
    final prefs = await SharedPreferences.getInstance();
    final classesString = prefs.getString(_classesKey);
    if (classesString == null) return [];

    try {
      final classesJson = jsonDecode(classesString) as List;
      return classesJson.map((json) => Class.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Cache assignments locally
  static Future<void> cacheAssignments(List<Assignment> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsJson = assignments.map((a) => a.toJson()).toList();
    await prefs.setString(_assignmentsKey, jsonEncode(assignmentsJson));
  }

  // Get cached assignments
  static Future<List<Assignment>> getCachedAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsString = prefs.getString(_assignmentsKey);
    if (assignmentsString == null) return [];

    try {
      final assignmentsJson = jsonDecode(assignmentsString) as List;
      return assignmentsJson.map((json) => Assignment.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Store school credentials securely
  static Future<void> storeCredentials(SchoolCredential credentials) async {
    await _secureStorage.write(
      key: _credentialsKey,
      value: jsonEncode(credentials.toJson()),
    );
  }

  // Get stored school credentials
  static Future<SchoolCredential?> getCredentials() async {
    final credentialsString = await _secureStorage.read(key: _credentialsKey);
    if (credentialsString == null) return null;

    try {
      final credentialsJson = jsonDecode(credentialsString);
      return SchoolCredential.fromJson(credentialsJson);
    } catch (e) {
      return null;
    }
  }

  // Clear stored credentials
  static Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _credentialsKey);
  }

  // Store user profile
  static Future<void> storeUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
  }

  // Get stored user profile
  static Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileString = prefs.getString(_userProfileKey);
    if (profileString == null) return null;

    try {
      final profileJson = jsonDecode(profileString);
      return UserProfile.fromJson(profileJson);
    } catch (e) {
      return null;
    }
  }

  // Update last sync timestamp
  static Future<void> updateLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Get last sync timestamp
  static Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncKey);
    if (lastSyncString == null) return null;

    try {
      return DateTime.parse(lastSyncString);
    } catch (e) {
      return null;
    }
  }

  // Check if data is stale (older than 1 hour)
  static Future<bool> isDataStale() async {
    final lastSync = await getLastSync();
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);
    return difference.inHours >= 1;
  }

  // Clear all cached data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_classesKey);
    await prefs.remove(_assignmentsKey);
    await prefs.remove(_userProfileKey);
    await prefs.remove(_lastSyncKey);
    await clearCredentials();
  }

  // Store hypothetical assignments (for what-if simulator)
  static Future<void> storeHypotheticalAssignments(List<Assignment> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsJson = assignments.map((a) => a.toJson()).toList();
    await prefs.setString('hypothetical_assignments', jsonEncode(assignmentsJson));
  }

  // Get hypothetical assignments
  static Future<List<Assignment>> getHypotheticalAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsString = prefs.getString('hypothetical_assignments');
    if (assignmentsString == null) return [];

    try {
      final assignmentsJson = jsonDecode(assignmentsString) as List;
      return assignmentsJson.map((json) => Assignment.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Clear hypothetical assignments
  static Future<void> clearHypotheticalAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hypothetical_assignments');
  }
} 