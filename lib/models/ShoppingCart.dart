import 'package:json_annotation/json_annotation.dart';
import 'package:ich/models/Goods.dart';
import 'package:ich/common/Function.dart';
part 'ShoppingCart.g.dart';

@JsonSerializable()
class ShoppingCart {
    ShoppingCart();

    num Id;
    num GoodsId;
    num Count;
    Goods goods;
    Future loadGoods() async{
        Map response=await request('/Shop/Goods',formData: {'id':this.GoodsId});
        this.goods=Goods.fromJson(response);
    }
    factory ShoppingCart.fromJson(Map<String,dynamic> json) => _$ShoppingCartFromJson(json);
    Map<String, dynamic> toJson() => _$ShoppingCartToJson(this);
}
