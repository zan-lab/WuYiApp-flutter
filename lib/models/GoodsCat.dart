import 'package:json_annotation/json_annotation.dart';

part 'GoodsCat.g.dart';

@JsonSerializable()
class GoodsCat {
    GoodsCat();

    num Id;
    String Name;
    
    factory GoodsCat.fromJson(Map<String,dynamic> json) => _$GoodsCatFromJson(json);
    Map<String, dynamic> toJson() => _$GoodsCatToJson(this);
}
