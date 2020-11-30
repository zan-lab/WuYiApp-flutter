import 'package:ich/common/Function.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ShoppingOrder.g.dart';

@JsonSerializable()
class ShoppingOrder {
    ShoppingOrder();

    num Id;
    num GoodsId;
    num Count;
    String CreateTime;
    String goodsPicUrl;
    String goodsName;
    Future loadGoods()async{
        Map response=await request('/Shop/Goods',formData: {'id':GoodsId});
        this.goodsPicUrl=response['PicUrl'];
        this.goodsName=response['Name'];
    }
    factory ShoppingOrder.fromJson(Map<String,dynamic> json) => _$ShoppingOrderFromJson(json);
    Map<String, dynamic> toJson() => _$ShoppingOrderToJson(this);
}
