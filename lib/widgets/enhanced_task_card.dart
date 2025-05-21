import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class EnhancedTaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onCompleted;
  final Function(DismissDirection) onDismissed;
  final Function(Task) onReorder;

  const EnhancedTaskCard({
    super.key,
    required this.task,
    required this.onCompleted,
    required this.onDismissed,
    required this.onReorder,
  });

  @override
  State<EnhancedTaskCard> createState() => _EnhancedTaskCardState();
}

class _EnhancedTaskCardState extends State<EnhancedTaskCard> {
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _calculateProgress();
  }

  void _calculateProgress() {
    if (widget.task.subtasks.isEmpty) {
      _progressValue = widget.task.status == 'completed' ? 1.0 : 0.0;
    } else {
      final completedSubtasks = widget.task.subtasks
          .where((subtask) => subtask.isCompleted)
          .length;
      _progressValue = completedSubtasks / widget.task.subtasks.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Task>(
      data: widget.task,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          child: _buildCardContent(isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: _buildCardContent(),
      ),
      child: DragTarget<Task>(
        onWillAccept: (task) => task?.id != widget.task.id,
        onAccept: widget.onReorder,
        builder: (context, candidateData, rejectedData) {
          return Dismissible(
            key: Key('task-${widget.task.id}'),
            background: _buildDismissBackground(context, DismissDirection.startToEnd),
            secondaryBackground: _buildDismissBackground(context, DismissDirection.endToStart),
            onDismissed: widget.onDismissed,
            child: _buildCardContent(),
          );
        },
      ),
    );
  }

  Widget _buildCardContent({bool isDragging = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isDragging ? 8 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/task', arguments: widget.task),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildPriorityIndicator(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: widget.task.status == 'completed'
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (widget.task.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildProgressIndicator(),
            ],
          ),
        ),
      ),
    ).animate(target: isDragging ? 1 : 0).scale(end: const Offset(1.02, 1.02));
  }

  Widget _buildPriorityIndicator() {
    final colors = {
      1: Colors.red,
      2: Colors.orange,
      3: Colors.green,
    };

    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: colors[widget.task.priority] ?? Colors.grey,
        borderRadius: BorderRadius.circular(2),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
      .shimmer(duration: 2000.ms, delay: 1000.ms);
  }

  Widget _buildProgressIndicator() {
    return CircularPercentIndicator(
      radius: 15.0,
      lineWidth: 3.0,
      percent: _progressValue,
      progressColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      center: Text(
        '${(_progressValue * 100).round()}%',
        style: const TextStyle(fontSize: 10),
      ),
    ).animate().scale();
  }

  Widget _buildDismissBackground(BuildContext context, DismissDirection direction) {
    final isLeft = direction == DismissDirection.startToEnd;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isLeft ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeft) ...[
            const Icon(Icons.check, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Complete',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ] else ...[
            const Text('Delete',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.delete, color: Colors.white)
          ],
        ],
      ),
    );
  }
}