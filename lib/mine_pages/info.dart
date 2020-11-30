import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/bottomBar_pages/mine_page.dart';
import 'package:ich/style_pages/textstyle.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/userinfo_pages/changebrief.dart';
import 'package:ich/userinfo_pages/changephoto.dart';
import 'package:ich/userinfo_pages/jhpickertool.dart';
import 'package:ich/common/Function.dart';
class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1.0),
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "我的账号",
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        leading: (IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
      ),
      body: Container(
        child: InfoListView(),
      ),
    );
  }
}

//账号信息，用户信息
class InfoListView extends StatefulWidget {
  @override
  _InfoListViewState createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> {
  DateTime selectedDate = DateTime.now(); //定位当前日期

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, //初始值
        firstDate: DateTime(1979, 8), //开始日期
        lastDate: DateTime(2101)); //结束日期
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked; //弹出一个像日历的选择器，进行日期的选择
      });
  }


  //选择性别处理
  void changeSex() {
    var aa = ["女", "男", "保密"];
//       var aa =  [11,22,33,44];

    JhPickerTool.showStringPicker(context, data: aa,
//           normalIndex: 2,
//           title: "请选择2",
        clickCallBack: (int index, var str) {
      print(index);

      //上传信息并下载信息
      setState(() {
        Global.userinfo.Sex = index;
        Global.userinfo.UploadInfo().then((value) => Global.userinfo.Reload());
      });
      Fluttertoast.showToast(
          msg: "更改成功",
          timeInSecForIos: 2,
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
      //睡眠，强制等待2秒
      Future.delayed(Duration(seconds: 1), () {

        //Navigator.pop(context);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfo()));
        //Navigator.pop(context);
      });
    });
  }

//日期的获取（年龄选择计算）
  void changeAge() {
    JhPickerTool.showDatePicker(context, dateType: DateType.YMD,
//            dateType: DateType.YM,
//            dateType: DateType.YMD_HM,
//            dateType: DateType.YMD_AP_HM,
//             title: "请选择2",
//            minValue: DateTime(2020,10,10),
//            maxValue: DateTime(2023,10,10),
//            value: DateTime(2020,10,10),
        clickCallback: (var str, var time) async {
          setState(() {
            Global.userinfo.BirthdayString = time.toString().substring(0, 10);
            print(Global.userinfo.BirthdayString);
            //上传信息并下载信息
            Global.userinfo.birthday=DateTime.parse(Global.userinfo.BirthdayString);
            Global.userinfo.age=DateTime.now().year-Global.userinfo.birthday.year;
            print(Global.userinfo.age);
            Global.userinfo.UploadInfo().then((value) => Global.userinfo.Reload());
          });

      Fluttertoast.showToast(
          msg: "更改成功",
          timeInSecForIos: 2,
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);

//      睡眠，强制等待2秒
      Future.delayed(Duration(seconds: 1), () {

        //Navigator.pop(context);
      });
    });
  }

//选择后的显示方法
  // ignore: missing_return
  String _getSexWord() {
    //根据Global.userinfo的Sex来判断
    if (Global.userinfo.Sex == null)
      return "保密";
    else {
      switch (Global.userinfo.Sex) {
        case 1:
          return "男";
        case 0:
          return "女";
        case 2:
          return "保密";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    return Container(
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 12,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 0.0),
            ),
          ),
          Container(
            height: 75,
//            color: Color.fromRGBO(255, 255, 255, 1.0),
            child: ListTile(
              title: Row(
                children: [
                  Text('头像'),
                  Container(
                    width: 295,
                    alignment: Alignment.centerRight,
                    child: GetInfoImage(),
                  ),
//                  Image.network('https://profile.csdnimg.cn/6/4/0/1_niceyoo')
                ],
              ),
              trailing: Container(
                width: 10,
                margin: EdgeInsets.only(right: 10, top: 10),
                child: Icon(Icons.keyboard_arrow_right),
              ),
              onTap: () {
                // do something
                //Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChangePhoto()));
              },
              onLongPress: () {
                // do something else
              },
            ),
            color: Colors.white,
            padding: EdgeInsets.only(left: 15),
          ), //头像
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15),
            child: new ListTile(
              title: Row(children: [
                Container(
                  child: Text('昵称'),
                ),
                Container(
                  width: 295,
                  alignment: Alignment.centerRight,
                  child: Text(
                    Global.userinfo.Username,
                    textAlign: TextAlign.right,
                    style: infoTexStyle(),
                  ),
                ),
              ]),
              trailing: Container(
                width: 10,
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ), //昵称
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15),
            child: new ListTile(
              title: Row(children: [
                Container(
                  child: Text('邮箱'),
                ),
                Container(
                  width: 295,
                  alignment: Alignment.centerRight,
                  child: Text(
                    Global.userinfo.Email,
                    textAlign: TextAlign.right,
                    style: infoTexStyle(),
                  ),
                ),
              ]),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ), //邮箱
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15),
            child: new ListTile(
              title: Row(children: [
                Container(
                  child: Text('性别'),
                ),
                Container(
                  width: 295,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _getSexWord(),
                    textAlign: TextAlign.right,
                    style: infoTexStyle(),
                  ),
                ),
              ]),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => changeSex(),
              onLongPress: () {
                // do something else
              },
            ),
          ), //性别
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15),
            child: new ListTile(
              title: Row(children: [
                Container(
                  child: Text('年龄'),
                ),
                Container(
                  width: 295,
                  alignment: Alignment.centerRight,
                  child: Text(
                    Global.userinfo.age.toString(),
                    textAlign: TextAlign.right,
                    style: infoTexStyle(),
                  ),
                ),
              ]),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => changeAge(),
              onLongPress: () {
                // do something else
              },
            ),
          ), //年龄
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15),
            child: new ListTile(
              title: Row(children: [
                Expanded(
                  child: Container(
                    child: Text('个性签名'),
                    height: 30,
                    width: 120,
                  ),
                ),

                  Container(
                    width: 165,
                    alignment: Alignment.centerRight,
                    child: Text(
//                      "scijfkednknijkjdfoiwkdowkdojwohoiwfjcspdsvfvaspowckpojoijfpcod;lsmdnfuhdfidiosjfiosdjj",
                      Global.userinfo.Brief,
                      overflow: TextOverflow.ellipsis,
//                      softWrap: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, color: Colors.black26),
                    ),
                  ),
                ],),
                trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // do something
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Changebrief()));
              },
              onLongPress: () {
                // do something else
              },),
            ), //性签名
          SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
          Container(
            color: Colors.white,
            height: 50,
            child: RaisedButton(
              color: Colors.white,
              onPressed: () {
                removeLocalData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    "/LoginPage", ModalRoute.withName("/LoginPage"));
              },
              child: Text(
                '退出当前账号',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
            ),
          ), //退出当前账号
        ],
      ),
    );
  }
}

//圆形头像处理
class GetInfoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
//          alignment: Alignment.centerLeft,
      height: 50.0,
      width: 50.0,
      decoration: BoxDecoration(
          // 装饰器
//          color: Colors.blue, // 深蓝绿色
          border: Border.all(
              color: Colors.amber, // 边框黄色
              width: 0.0),
          borderRadius: BorderRadius.all(Radius.circular(150)), // 盒子圆角
          // borderRadius: BorderRadius.circular(150)
          image: DecorationImage(
            // image: Image.network("http://xxx.xxx.xx.jpeg") // error
            image: NetworkImage(
                // "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1028479771,2944343576&fm=26&gp=0.jpg"
                Global.userinfo.ProfilePicUrl),
          )),
      padding: EdgeInsets.all(10), // 盒子内边距
    );
  }
}
