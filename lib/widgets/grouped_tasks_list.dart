import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/widgets/animated_task_card.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/widgets/enhanced_task_card.dart';

class GroupedTasksList extends StatelessWidget {
  final List<Task> tasks;

  const GroupedTasksList({super.key, required this.tasks, required Null Function(dynamic task) onTaskCompleted});

  @override
  Widget build(BuildContext context) {
    final groupedTasks = _groupTasks(tasks);

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: groupedTasks.length,
      itemBuilder: (context, index) {
        final group = groupedTasks.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GroupHeader(title: group.key)
                .animate()
                .fadeIn()
                .slideX(begin: -0.2, end: 0),
            ...group.value
                .map((task) => EnhancedTaskCard(
                      task: task,
                      onCompleted: () {
                        // Handle completion
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          // Handle completion
                        } else {
                          // Handle deletion
                        }
                      },
                      onReorder: (newTask) {
                        // Handle reordering
                      },
                    ))
                .toList()
                .animate(interval: 50.ms)
                .fadeIn()
                .slideX(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Map<String, List<Task>> _groupTasks(List<Task> tasks) {
    final now = DateTime.now();
    final grouped = <String, List<Task>>{};

    for (final task in tasks) {
      String group;
      if (task.dueDate == null) {
        group = 'No Due Date';
      } else {
        final difference = DateUtils.dateOnly(task.dueDate!)
            .difference(DateUtils.dateOnly(now))
            .inDays;

        if (difference < 0) {
          group = 'Overdue';
        } else if (difference == 0) {
          group = 'Today';
        } else if (difference == 1) {
          group = 'Tomorrow';
        } else if (difference < 7) {
          group = 'This Week';
        } else {
          group = DateFormat('MMMM yyyy').format(task.dueDate!);
        }
      }

      grouped.putIfAbsent(group, () => []).add(task);
    }

    return grouped;
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;

  const _GroupHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}