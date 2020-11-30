import 'package:flutter/material.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/style_pages/textstyle.dart';
import 'package:ich/userinfo_pages/changepassword.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          elevation: 0,
          titleSpacing: 0.0,
          title: new Text(
            '设置',
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
        body: Container(
          child: SettingLayout(),
          color: Colors.white,
        ),
    );
  }
}


class SettingLayout extends StatefulWidget {
  @override
  _SettingLayoutState createState() => _SettingLayoutState();
}

class _SettingLayoutState extends State<SettingLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 245, 230, 1.0),
            ),
          ),
          //更改密码
          Container(
            child: new ListTile(
              title: new Text('更改密码'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
              onLongPress: () {
                // do something else
              },
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 245, 230, 1.0),
            ),
          ),
          //更换账号
          Container(
            child: new ListTile(
              title: new Text('更换账号'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                removeLocalData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/LoginPage", ModalRoute.withName("/LoginPage"));
              },
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 245, 230, 1.0),
            ),
          ),
          //推出当前账号
          Container(
            child: new ListTile(
              title: new Text('退出当前账号'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                removeLocalData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/LoginPage", ModalRoute.withName("/LoginPage"));
              },
            ),
          ),
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 245, 230, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}


