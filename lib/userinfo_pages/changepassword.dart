import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/style_pages/textstyle.dart';
import 'package:ich/user_pages/login_page.dart';

class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        centerTitle: true,
        title: Text(
          "更改密码",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
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
        color: Colors.white,
        child: ChangePasswordBody(),
      ),
    );
  }
}


//更改密码布局
class ChangePasswordBody extends StatefulWidget {
  @override
  _ChangePasswordBodyState createState() => _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends State<ChangePasswordBody> {

  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  TextEditingController newController = new TextEditingController();
  TextEditingController oldController = new TextEditingController();
  TextEditingController confirmController = new TextEditingController();
  String _textfield_old;
  String _textfield_confirm;
  String _textfield_new;


  void formSubmitted() {
    var _form = _key.currentState;
    if (_form.validate()) {
      _form.save();
      ChangePwdUpload();
    }
  }

  void ChangePwdUpload(){
    Map formData={
      'id':Global.userinfo.Id,
      'oldpwd':_textfield_old,
      'newpwd':_textfield_new
    };

    request('/User/ChangePwd',formData: formData,rowData:true).then((value) {
      if (value['code'] != 0) {
        //弹出信息value['msg']
      }
      else {
        //navigator.popuntil
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 2,
        ),
        //表单
        Container(
          margin: EdgeInsets.only(left: 20,top: 10),
          width: 380,
          child: Form(
            key: _key,
            autovalidate: true,
            child:Column(
              children: [
                Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text("旧密码 :",style: fogotText(),),
              ),//旧密码
                //输入旧密码表单
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: TextFormField(
                    obscureText: true,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      //键盘回车键的样式
                      textInputAction: TextInputAction.next,
                      controller: oldController,
                      decoration: InputDecoration(
                        hintText: "请输入旧密码",
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
                        _textfield_old = str;
                      },
                      // 校验用户名
                      validator: (v) {
                        if(v.trim().length==0){
                          return "旧密码不能为空";
                        }
                        if(oldController.text!=Global.userinfo.Password){
                          print(Global.userinfo.Password);
                          return "旧密码错误";
                        }


                      }),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("新密码 :",style: fogotText(),),
                ),//新密码
                //输入新密码
                Container(
                  child: Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    child: TextFormField(
                        obscureText: true,
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        //键盘回车键的样式
                        textInputAction: TextInputAction.next,
                        controller: confirmController,
                        decoration: InputDecoration(
                          hintText: "请输入新密码",
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
                          _textfield_new = str;
                        },
                        // 校验用户名
                        validator: (v) {
                          return v.trim().length > 3 ? null : "新密码不能少于四位";
                        }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text("确认密码 :",style: fogotText(),),
                ),//确认密码
                //确认新密码表单
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      //键盘回车键的样式
                      textInputAction: TextInputAction.next,
                      controller: newController,
                      decoration: InputDecoration(
                        hintText: "请确认密码",
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
                        _textfield_confirm = str;
                      },
                      // 校验用户名
                      validator: (v) {
                        if(newController.text!=confirmController.text){
                          return "密码不一致";
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //确认键
        Container(
          margin: EdgeInsets.only(left: 25,top: 10),
          height: 50,
          width: 200,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
            color: Colors.amber,
            child: Text(
              '确认',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onPressed: () {
              formSubmitted();
              print(_textfield_old);
              print(_textfield_new);
              print(_textfield_confirm);
              if(oldController.text==newController.text) {
                print(Global.userinfo.Password);
                Fluttertoast.showToast(
                    msg: "新密码不能于旧密码相同",
                    timeInSecForIos: 2,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey);
                //睡眠，强制等待2秒
              }
              if(newController.text==confirmController.text&&newController.text!=null) {
                print(Global.userinfo.Password);
                Fluttertoast.showToast(
                    msg: "更改成功",
                    timeInSecForIos: 2,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey);
                //睡眠，强制等待2秒
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/LoginPage", ModalRoute.withName("/LoginPage"));
                });
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => MinePage()));
              }

            },
          ),
        ),
      ],
    );
  }
}
