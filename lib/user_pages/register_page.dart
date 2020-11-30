import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/common/acecheckbox.dart';
import 'package:ich/user_pages/agreement.dart';
import 'package:ich/user_pages/login_page.dart';

class RegisterPage extends StatelessWidget {
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
              image: AssetImage("images/rejisterbg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                  child:  Container(
                    child: RegisterPageBody(),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPageBody extends StatefulWidget {
  @override
  _RegisterPageBody createState() {
    // TODO: implement createState
    return new _RegisterPageBody();
  }
}

// ignore: camel_case_types
class _RegisterPageBody extends State<RegisterPageBody> {
  Future<bool> register(String user, String pwd, String email) async {
    var url = "http://ich.laoluoli.cn/index.php/User/ADD";
    var data1 = {'username': user, 'password': pwd, 'email': email};
    Response res = await Dio().post(url, data: data1);
    print(res);
    var data = res.data['code'];
    if (data == 0)
      return true;
    else
      return false;
    // return data;
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
              margin: EdgeInsets.only(left: 30.0, right: 20.0, top: 350),
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
  TextEditingController confirmpwdController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  GlobalKey formKey = new GlobalKey<FormState>();
  String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  bool isEmail(String input) {
    final isEmail = RegExp(regexEmail).hasMatch(input);
    if (isEmail) return true;
    return false;
  }

  Widget buildForm() {
    return Form(
      //设置globalKey，用于后面获取FormState
      key: formKey,
      //开启自动校验
      autovalidate: true,
      child: Container(
        width: 260,
        color: Color.fromRGBO(255, 255, 255, 0.0),
        child: Column(
          children: <Widget>[
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
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(252, 211, 89, 1.0),
                      ),
                    ),
//                      enabledBorder ：当TextField没有焦点时将起作用。
//                      focusedBorder ：当TextField成为焦点时它将起作用。
                  ),
                  // 校验用户名
                  validator: (v) {
                    return v.trim().length > 0
                        ? null
                        : "用户名不能为空"; //提示用户名不能为空请输入
                  }),
            ),
            Container(
              height: 55,
              child: TextFormField(
                  autofocus: false,
                  controller: pwdController,
                  decoration: InputDecoration(
                    hintText: "登录密码",
                    hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(179, 179, 179, 1.0)),
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
            Container(
              height: 55,
              child: TextFormField(
                  autofocus: false,
                  controller: confirmpwdController,
                  decoration: InputDecoration(
                    hintText: "确认密码",
                    hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(179, 179, 179, 1.0)),
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
                    if (confirmpwdController.text != pwdController.text) {
                      return "密码不一致";
                    }
//                    return v.trim().length > 3 ? null : "密碼不一致";
                  }),
            ),
            Container(
              height: 55,
              child: TextFormField(
                  autofocus: false,
                  controller: emailController,
                  keyboardType: TextInputType.number,
                  //键盘回车键的样式
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: "邮箱",
                    hintStyle: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(179, 179, 179, 1.0)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(252, 211, 89, 1.0),
                      ),
                    ),
                  ),
                  //校验密码
                  validator: (v) {
                    if (isEmail(emailController.text) == false) {
                      return "邮箱格式错误";
                    }
                    //return "郵箱不能為空";
//                    return v.trim().length > 3 ? null : "邮箱格式错误";
                  }),
            ),
            Container(
              padding: EdgeInsets.only(left: 0),
              child: registerButton(),
            ),
            Container(
              child: userAgreement(),
            ),
          ],
        ),
      ),
    );
  }

  void EmailAlertDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('邮箱格式错误'),
            //可滑动
            content: new SingleChildScrollView(),
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget registerButton() {
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
                    margin: EdgeInsets.only(left: 0),
                    child: RaisedButton(
                      elevation: 0,
                      //padding: EdgeInsets.all(15.0),
                      child: Text(
                        "立即注册",
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
                        if (!isAggree) {
                          //未勾选时提示
                          showDialog<Null>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: new Text('请勾选同意用户协议!'),
                                  //可滑动
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text('确定'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                          return;
                        }
                        if ((formKey.currentState as FormState).validate()) {
                          print(pwdController.text);
                          if (isEmail(emailController.text) == true) {
                            register(unameController.text, pwdController.text,
                                    emailController.text)
                                .then((value) {
                              if (value == true) {
                                Fluttertoast.showToast(
                                    msg: "注册成功",
                                    timeInSecForIos: 2,
                                    gravity: ToastGravity.CENTER,
                                    textColor: Colors.grey);
                                //睡眠，强制等待2秒
                                Future.delayed(Duration(seconds: 2), () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                });
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => MinePage()));
                              }
                            });
                          } else {
                            EmailAlertDialog();
                          }
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
                        "登录",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(252, 211, 89, 1.0)),
                      ),
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/LoginPage", ModalRoute.withName("/LoginPage"));
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

  Widget userAgreement() {
    return Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 25, top: 10),
            child: SwitchACECheckBoxTestRoute(),
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "注册即同意",
              style: TextStyle(fontSize: 11, color: Colors.black26),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AgreeMent()));
                },
                child: Row(
                  children: [
                    Text(
                      "《用户协议》和《隐私政策》",
                      style: TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

bool isAggree;

//单选框AXEBOX
class SwitchACECheckBoxTestRoute extends StatefulWidget {
  @override
  _SwitchACECheckBoxTestRouteState createState() =>
      new _SwitchACECheckBoxTestRouteState();
}

class _SwitchACECheckBoxTestRouteState
    extends State<SwitchACECheckBoxTestRoute> {
//  bool _switchSelected=true; //维护单选开关状态
  bool _triAceState = false; //维护复选框状态
  bool aceState = true;

  _SwitchACECheckBoxTestRouteState() {
    //全局变量赋初值
    isAggree = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        width: 20,
        child: ACECheckbox(
            width: 13,
            tristate: false,
            //是否为三态//三态，即选中态、非选中态，中间态
            value: _triAceState == false ? _triAceState : aceState,
            activeColor: Color.fromRGBO(255, 202, 0, 1.0),
            // 激活时的背景颜色
            checkColor: Colors.white,
            // 指针色，
            unCheckColor: Colors.black26,
            type: ACECheckBoxType.circle,
            //onChanged: (value) => setState(() => aceState = value),
            onChanged: (value) {
              // 点击时触发，true选中，false非选中，null是中间态
              setState(() {
                if (value == false) {
                  _triAceState = false;
                } else {
                  _triAceState = value; //钩
                  aceState = value;
                }
                isAggree = _triAceState;
              });
            }));
  }
}
