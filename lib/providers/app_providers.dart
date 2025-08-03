import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/assignment.dart';
import '../models/class.dart';
import '../models/user_profile.dart';
import '../models/leaderboard_entry.dart';
import '../services/academic_service.dart';
import '../services/data_service.dart';

// Academic Service Provider
final academicServiceProvider = Provider<AcademicService>((ref) {
  return AcademicService();
});

// Authentication State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) => event.session?.user);
});

// User Profile Provider
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  return await DataService.getUserProfile();
});

// Classes Provider
final classesProvider = FutureProvider<List<Class>>((ref) async {
  return await DataService.getCachedClasses();
});

// Assignments Provider
final assignmentsProvider = FutureProvider<List<Assignment>>((ref) async {
  return await DataService.getCachedAssignments();
});

// GPA Provider
final gpaProvider = FutureProvider<Map<String, double>>((ref) async {
  final classes = await ref.watch(classesProvider.future);
  final academicService = ref.watch(academicServiceProvider);
  return await academicService.calculateGpas(classes);
});

// Academic Data Provider
final academicDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final academicService = ref.watch(academicServiceProvider);
  return await academicService.getCachedAcademicData();
});

// Sync Status Provider
final syncStatusProvider = StateProvider<bool>((ref) => false);

// Sync Error Provider
final syncErrorProvider = StateProvider<String?>((ref) => null);

// Leaderboard Provider
final leaderboardProvider = FutureProvider<List<LeaderboardEntry>>((ref) async {
  final academicService = ref.watch(academicServiceProvider);
  return await academicService.getLeaderboardData();
});

// What-if Simulator Provider
final whatIfAssignmentsProvider = StateProvider<List<Assignment>>((ref) => []);

// Loading States
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Notifier for syncing academic data
class AcademicDataNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final AcademicService _academicService;

  AcademicDataNotifier(this._academicService) : super(const AsyncValue.loading());

  Future<void> syncData() async {
    state = const AsyncValue.loading();
    try {
      final result = await _academicService.syncAcademicData();
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadCachedData() async {
    state = const AsyncValue.loading();
    try {
      final result = await _academicService.getCachedAcademicData();
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final academicDataNotifierProvider = StateNotifierProvider<AcademicDataNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final academicService = ref.watch(academicServiceProvider);
  return AcademicDataNotifier(academicService);
});

// Notifier for user profile management
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final AcademicService _academicService;

  UserProfileNotifier(this._academicService) : super(const AsyncValue.loading());

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await DataService.getUserProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateLeaderboardParticipation({
    required bool optIn,
    required String nameVisibility,
    required String gpaVisibility,
    double? gpa,
  }) async {
    try {
      await _academicService.updateLeaderboardParticipation(
        optIn: optIn,
        nameVisibility: nameVisibility,
        gpaVisibility: gpaVisibility,
        gpa: gpa,
      );
      await loadProfile(); // Reload profile after update
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final userProfileNotifierProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final academicService = ref.watch(academicServiceProvider);
  return UserProfileNotifier(academicService);
});

// Notifier for what-if simulator
class WhatIfSimulatorNotifier extends StateNotifier<List<Assignment>> {
  WhatIfSimulatorNotifier() : super([]);

  void addHypotheticalAssignment(Assignment assignment) {
    final hypotheticalAssignment = assignment.copyWith(isHypothetical: true);
    state = [...state, hypotheticalAssignment];
  }

  void updateHypotheticalAssignment(String assignmentId, Assignment updatedAssignment) {
    state = state.map((assignment) {
      if (assignment.id == assignmentId) {
        return updatedAssignment.copyWith(isHypothetical: true);
      }
      return assignment;
    }).toList();
  }

  void removeHypotheticalAssignment(String assignmentId) {
    state = state.where((assignment) => assignment.id != assignmentId).toList();
  }

  void clearHypotheticalAssignments() {
    state = [];
  }

  Future<void> saveHypotheticalAssignments() async {
    await DataService.storeHypotheticalAssignments(state);
  }

  Future<void> loadHypotheticalAssignments() async {
    final assignments = await DataService.getHypotheticalAssignments();
    state = assignments;
  }
}

final whatIfSimulatorNotifierProvider = StateNotifierProvider<WhatIfSimulatorNotifier, List<Assignment>>((ref) {
  return WhatIfSimulatorNotifier();
}); 