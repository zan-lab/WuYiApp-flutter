// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShoppingOrder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingOrder _$ShoppingOrderFromJson(Map<String, dynamic> json) {
  return ShoppingOrder()
    ..Id = json['Id'] as num
    ..GoodsId = json['GoodsId'] as num
    ..Count = json['Count'] as num
    ..CreateTime = json['CreateTime'] as String;
}

Map<String, dynamic> _$ShoppingOrderToJson(ShoppingOrder instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'GoodsId': instance.GoodsId,
      'Count': instance.Count,
      'CreateTime': instance.CreateTime
    };
