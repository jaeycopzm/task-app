import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskProgressHeader extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final List<TaskCategory> categories;

  const TaskProgressHeader({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: progressPercent,
                  center: Text(
                    '${(progressPercent * 100).round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  progressColor: Colors.white,
                  backgroundColor: Colors.white24,
                ).animate().scale(),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Progress',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedTasks of $totalTasks tasks',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().slideX(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((category) => _CategoryProgress(category: category))
                    .toList(),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  final TaskCategory category;

  const _CategoryProgress({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            category.icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '${category.name}: ${category.progress.round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCategory {
  final String name;
  final IconData icon;
  final double progress;

  const TaskCategory({
    required this.name,
    required this.icon,
    required this.progress,
  });
}