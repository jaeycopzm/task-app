import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager_app/models/category.dart';
import 'package:task_manager_app/models/subtask.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int priority;
  final String status;
  final int ownerId;
  final bool isRecurring;
  final String? recurrenceInterval;
  final DateTime? recurrenceEndDate;
  final List<Subtask> subtasks;
  final List<Category> categories;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    required this.ownerId,
    required this.isRecurring,
    this.recurrenceInterval,
    this.recurrenceEndDate,
    this.subtasks = const [],
    this.categories = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}