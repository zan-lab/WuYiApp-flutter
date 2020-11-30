import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ich/bottomBar_pages/bottombar_page.dart';
import 'package:ich/user_pages/login_page.dart';
import 'package:ich/common/Global.dart';
class SplashPage extends StatefulWidget {
  SplashPage({Key key}):super(key:key);
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //设置 开始进入主页 为假
  bool isStartIndexPage = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //设置点击事件
      onTap: goToIndexPage,
      child: ClipRRect(
        //设置插入的开屏图片
        child: Image.asset(
          'images/Splash.jpg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  //页面初始化状态的方法
  @override
  void initState(){
    super.initState();
    //开始倒计时
    countDown();
  }
  
  void countDown(){
    //设置倒计时三秒后执行跳转的方法
    var duration = new Duration(seconds: 3);
    //延时操作，等待3秒后进入主页
    Future.delayed(duration,goToIndexPage);
  }
  
  void goToIndexPage(){
    //开始进入首页为真，则跳转
    if(!isStartIndexPage){
      //跳转到下个页面，并且销毁当前页面
      //第一个为上下文环境，
      //第二个参数为静态注册的对应的页面名称，
      //第三个参数为跳转后的操作，route == null/false 为销毁当前页面
      //不能传递参数，在mian.dart里面写死要跳转的路由协议
      if(Global.userinfo==null){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage(),),
                (Route<dynamic> rout) => false);
      }
      else{
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/BottomBarPage", ModalRoute.withName("/BottomBarPage"));
      }

      isStartIndexPage = true;
    }
  }
}

