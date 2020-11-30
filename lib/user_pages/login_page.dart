import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/user_pages/forgotpassword.dart';
import 'package:ich/user_pages/register_page.dart';
import 'package:ich/common/Function.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  int lastTime = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
      //防止键盘谈起的时候导致背景视图升起*********
      body: Container(
        //width: 100, height: 100,
        //child: Image.asset("images/bg.jpg"),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/loginbackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 420,
                left: 0,
                right: 0,
                child:  Container(
                  child: LoginHomePage(),
                )
            ),

          ],
        ),
      ),
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
        }
    );

  }
}

class LoginHomePage extends StatefulWidget {
  @override
  _LoginHomePageState createState() {
    // TODO: implement createState
    return new _LoginHomePageState();
  }
}

class _LoginHomePageState extends State<LoginHomePage> {
  //请求
  Future<Map> userpwd(String user, String pwd) async {
    var url = "http://ich.laoluoli.cn/index.php/User/Login";
    var data1 = {'username': user, 'password': pwd};
    Response res = await Dio().post(url, data: data1);
    //print(res);
    var data = res.data['code'];
    if (data == 0)
      return res.data['data'];
    else
      return null;
    // return data;
  }

  //弹窗判断是否错误
  void showAlertDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('用户名或密码输入错误'),
            //可滑动
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {Navigator.of(context).pop();},
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Color.fromRGBO(255, 255, 255, 0.0),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30.0, right: 20.0),
              child: Column(children: <Widget>[
                buildForm(),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  TextEditingController unameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  GlobalKey formKey = new GlobalKey<FormState>();

  Widget buildForm() {
    return GestureDetector(
        onTap: () {
          print("jjj");
        },
        child: Form(
          //设置globalKey，用于后面获取FormState
          key: formKey,
          //开启自动校验
          autovalidate: true,
          child: Container(
            width: 300,
            height: 220,
            color: Color.fromRGBO(255, 255, 255, 0.0),
//        margin: EdgeInsets.only(top: 70),
            child: Column(
              children: <Widget>[
                //用户名输入
                Container(
                  height: 55,
                  child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      //键盘回车键的样式
                      textInputAction: TextInputAction.next,
                      controller: unameController,
                      decoration: InputDecoration(
                        hintText: "用户名",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(179, 179, 179, 1.0)),
                        icon: Icon(Icons.person, color: Colors.black26),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(252, 211, 89, 1.0),
                          ),
                        ),
//                      enabledBorder ：当TextField没有焦点时将起作用。
//                      focusedBorder ：当TextField成为焦点时它将起作用。
                      ),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : "用户名不能为空"; //提示用户名不能为空请输入
                      }),
                ),
                //登录密码输入
                Container(
                  height: 55,
                  child: TextFormField(
                      autofocus: false,
                      controller: pwdController,
                      decoration: InputDecoration(hintText: "登录密码", hintStyle: TextStyle(fontSize: 15, color: Color.fromRGBO(179, 179, 179, 1.0)),
                        icon: Icon(Icons.lock, color: Colors.black26),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(252, 211, 89, 1.0),
                          ),
                        ),
                      ),
                      obscureText: true,
                      //校验密码
                      validator: (v) {
                        return v.trim().length > 3 ? null : "密码不能少于4位";
                      }),
                ),

                // 忘记密码按钮
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 290,
                        height: 30,
                        alignment: Alignment.centerRight,
                        color: Color.fromRGBO(255, 255, 255, 0.0),
                        padding: EdgeInsets.only(left: 20),
                        child: FlatButton(
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          child: Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: '忘记密码?',
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(188, 188, 188, 1.0)))
                            ]),
                            textAlign: TextAlign.left,
                          ),
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassWord()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  child: loginButton(),
                ),
              ],
            ),
          ),
        ));
  }

  //登录和注册按钮
  Widget loginButton() {
    return Container(
      child: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 130,
                    margin: EdgeInsets.only(left: 30),
                    child: RaisedButton(
                      elevation: 0,
                      //padding: EdgeInsets.all(15.0),
                      child: Text(
                        "立即登录",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      color: Color.fromRGBO(252, 211, 89, 1.0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      onPressed: () {
                        //在这里不能通过此方式获取FormState，context不对
                        //print(Form.of(context));
                        // 通过_formKey.currentState 获取FormState后，
                        // 调用validate()方法校验用户名密码是否合法，校验
                        // 通过后再提交数据。

                        if ((formKey.currentState as FormState).validate()) {
                          print(pwdController.text);
                          userpwd(unameController.text.trim(),
                                  pwdController.text)
                              .then((value) {
                            if (value != null) {
                              Global.userinfo = new User(
                                  value['Id'],
                                  value['Username'],
                                  value['Password'],
                                  value['ProfilePicUrl'],
                                  value['Email'],
                                  value['Sex'],
                                  value['Birthday'],
                                  value['Brief']);
                              print(Global.userinfo.Username);
                              saveLocalData(value['Id']);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/BottomBarPage", ModalRoute.withName("/BottomBarPage"));

                            } else {
                              showAlertDialog();
                            }
                          });
                        }
                        //print(MediaQuery.of(context).viewInsets.bottom);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: FlatButton(
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              color: Color.fromRGBO(252, 211, 89, 1.0),
                              style: BorderStyle.solid,
                              width: 2.5)),
                      child: Text(
                        "注册",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(252, 211, 89, 1.0)),
                      ),
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
