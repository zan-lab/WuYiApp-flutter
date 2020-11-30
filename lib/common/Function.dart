import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future request(relativePath,{formData=null,rowData=false})async{
  String rootPath='http://ich.laoluoli.cn/index.php';
  String url=rootPath+relativePath;
  try{
    print('开始获取数据...............');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded").toString();
    if(formData==null){
      response = await dio.post(url);
    }else{
      response = await dio.post(url,data:formData);
    }

    if(response.statusCode==200){
      if(rowData){
        return response.data;
      }
      else {
        if(response.data['code']!=0)
        {
          //检查接口的code
          throw Exception('code not 0,check!'+response.data['msg']);
        }
        else{
          return response.data['data'];
        }
      }


    }else{
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }

}
Future saveLocalData(int userid) async{
  //目前只存储userid
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('userid', userid);
}
Future<int> loadLocalData() async{
  //目前只读取userid
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userid = prefs.getInt('userid') ?? -1;
  return userid;
}
Future removeLocalData() async{
  //目前只移除userid
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userid');
}