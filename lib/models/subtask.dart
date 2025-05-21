import 'package:json_annotation/json_annotation.dart';

part 'subtask.g.dart';

@JsonSerializable()
class Subtask {
  final int id;
  final String title;
  final bool isCompleted;
  final int taskId;

  const Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.taskId,
  });

  // Add a copyWith method for easy updating
  Subtask copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    int? taskId,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      taskId: taskId ?? this.taskId,
    );
  }

  factory Subtask.fromJson(Map<String, dynamic> json) => _$SubtaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskToJson(this);
}