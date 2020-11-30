import 'package:json_annotation/json_annotation.dart';

part 'ICHArticle.g.dart';

@JsonSerializable()
class ICHArticle {
    ICHArticle();

    num Id;
    num ICHId;
    String Title;
    String Content;
    num IsTop;
    
    factory ICHArticle.fromJson(Map<String,dynamic> json) => _$ICHArticleFromJson(json);
    Map<String, dynamic> toJson() => _$ICHArticleToJson(this);
}
