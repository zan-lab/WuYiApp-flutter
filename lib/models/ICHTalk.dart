import 'package:json_annotation/json_annotation.dart';
import 'package:ich/common/Function.dart';
part 'ICHTalk.g.dart';

@JsonSerializable()
class ICHTalk {
    ICHTalk();

    num Id;
    num UserId;
    String Content;
    String Photo1Url;
    String Photo2Url;
    String Photo3Url;
    num LikeCount;
    String CreateDate;
    String userName;
    String userProfilePicUrl;
    Future loadUser ()async{
        Map response=await request('/User?id='+this.UserId.toString());
        //print(response);
        this.userName=response['Username'];
        this.userProfilePicUrl=response['ProfilePicUrl'];
        //print(this.userName);
    }
    factory ICHTalk.fromJson(Map<String,dynamic> json) => _$ICHTalkFromJson(json);
    Map<String, dynamic> toJson() => _$ICHTalkToJson(this);
}
