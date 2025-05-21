// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subtask _$SubtaskFromJson(Map<String, dynamic> json) => Subtask(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  isCompleted: json['isCompleted'] as bool,
  taskId: (json['taskId'] as num).toInt(),
);

Map<String, dynamic> _$SubtaskToJson(Subtask instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'isCompleted': instance.isCompleted,
  'taskId': instance.taskId,
};
