import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/task', arguments: task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildPriorityIndicator(task.priority),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildStatusChip(task.status),
                ],
              ),
              if (task.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: TextStyle(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.dueDate != null
                        ? DateFormat('MMM d, y').format(task.dueDate!)
                        : 'No due date',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  if (task.categories.isNotEmpty)
                    Chip(
                      label: Text(
                        task.categories.first.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(int priority) {
    Color color;
    switch (priority) {
      case 1:
        color = Colors.red;
        break;
      case 2:
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'completed':
        color = Colors.green;
        label = 'Done';
        break;
      case 'in_progress':
        color = Colors.blue;
        label = 'In Progress';
        break;
      default:
        color = Colors.grey;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}