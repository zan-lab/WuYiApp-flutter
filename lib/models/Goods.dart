import 'package:json_annotation/json_annotation.dart';
import 'package:ich/common/Function.dart';
part 'Goods.g.dart';

@JsonSerializable()
class Goods {
    Goods();
    num Id;
    String Name;
    num Price;
    String Brief;
    String PicUrl;
    num CatId;
    num IsTop;
    String catName;
    factory Goods.fromJson(Map<String,dynamic> json) => _$GoodsFromJson(json);
    Future<String> getCatname()async{
        var res=await request('/Shop/CatById',formData: {'id':this.CatId});
        return res['Name'];
    }
    Map<String, dynamic> toJson() => _$GoodsToJson(this);
}
