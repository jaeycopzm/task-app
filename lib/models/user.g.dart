// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String?,
  fullName: json['fullName'] as String?,
  googleId: json['googleId'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'fullName': instance.fullName,
  if (instance.googleId case final value?) 'googleId': value,
};
