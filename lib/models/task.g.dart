// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  dueDate:
      json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
  priority: (json['priority'] as num).toInt(),
  status: json['status'] as String,
  ownerId: (json['ownerId'] as num).toInt(),
  isRecurring: json['isRecurring'] as bool,
  recurrenceInterval: json['recurrenceInterval'] as String?,
  recurrenceEndDate:
      json['recurrenceEndDate'] == null
          ? null
          : DateTime.parse(json['recurrenceEndDate'] as String),
  subtasks:
      (json['subtasks'] as List<dynamic>?)
          ?.map((e) => Subtask.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'dueDate': instance.dueDate?.toIso8601String(),
  'priority': instance.priority,
  'status': instance.status,
  'ownerId': instance.ownerId,
  'isRecurring': instance.isRecurring,
  'recurrenceInterval': instance.recurrenceInterval,
  'recurrenceEndDate': instance.recurrenceEndDate?.toIso8601String(),
  'subtasks': instance.subtasks,
  'categories': instance.categories,
};
