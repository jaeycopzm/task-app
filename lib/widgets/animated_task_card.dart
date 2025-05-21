import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:confetti/confetti.dart';

class AnimatedTaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onCompleted;

  const AnimatedTaskCard({
    super.key,
    required this.task,
    required this.onCompleted,
  });

  @override
  State<AnimatedTaskCard> createState() => _AnimatedTaskCardState();
}

class _AnimatedTaskCardState extends State<AnimatedTaskCard> {
  late ConfettiController _confettiController;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _handleCompletion() async {
    setState(() => _isCompleting = true);

    await Future.delayed(const Duration(milliseconds: 300));
    _confettiController.play();
    
    await Future.delayed(const Duration(milliseconds: 700));
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
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
                  _buildCheckbox(),
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
                            color: widget.task.status == 'completed'
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ),
                        if (widget.task.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.task.description!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              decoration: widget.task.status == 'completed'
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate(target: _isCompleting ? 1 : 0)
          .scaleX(end: 0.8)
          .fadeOut(),
        
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: widget.task.status != 'completed' ? _handleCompletion : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.task.status == 'completed'
                ? Colors.green
                : Colors.grey.shade400,
            width: 2,
          ),
          color: widget.task.status == 'completed'
              ? Colors.green
              : Colors.transparent,
        ),
        child: widget.task.status == 'completed'
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    ).animate(target: _isCompleting ? 1 : 0)
      .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3))
      .tint(color: Colors.green)
      .then()
      .scale(begin: const Offset(1.3, 1.3), end: const Offset(1, 1));
  }
}