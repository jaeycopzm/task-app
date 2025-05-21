import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  final String? email;
  final String? fullName;
  @JsonKey(includeIfNull: false)
  final String? googleId;

  User({
    required this.id,
    required this.username,
    this.email,
    this.fullName,
    this.googleId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}