import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ich/bottomBar_pages/feiyi_page.dart';
import 'package:ich/bottomBar_pages/mine_page.dart';
import 'package:ich/bottomBar_pages/shop_index_page.dart';
import 'package:ich/bottomBar_pages/sort_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';
int currentIndex;
class BottomBarPageBranch extends StatefulWidget {
  BottomBarPageBranch(index){
    currentIndex=index;
  }
//  _BottomBarPageState pagestate;
//  void NavigatorTo(int pageIndex){
//    print(this.pagestate);
//    pagestate.NavigatorTo(pageIndex);
//  }
  // _BottomBarPageState getPagestate()=>this.pagestate;

  @override
  _BottomBarPageBranchState createState() {

    return _BottomBarPageBranchState();
  }
}

class _BottomBarPageBranchState extends State<BottomBarPageBranch> {
  //_BottomBarPageState();
  int lastTime = 0;

  //使用数组设置底部导航
//  void NavigatorTo(int pageIndex){
//      setState(() {
//        currentIndex = pageIndex;
//        currentPage = tabBodies[currentIndex];
//      });
//  }
  final List<BottomNavigationBarItem> bottomTabs = [
    //首页
    BottomNavigationBarItem(
      icon: Image.asset(
        'images/home.png',
      ),
      activeIcon: Image.asset(
        'images/activehome.png',
      ),
//      icon: Image.network('https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2907227418,1639643895&fm=26&gp=0.jpg'),
      title: Text('首页'),
    ),
    //分类
    BottomNavigationBarItem(
      icon: Image.asset('images/sort.png'),
      activeIcon: Image.asset(
        'images/activesort.png',
      ),
      title: Text('分类'),
    ),
    //非遗说
    BottomNavigationBarItem(
      icon: Image.asset('images/find.png'),
      activeIcon: Image.asset(
        'images/activefind.png',
      ),
      title: Text('非遗说'),
    ),
    //商城
    BottomNavigationBarItem(
      icon: Image.asset('images/shop.png'),
      activeIcon: Image.asset(
        'images/activeshop.png',
      ),
      title: Text('商城'),
    ),
    //我的
    BottomNavigationBarItem(
      icon: Image.asset('images/me.png'),
      activeIcon: Image.asset(
        'images/activeme.png',
      ),
      title: Text('我的'),
    ),
  ];

  //使用数组引用其他页面
  final List tabBodies = [
    HomePage(),
    SortPage(),
    FeiyiPage(),
    ShopIndexPage(),
    MinePage(),
  ];

  //索引：设置页数和对应的页面
  //int currentIndex=2;
  var currentPage;

  @override
  void initState() {
    //默认打开的页面
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //脚手架
    return WillPopScope(
        child: Scaffold(
          //默认颜色
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          //使用组件
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            //现在所在的页面序号
            currentIndex: currentIndex,
            items: bottomTabs,
            //单击事件
            onTap: (index) {
              //回调，刷新页面
              setState(() {
                currentIndex = index;
                currentPage = tabBodies[currentIndex];
              });
            },
            unselectedFontSize: 14.0,
            selectedFontSize: 14.0,
            fixedColor: Colors.orangeAccent,
          ),
          //显示页面
          body: currentPage,
        ),
        onWillPop: () async {
          int newTime = DateTime.now().millisecondsSinceEpoch;
          int result = newTime - lastTime;
          lastTime = newTime;
          if (result > 2000) {
            Fluttertoast.showToast(
              msg: '再按一次退出',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
            );
          } else {
            SystemNavigator.pop();
          }
          return null;
        });
  }
}
