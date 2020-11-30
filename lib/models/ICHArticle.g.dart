// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICHArticle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICHArticle _$ICHArticleFromJson(Map<String, dynamic> json) {
  return ICHArticle()
    ..Id = json['Id'] as num
    ..ICHId = json['ICHId'] as num
    ..Title = json['Title'] as String
    ..Content = json['Content'] as String
    ..IsTop = json['IsTop'] as num;
}

Map<String, dynamic> _$ICHArticleToJson(ICHArticle instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'ICHId': instance.ICHId,
      'Title': instance.Title,
      'Content': instance.Content,
      'IsTop': instance.IsTop
    };
