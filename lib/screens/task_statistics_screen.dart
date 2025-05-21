import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/task_statistics.dart';
import 'package:task_manager_app/widgets/task_progress_header.dart';

class TaskStatisticsScreen extends StatelessWidget {
  const TaskStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  'Track your productivity',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),

          // Progress Header
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              final totalTasks = taskProvider.tasks.length;
              final completedTasks = taskProvider.tasks
                  .where((task) => task.status == 'completed')
                  .length;

              return TaskProgressHeader(
                totalTasks: totalTasks,
                completedTasks: completedTasks,
                categories: [
                  // Add your categories here
                ],
              );
            },
          ),

          // Statistics
          Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return TaskStatistics(tasks: taskProvider.tasks);
            },
          ),
        ],
      ),
    );
  }
}