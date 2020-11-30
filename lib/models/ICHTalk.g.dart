// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICHTalk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICHTalk _$ICHTalkFromJson(Map<String, dynamic> json) {
  return ICHTalk()
    ..Id = json['Id'] as num
    ..UserId = json['UserId'] as num
    ..Content = json['Content'] as String
    ..Photo1Url = json['Photo1Url'] as String
    ..Photo2Url = json['Photo2Url'] as String
    ..Photo3Url = json['Photo3Url'] as String
    ..LikeCount = json['LikeCount'] as num
    ..CreateDate = json['CreateDate'] as String;
}

Map<String, dynamic> _$ICHTalkToJson(ICHTalk instance) => <String, dynamic>{
      'Id': instance.Id,
      'UserId': instance.UserId,
      'Content': instance.Content,
      'Photo1Url': instance.Photo1Url,
      'Photo2Url': instance.Photo2Url,
      'Photo3Url': instance.Photo3Url,
      'LikeCount': instance.LikeCount,
      'CreateDate': instance.CreateDate
    };
