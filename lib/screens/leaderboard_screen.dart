import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/leaderboard_entry.dart';
import '../models/user_profile.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(leaderboardProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildParticipationCard(context, ref, userProfileAsync),
          Expanded(
            child: leaderboardAsync.when(
              data: (entries) => _buildLeaderboardList(entries),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading leaderboard: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationCard(BuildContext context, WidgetRef ref, AsyncValue<UserProfile?> userProfileAsync) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: userProfileAsync.when(
        data: (profile) => _buildParticipationContent(context, ref, profile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Text('Error loading profile: $error'),
      ),
    );
  }

  Widget _buildParticipationContent(BuildContext context, WidgetRef ref, UserProfile? profile) {
    final isOptedIn = profile?.optInLeaderboard ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isOptedIn ? Icons.visibility : Icons.visibility_off,
              color: isOptedIn ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Leaderboard Participation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isOptedIn ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          isOptedIn 
              ? 'You are visible on the leaderboard'
              : 'You are not participating in the leaderboard',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showParticipationDialog(context, ref, profile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOptedIn ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(isOptedIn ? 'Opt Out' : 'Opt In'),
              ),
            ),
            const SizedBox(width: 12),
            if (isOptedIn)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showPrivacySettingsDialog(context, ref, profile),
                  child: const Text('Privacy Settings'),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No leaderboard data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Students need to opt in to appear on the leaderboard',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildLeaderboardCard(entry, index);
      },
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry entry, int index) {
    final isTopThree = index < 3;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getRankColor(index),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          entry.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Last updated: ${_formatDate(entry.lastUpdated)}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getGpaColor(entry.gpa),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            entry.gpa,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber; // Gold
      case 1:
        return Colors.grey[400]!; // Silver
      case 2:
        return Colors.orange[300]!; // Bronze
      default:
        return Colors.blue;
    }
  }

  Color _getGpaColor(String gpa) {
    if (gpa == '***') return Colors.grey;
    
    final gpaValue = double.tryParse(gpa);
    if (gpaValue == null) return Colors.grey;
    
    if (gpaValue >= 3.7) return Colors.green;
    if (gpaValue >= 3.3) return Colors.blue;
    if (gpaValue >= 3.0) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showParticipationDialog(BuildContext context, WidgetRef ref, UserProfile? profile) {
    final isOptedIn = profile?.optInLeaderboard ?? false;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isOptedIn ? 'Opt Out of Leaderboard' : 'Join Leaderboard'),
        content: Text(
          isOptedIn
              ? 'Are you sure you want to remove yourself from the leaderboard?'
              : 'Join the leaderboard to compare your GPA with other students. You can control your privacy settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _toggleParticipation(ref, !isOptedIn);
            },
            child: Text(isOptedIn ? 'Opt Out' : 'Join'),
          ),
        ],
      ),
    );
  }

  void _showPrivacySettingsDialog(BuildContext context, WidgetRef ref, UserProfile? profile) {
    String nameVisibility = profile?.nameVisibility ?? 'full';
    String gpaVisibility = profile?.gpaVisibility ?? 'hidden';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Privacy Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Name Visibility:'),
              RadioListTile<String>(
                title: const Text('Full Name'),
                value: 'full',
                groupValue: nameVisibility,
                onChanged: (value) => setState(() => nameVisibility = value!),
              ),
              RadioListTile<String>(
                title: const Text('Nickname'),
                value: 'nickname',
                groupValue: nameVisibility,
                onChanged: (value) => setState(() => nameVisibility = value!),
              ),
              RadioListTile<String>(
                title: const Text('Anonymized'),
                value: 'anonymized',
                groupValue: nameVisibility,
                onChanged: (value) => setState(() => nameVisibility = value!),
              ),
              const SizedBox(height: 16),
              const Text('GPA Visibility:'),
              RadioListTile<String>(
                title: const Text('Exact GPA'),
                value: 'exact',
                groupValue: gpaVisibility,
                onChanged: (value) => setState(() => gpaVisibility = value!),
              ),
              RadioListTile<String>(
                title: const Text('GPA Range'),
                value: 'range',
                groupValue: gpaVisibility,
                onChanged: (value) => setState(() => gpaVisibility = value!),
              ),
              RadioListTile<String>(
                title: const Text('Hidden'),
                value: 'hidden',
                groupValue: gpaVisibility,
                onChanged: (value) => setState(() => gpaVisibility = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updatePrivacySettings(ref, nameVisibility, gpaVisibility);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleParticipation(WidgetRef ref, bool optIn) {
    ref.read(userProfileNotifierProvider.notifier).updateLeaderboardParticipation(
      optIn: optIn,
      nameVisibility: 'full',
      gpaVisibility: 'hidden',
      gpa: optIn ? 3.5 : null, // Default GPA for testing
    );
  }

  void _updatePrivacySettings(WidgetRef ref, String nameVisibility, String gpaVisibility) {
    ref.read(userProfileNotifierProvider.notifier).updateLeaderboardParticipation(
      optIn: true,
      nameVisibility: nameVisibility,
      gpaVisibility: gpaVisibility,
      gpa: 3.5, // Default GPA for testing
    );
  }
} 