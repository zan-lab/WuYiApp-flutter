// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goods _$GoodsFromJson(Map<String, dynamic> json) {
  return Goods()
    ..Id = json['Id'] as num
    ..Name = json['Name'] as String
    ..Price = json['Price'] as num
    ..Brief = json['Brief'] as String
    ..PicUrl = json['PicUrl'] as String
    ..CatId = json['CatId'] as num
    ..IsTop = json['IsTop'] as num;
}

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
  'Id': instance.Id,
  'Name': instance.Name,
  'Price': instance.Price,
  'Brief': instance.Brief,
  'PicUrl': instance.PicUrl,
  'CatId': instance.CatId,
  'IsTop': instance.IsTop
};
