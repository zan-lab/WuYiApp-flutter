import 'package:flutter/material.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/style_pages/textstyle.dart';
import 'package:ich/user_pages/login_page.dart';
import 'package:ich/common/Function.dart';

class ForgotPassWord extends StatefulWidget {
  @override
  _ForgotPassWordState createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        title: Text(
          "忘记密码",
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
        )),
      ),
      body: Container(
        child: ForgotPassWordBody(),
      ),
    );
  }
}

class ForgotPassWordBody extends StatefulWidget {
  @override
  _ForgotPassWordBodyState createState() => _ForgotPassWordBodyState();
}

class _ForgotPassWordBodyState extends State<ForgotPassWordBody> {
  GlobalKey<FormState> _forgotkey = new GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  String _textfield_email;
  String _textfield_username;
  String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  bool isEmail(String input) {
    final isEmail = RegExp(regexEmail).hasMatch(input);
    if (isEmail) return true;
    return false;
  }

  void formSubmitted() {
    var _form = _forgotkey.currentState;
    if (_form.validate()) {
      _form.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, top: 50, right: 30),
      width: 390,
      child: Container(
//        decoration: BoxDecoration(
//          image: DecorationImage(
//            image: AssetImage("images/wjy.png"),
//            fit: BoxFit.cover,
//          ),
//        ),
        child: Form(
          autovalidate: true,
          key: _forgotkey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "用户名 :",
                  style: fogotText(),
                ),
              ), //确认密码
              //用户名表单
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    //键盘回车键的样式
                    textInputAction: TextInputAction.next,
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "请输入您的用户名",
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(179, 179, 179, 1.0)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(238, 238, 238, 1.0),
                        ),
                      ),
//                      enabledBorder ：当TextField没有焦点时将起作用。
//                      focusedBorder ：当TextField成为焦点时它将起作用。
//
                    ),
                    onSaved: (String str) {
                      _textfield_username = str;
                    },
                    // 校验用户名
                    validator: (v) {
                      return v.trim().length > 0 ? null : "用户名不能为空";
                    }),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  "邮箱 :",
                  style: fogotText(),
                ),
              ), //
              //输入邮箱
              Container(
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      //键盘回车键的样式
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "请输入您的邮箱",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(179, 179, 179, 1.0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(238, 238, 238, 1.0),
                          ),
                        ),
//                      enabledBorder ：当TextField没有焦点时将起作用。
//                      focusedBorder ：当TextField成为焦点时它将起作用。
//
                      ),
                      // 校验用户名
                      validator: (v) {
                        if (isEmail(emailController.text) == false) {
                          return "邮箱格式错误";
                        }
                      }),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 200,
//                color: Color.fromRGBO(255, 202, 0, 1.0),
                child: FlatButton(
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("提交",style: TextStyle(fontSize: 20,color: Colors.white),),
                  onPressed: () {
                    String username = usernameController.text;
                    String email = emailController.text;
                    Map formdata = {'username': username, 'email': email};
                    print(formdata);
                    request('/User/ResetPwd', formData: formdata, rowData: true)
                        .then((value) {
                      if (value['code'] == 0) {
                        forgotCorectView(value['data']['Password']);
                      } else {
                        forgotErrorView(value['msg']);
                      }
                    });

//                    if(true){
//                      forgotCorectView();
//                    }
//                    else{
//                      forgotErrorView();
//                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //正确之后的弹窗
  void forgotCorectView(String newpwd) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            child: new AlertDialog(
              title: new Text('请记住您的默认密码'),
              //可滑动
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(newpwd),
//                  new Text('内容 2'),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('确定'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          );
        });
  }

  //错误之后的弹窗
  void forgotErrorView(String errorMsg) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            child: new AlertDialog(
              title: new Text(errorMsg),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('确定'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
