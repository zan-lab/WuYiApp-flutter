// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShoppingCart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingCart _$ShoppingCartFromJson(Map<String, dynamic> json) {
  return ShoppingCart()
    ..Id = json['Id'] as num
    ..GoodsId = json['GoodsId'] as num
    ..Count = json['Count'] as num;
}

Map<String, dynamic> _$ShoppingCartToJson(ShoppingCart instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'GoodsId': instance.GoodsId,
      'Count': instance.Count
    };
