// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICH.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICH _$ICHFromJson(Map<String, dynamic> json) {
  return ICH()
    ..Id = json['Id'] as num
    ..Name = json['Name'] as String
    ..PicUrl = json['PicUrl'] as String
    ..Address = json['Address'] as String
    ..CatId = json['CatId'] as num
    ..IsTop = json['IsTop'] as num;
}

Map<String, dynamic> _$ICHToJson(ICH instance) => <String, dynamic>{
      'Id': instance.Id,
      'Name': instance.Name,
      'PicUrl': instance.PicUrl,
      'Address': instance.Address,
      'CatId': instance.CatId,
      'IsTop': instance.IsTop
    };
