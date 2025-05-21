import 'package:flutter/material.dart';

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