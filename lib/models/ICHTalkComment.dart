import 'package:ich/common/Function.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ICHTalkComment.g.dart';

@JsonSerializable()
class ICHTalkComment {
    ICHTalkComment();

    num Id;
    num UserId;
    num TalkId;
    String Content;
    String CreateDate;
    String userName;
    Future loadUser() async{
        Map response =await request('/User?id='+this.UserId.toString());
        //print(response);
        this.userName=response['Username'];
    }
    factory ICHTalkComment.fromJson(Map<String,dynamic> json) => _$ICHTalkCommentFromJson(json);
    Map<String, dynamic> toJson() => _$ICHTalkCommentToJson(this);
}
