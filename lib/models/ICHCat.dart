import 'package:json_annotation/json_annotation.dart';

part 'ICHCat.g.dart';

@JsonSerializable()
class ICHCat {
    ICHCat();

    num Id;
    String Name;
    
    factory ICHCat.fromJson(Map<String,dynamic> json) => _$ICHCatFromJson(json);
    Map<String, dynamic> toJson() => _$ICHCatToJson(this);
}
