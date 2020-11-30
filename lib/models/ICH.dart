import 'package:json_annotation/json_annotation.dart';

part 'ICH.g.dart';

@JsonSerializable()
class ICH {
    ICH();

    num Id;
    String Name;
    String PicUrl;
    String Address;
    num CatId;
    num IsTop;
    
    factory ICH.fromJson(Map<String,dynamic> json) => _$ICHFromJson(json);
    Map<String, dynamic> toJson() => _$ICHToJson(this);
}
