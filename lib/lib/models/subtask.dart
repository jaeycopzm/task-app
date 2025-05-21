
import 'package:json_annotation/json_annotation.dart';

part 'subtask.g.dart';

@JsonSerializable()
class Subtask {
  final int id;
  final String title;
  final bool isCompleted;
  final int taskId;

  Subtask({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.taskId,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) => _$SubtaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskToJson(this);
}