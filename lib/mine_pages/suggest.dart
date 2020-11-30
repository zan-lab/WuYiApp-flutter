import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ich/bottomBar_pages/mine_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'file:///F:/flutter_prom/flutter_feiyi2/lib/style_pages/textstyle.dart';

import 'about_us.dart';

TextEditingController suggestController = new TextEditingController();
GlobalKey formKey = new GlobalKey<FormState>();

class Suggest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        centerTitle: true,
        title: Text(
          "用户反馈",
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
      body: SuggestFrom(),
    );
  }
}

class SuggestFrom extends StatefulWidget {
  @override
  _SuggestFromState createState() => _SuggestFromState();
}

class _SuggestFromState extends State<SuggestFrom> {
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  String _textfield;

  void formSubmitted() {
    var _form = _key.currentState;
    if (_form.validate()) {
      _form.save();
      print(_textfield);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10,right: 10,
          top: 30,
        ),
        child: Column(children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text(
                '反馈意见:   ',
                style: TextStyle(
                  fontSize: 18,
                ),
              )),
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Form(
              key: _key,
              child: Theme(
                data: new ThemeData(
                  primaryColor: Colors.black12,
                  hintColor: Colors.black12,
                ),
                child: new TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 11,
                  minLines: 11,
                  decoration: const InputDecoration(
                    hintText: '输入',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    isDense: true,
                    border: const OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 202, 0, 1.0),
                        width: 1,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "请输入你要提交的内容",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black12,
                        textColor: Colors.black54,
                      );
                    }
                    return null;
                  },
                  onSaved: (String str) {
                    _textfield = str;
                  },
                ),
              ),
            ),
            // Text('222'),
          ),
          Container(
            padding: EdgeInsets.only(right: 15,top: 20),
            alignment: Alignment.centerRight,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              splashColor: Colors.black12,
              highlightColor: Colors.black12,
              color: Colors.amber,
              padding: EdgeInsets.all(10.0),
              child: Text("提交",style: TextStyle(fontSize: 20),),
              textColor: Colors.white,
              onPressed: () {
                formSubmitted();
                if (_textfield.isEmpty) {
                } else {
                  Fluttertoast.showToast(
                      msg: "反馈成功",
                      timeInSecForIos: 2,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.grey);
                  //睡眠，强制等待2秒
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => MinePage()));
                }
              },
            ),
          ),
        ]));
  }
}


