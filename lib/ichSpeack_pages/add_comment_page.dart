import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:ich/common/Global.dart';
import 'package:ich/common/Function.dart';

String _content;
int talkId;
class CommentAddWidget extends StatefulWidget {
  CommentAddWidget(int talkid){
    talkId=talkid;
  }
  @override
  _CommentAddWidgetState createState() => _CommentAddWidgetState();

}

FormTalkAddWidget _formWidget;

class _CommentAddWidgetState extends State<CommentAddWidget> {
  _CommentAddWidgetState();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(1.0, 10.0, 0.0, 10.0),
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              child: Text(
                '取消',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              //隐藏点击的波纹
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: <Widget>[
            Container(
              width: 80.0,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.amber,
                padding: EdgeInsets.all(0.0),
                child: Text(
                  '评论',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                //隐藏点击的波纹
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  _formWidget.submit();
                  //print(_content);
                  if(_content.isNotEmpty) {
                    Fluttertoast.showToast(
                        msg: "评论成功",
                        timeInSecForIos: 2,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.grey);
                    //睡眠，强制等待2秒
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        body: Container(
          child: _formWidget=FormTalkAddWidget(),
        ),
      ),
    );
  }
}

class FormTalkAddWidget extends StatefulWidget {
  _FormTalkAddWidgetState form;

  submit() {
    form.forSubmitted();
  }

  @override
  _FormTalkAddWidgetState createState() => form = _FormTalkAddWidgetState();
}

class _FormTalkAddWidgetState extends State<FormTalkAddWidget> {
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  String _textfield;

  void forSubmitted() {
    var _form = _key.currentState;
    if (_form.validate()) {
      _form.save();
      _content = _textfield;
      //print(_textfield);
      //print(_content);
    }
    //上传接口
   uploadForm();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            //表单
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              minLines: 8,
              decoration: InputDecoration(
                hintText: '写评论...',
                hintStyle: TextStyle(fontSize: 20.0),
                contentPadding: EdgeInsets.all(10.0),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                //取消自带的下划线
                border: InputBorder.none,
              ),
              validator: (v) {
                if (v.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "请输入你要发布的内容",
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
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> uploadForm() async {
  var path = '/ICHTalk/AddComment';
  var data = {
    'talkid':talkId,
    'userid': Global.userinfo.Id,
    'content':_content,
  };
  print(data);
  var res = await request(path, formData: data);
  print(res);
}
