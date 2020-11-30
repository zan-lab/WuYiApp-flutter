
import 'package:ich/models/Goods.dart';
import 'package:ich/models/User.dart';
import 'package:ich/models/ICH.dart';
import 'package:ich/models/ICHArticle.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/models/ICHTalk.dart';
Future<List<ICHArticle>> getTopArticle() async{
    List response=await request('/ICH/TopArticleList');
    List<ICHArticle>res=new List<ICHArticle>();
    for(int i=0;i<response.length;i++){
      var e=response[i];
      res.add(ICHArticle.fromJson(e));
    }
    return res;
}
Future<List<ICH>> getTopICH() async{
  List response=await request('/ICH/TopList');
  List<ICH>res=new List<ICH>();
  for(int i=0;i<response.length;i++){
    var e=response[i];
    res.add(ICH.fromJson(e));
  }
  return res;
}
Future<User> getUser(int userid) async{
  Map response=await request('/User',formData: {'id':userid});
  return User.fromJson(response);
}
Future<List<ICHTalk>> getTopTalk() async{
  List response=await request('/ICHTalk/TopList');
  List<ICHTalk>res=new List<ICHTalk>();
  for(int i=0;i<response.length;i++){
    ICHTalk e=ICHTalk.fromJson(response[i]);
    await e.loadUser();
    res.add(e);
  }
  return res;
}
Future<List<Goods>> getTopGoods() async{
  List response=await request('/Shop/TopGoods');
  List<Goods>res=new List<Goods>();
  for(int i=0;i<response.length;i++){
    var e=response[i];
    res.add(Goods.fromJson(e));
  }
  return res;
}