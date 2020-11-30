// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICHTalkComment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICHTalkComment _$ICHTalkCommentFromJson(Map<String, dynamic> json) {
  return ICHTalkComment()
    ..Id = json['Id'] as num
    ..UserId = json['UserId'] as num
    ..TalkId = json['TalkId'] as num
    ..Content = json['Content'] as String
    ..CreateDate = json['CreateDate'] as String;
}

Map<String, dynamic> _$ICHTalkCommentToJson(ICHTalkComment instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'UserId': instance.UserId,
      'TalkId': instance.TalkId,
      'Content': instance.Content,
      'CreateDate': instance.CreateDate
    };
