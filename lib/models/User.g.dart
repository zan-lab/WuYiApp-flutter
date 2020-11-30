// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..Id = json['Id'] as num
    ..Username = json['Username'] as String
    ..ProfilePicUrl = json['ProfilePicUrl'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Id': instance.Id,
      'Username': instance.Username,
      'ProfilePicUrl': instance.ProfilePicUrl
    };
