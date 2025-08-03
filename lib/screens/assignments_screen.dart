import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/assignment.dart';

class AssignmentsScreen extends ConsumerStatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  ConsumerState<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends ConsumerState<AssignmentsScreen> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Due Date';

  final List<String> _filters = ['All', 'Due', 'Graded', 'Missing', 'CNS', 'CWS', 'INS'];
  final List<String> _sortOptions = ['Due Date', 'Name', 'Category', 'Score'];

  @override
  Widget build(BuildContext context) {
    final assignmentsAsync = ref.watch(assignmentsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
        ],
      ),
      body: assignmentsAsync.when(
        data: (assignments) => _buildAssignmentsList(assignments),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading assignments: $error'),
        ),
      ),
    );
  }

  Widget _buildAssignmentsList(List<Assignment> assignments) {
    final filteredAssignments = _filterAssignments(assignments);
    final sortedAssignments = _sortAssignments(filteredAssignments);

    if (sortedAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No assignments found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your assignments will appear here once synced',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedAssignments.length,
            itemBuilder: (context, index) {
              final assignment = sortedAssignments[index];
              return _buildAssignmentCard(assignment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAssignmentDetails(assignment),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            assignment.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(assignment),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (assignment.dateDue != null) ...[
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(assignment.dateDue!),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (assignment.totalPoints > 0) ...[
                      Text(
                        '${assignment.totalPoints.toInt()} pts',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                if (assignment.score != null && assignment.score!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Score: ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        assignment.score!,
                        style: TextStyle(
                          color: _getScoreColor(assignment.score!),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (assignment.scorePercentage != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${assignment.scorePercentage!.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Assignment assignment) {
    Color color;
    String text;

    switch (assignment.status) {
      case 'Graded':
        color = Colors.green;
        text = 'Graded';
        break;
      case 'Due':
        if (assignment.dateDue != null && assignment.dateDue!.isBefore(DateTime.now())) {
          color = Colors.red;
          text = 'Overdue';
        } else {
          color = Colors.orange;
          text = 'Due';
        }
        break;
      case 'Currently Not Scored':
        color = Colors.blue;
        text = 'CNS';
        break;
      case 'Completed With Score':
        color = Colors.purple;
        text = 'CWS';
        break;
      case 'Incomplete':
        color = Colors.red;
        text = 'INS';
        break;
      default:
        color = Colors.grey;
        text = assignment.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getScoreColor(String score) {
    if (score == 'CNS' || score == 'CWS' || score == 'INS') {
      return Colors.grey;
    }
    
    final scoreValue = double.tryParse(score);
    if (scoreValue == null) return Colors.grey;
    
    if (scoreValue >= 90) return Colors.green;
    if (scoreValue >= 80) return Colors.blue;
    if (scoreValue >= 70) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference < 0) return '${difference.abs()} days ago';
    if (difference < 7) return '${difference}d';
    return '${date.month}/${date.day}';
  }

  List<Assignment> _filterAssignments(List<Assignment> assignments) {
    if (_selectedFilter == 'All') return assignments;
    
    return assignments.where((assignment) {
      switch (_selectedFilter) {
        case 'Due':
          return assignment.status == 'Due';
        case 'Graded':
          return assignment.status == 'Graded';
        case 'Missing':
          return assignment.status == 'Due' && 
                 assignment.dateDue != null && 
                 assignment.dateDue!.isBefore(DateTime.now());
        case 'CNS':
          return assignment.status == 'Currently Not Scored';
        case 'CWS':
          return assignment.status == 'Completed With Score';
        case 'INS':
          return assignment.status == 'Incomplete';
        default:
          return true;
      }
    }).toList();
  }

  List<Assignment> _sortAssignments(List<Assignment> assignments) {
    switch (_selectedSort) {
      case 'Due Date':
        assignments.sort((a, b) {
          if (a.dateDue == null && b.dateDue == null) return 0;
          if (a.dateDue == null) return 1;
          if (b.dateDue == null) return -1;
          return a.dateDue!.compareTo(b.dateDue!);
        });
        break;
      case 'Name':
        assignments.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Category':
        assignments.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'Score':
        assignments.sort((a, b) {
          final aScore = double.tryParse(a.score ?? '0') ?? 0;
          final bScore = double.tryParse(b.score ?? '0') ?? 0;
          return bScore.compareTo(aScore);
        });
        break;
    }
    return assignments;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Assignments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filters.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Assignments'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedSort,
              onChanged: (value) {
                setState(() {
                  _selectedSort = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAssignmentDetails(Assignment assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAssignmentDetailsSheet(assignment),
    );
  }

  Widget _buildAssignmentDetailsSheet(Assignment assignment) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assignment.category,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Status', assignment.status),
                  if (assignment.dateAssigned != null)
                    _buildDetailRow('Assigned', _formatDate(assignment.dateAssigned!)),
                  if (assignment.dateDue != null)
                    _buildDetailRow('Due', _formatDate(assignment.dateDue!)),
                  _buildDetailRow('Total Points', assignment.totalPoints.toString()),
                  if (assignment.score != null && assignment.score!.isNotEmpty) ...[
                    _buildDetailRow('Score', assignment.score!),
                    if (assignment.scorePercentage != null)
                      _buildDetailRow('Percentage', '${assignment.scorePercentage!.toStringAsFixed(1)}%'),
                  ],
                  if (assignment.countsTowardsGpa)
                    _buildDetailRow('GPA Impact', 'Yes'),
                  if (assignment.gpaPoints != null)
                    _buildDetailRow('GPA Points', assignment.gpaPoints!.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 