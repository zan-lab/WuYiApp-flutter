import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/mine_pages/about_us.dart';
import 'package:ich/mine_pages/info.dart';
import 'package:ich/mine_pages/myich.dart';
import 'package:ich/mine_pages/order.dart';
import 'package:ich/mine_pages/setting.dart';
import 'package:ich/mine_pages/shopping_cart.dart';
import 'package:ich/mine_pages/suggest.dart';
import 'package:ich/style_pages/textstyle.dart';
import 'package:ich/user_pages/login_page.dart';

// ignore: camel_case_types
class MinePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 202, 0, 1.0),
        leading: Container(
          alignment: Alignment.center,
          child: Text(
            '我的',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                  child: Container(
                    color: Color.fromRGBO(245, 245, 230, 1.0),
                  ),
                ),
                //获取用户信息卡片（用户名，头像、邮箱）
                UserCard(),
                SizedBox(
                  height: 10,
                  child: Container(
                    color: Color.fromRGBO(245, 245, 230, 0.0),
                  ),
                ),
                //整个滑动的列表（关于我们、订单、购物车）
                MineListView(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



//用户名和邮箱
class UserCard extends StatefulWidget {
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserInfo()));
        },
        child: Card(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            //z轴的高度，设置card的阴影
            elevation: 10.0,
            //设置shape，这里设置成了R角
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
            clipBehavior: Clip.antiAlias,
            semanticContainer: false,
            child: new Row(
              children: <Widget>[
                getUserCardImage(),
                Column(children: <Widget>[
                  Container(
                    width: 220,
                    alignment: Alignment.centerLeft,
                    child: Text(
//                      "用户名2",
                      Global.userinfo.Username,//用户名
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 220,
                    padding: EdgeInsets.only(top: 13),
                    child: Text(
//                      "邮箱：3066582731@qq.com",
                      Global.userinfo.Email,//邮箱
                      style: TextStyle(fontSize: 13, color: Colors.black38),
                    ),
                  )
                ]),
              ],
            )
          //getUserCard(),
        ),
      ),
    );
  }

  //获取头像
  getUserCardImage() {
    return Container(
      color: Color.fromRGBO(252, 250, 245, 1.0),
      height: 130,
      width: 130,
      child: new Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20, left: 20),
          child: GetCOntentImage(),//圆形头像处理
        ),
        Container(),
        //new Text("card"),
      ]
//        "Card",
//        style: TextStyle(fontSize: 28, color: Colors.black),
      ),
    );
  }
}


//头像处理（圆形的处理）
class GetCOntentImage extends StatefulWidget {
  @override
  _GetCOntentImageState createState() => _GetCOntentImageState();
}

class _GetCOntentImageState extends State<GetCOntentImage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
//          alignment: Alignment.centerLeft,
      height: 90.0,
      width: 90.0,
      decoration: BoxDecoration(
        // 装饰器
//          color: Colors.blue, // 深蓝绿色
          border: Border.all(
              color: Colors.amber, // 边框黄色
              width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(150)), // 盒子圆角
          // borderRadius: BorderRadius.circular(150)
          image: DecorationImage(
            // image: Image.network("http://xxx.xxx.xx.jpeg") // error
            image: NetworkImage(
//                "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1028479771,2944343576&fm=26&gp=0.jpg"
                Global.userinfo.ProfilePicUrl),
          )),
      padding: EdgeInsets.all(20), // 盒子内边距
    );
  }
}

class MineListView extends StatefulWidget {
  @override
  _MineListViewState createState() => _MineListViewState();
}

class _MineListViewState extends State<MineListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          //我的订单
          Container(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            child: new ListTile(
              leading: new Icon(Icons.assignment),
              title: new Text('我的订单'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something
                //Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyOrderinfoPage()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizeBoxAll(),
          //我的购物车
          Container(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            child: new ListTile(
              leading: new Icon(Icons.add_shopping_cart),
              title: new Text('我的购物车'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShoppingCartPage ()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizeBoxAll(),
          //我的购物车
          Container(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            child: new ListTile(
              leading: new Icon(Icons.loyalty),
              title: new Text('我的非遗说'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyichPages ()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizeBoxAll(),
          //设置
          Container(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            child: new ListTile(
              leading: new Icon(Icons.brightness_high),
              title: new Text('设置'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizedBox(
            height: 12,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          //反馈中心
          Container(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            child: new ListTile(
              leading: new Icon(Icons.comment),
              title: new Text('反馈中心'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Suggest()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizeBoxAll(),
          //关于我们
          Container(
            color: Color.fromRGBO(252, 250, 245, 1.0),
            child: new ListTile(
              leading: new Icon(Icons.error_outline),
              title: new Text('关于我们'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUs()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizeBoxAll(),
        ],
      ),
    );
  }

}


//就是一个盒子（不重要）
class SizeBoxAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 1,
        child: Container(
          color: Color.fromRGBO(245, 240, 230, 1.0),
        ),
      ),
    );
  }
}

