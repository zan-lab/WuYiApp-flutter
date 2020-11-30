import 'package:flutter/material.dart';
import 'package:ich/bottomBar_pages/bottombar_page_branch.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/bottomBar_pages/bottombar_page.dart';
import 'package:ich/splash_pages/splash_page.dart';
import 'package:ich/user_pages/login_page.dart';
import 'package:ich/common/Function.dart';
import 'package:screen_ratio_adapter/screen_ratio_adapter.dart';

import 'bottomBar_pages/feiyi_page.dart';

Size uiSize = Size(414, 896);

void main() {
  Global.init();

  runFxApp(MyApp(), uiSize: uiSize, onEnsureInitialized: (info) {});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    loadLocalData().then((value) {
      //print(Global.userinfo);
      int userid=-1;
      userid=value;
      if(userid!=-1){
        loadUserByLocalId(userid);
        //print(Global.userinfo);
      }
    });
    return MaterialApp(
        title: '非遗',
        color: Colors.amber,
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        routes: {
          '/LoginPage': (ctx) => LoginPage(),
          '/BottomBarPage': (ctx) => BottomBarPage(),
          '/BottomBarPageBranch1':(ctx)=>BottomBarPageBranch(1),
          '/BottomBarPageBranch2':(ctx)=>BottomBarPageBranch(2),
        });
  }
}
