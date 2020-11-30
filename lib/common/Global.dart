import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ich/common/Function.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;
  static User userinfo;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
  }
}
Future loadUserByLocalId(int id)async{
  Map response=await request('/User?id='+id.toString());
  Global.userinfo=new User(response['Id'], response['Username'], response['Password'],response['ProfilePicUrl'],
      response['Email'], response['Sex'], response['Birthday'], response['Brief']);
}
class User{
  //首字母大写是数据库映射的名字
  //小写是后来转化的属性
  int Id;
  String Username;
  String Password;
  String ProfilePicUrl;
  String Email="";
  int Sex=2;
  String BirthdayString;
  DateTime birthday;
  String Brief;
  int age=0;
  //初始化
  User(this.Id, this.Username, this.Password, this.ProfilePicUrl, this.Email,
      this.Sex,this.BirthdayString, this.Brief){
    if(this.Brief==null||this.Brief==""){
      this.Brief='快来填写你的个性签名吧！';
    }
    if(BirthdayString!=null&&BirthdayString!=""){
      this.birthday=DateTime.parse(BirthdayString);
      this.age=DateTime.now().year-this.birthday.year;
    }
  }

  Future UploadInfo() async{
    Map formData={
      'id':this.Id,
      'sex':this.Sex,
      'birthday':this.BirthdayString,
      'brief':this.Brief
    };
    print(formData);
    await  request('/User/Edit',formData: formData);
    ;    }
  //从服务器端重载数据，达到刷新效果
  bool Reload()
  {
    login().then((value){
      if(value==null)return false;
      else
      {
        //更新数据库字段属性
        this.Id=value['Id'];
        this.Username=value['Username'];
        this.Password=value['Password'];
        this.ProfilePicUrl=value['ProfilePicUrl'];
        this.Email=value['Email'];
        this.Sex=value['Sex'];
        this.BirthdayString=value['Birthday'];
        this.Brief=value['Brief'];
        //更新附加属性
        this.birthday=DateTime.parse(BirthdayString);
        this.age=DateTime.now().year-this.birthday.year;
      }
    });
  }
  //登录（重载数据）
  Future<Map> login() async{
    Dio dio=new Dio();
    var data={
      'username':this.Username,
      'password':this.Password
    };
    var res=await dio.post('http://ich.laoluoli.cn/index.php/User/Login',data: data);
    if(res.data['code']!=0)return null;
    return res.data['data'];
  }
}
