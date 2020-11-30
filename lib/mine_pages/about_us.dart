import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/style_pages/textstyle.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color.fromRGBO(252, 250, 245, 1.0),
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0.0,
          title: Text(
              "关于我们",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          backgroundColor: Colors.white,
          leading: (IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          )
          ),
        ),
        body:Container(
          color: Colors.white,
          child: AboutUsBody(),
        ),
    );
  }
}

//关于我们（检查更新和版本信息）
class AboutUsBody extends StatefulWidget {
  @override
  _AboutUsBodyState createState() => _AboutUsBodyState();
}

class _AboutUsBodyState extends State<AboutUsBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Container(
          width: 150,
          height: 150,
          margin: EdgeInsets.only(bottom: 20),
          child: Image.asset(
            "images/applogo.png",
            fit: BoxFit.cover,
            width: 150,
            height: 150,
          ),
        ),
        ListView(
          shrinkWrap: true,
          //相当于iOS中的tableview
          children: <Widget>[
            SizedBox(
              height: 10,
              child: Container(
                color: Color.fromRGBO(245, 245, 230, 0.5),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_alarms),
              title: Text("检查更新"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Fluttertoast.showToast(
                    msg: "当前已是最新版本",
                    timeInSecForIos: 2,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey
                );
              },
            ),
            //ListTile 是 Flutter 提供的用于快速构建列表项元素的小组件单元，相当于tableviewcell
            SizedBox(
              height: 1,
              child: Container(
                color: Color.fromRGBO(245, 245, 230, 1.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text("版本信息"),
              subtitle: Text('当前版本 1.0.0'),
              trailing: Icon(Icons.keyboard_arrow_right),//婺遗工坊
            ),
            SizedBox(
              height: 1,
              child: Container(
                color: Color.fromRGBO(245, 245, 230, 1.0),
              ),
            ),
            //第二行
//            Image.network(
//                "https://cdn2.jianshu.io/assets/web/banner-s-club-aa8bdf19f8cf729a759da42e4a96f366.png"
//            ),//第三行是加载了一张网络图片
          ],
        ),
      ]),
    );
  }
}
