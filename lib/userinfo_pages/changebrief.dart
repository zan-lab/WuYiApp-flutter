import 'package:flutter/material.dart';
import 'package:ich/common/Global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/mine_pages/info.dart';

class Changebrief extends StatefulWidget {
  @override
  _ChangebriefState createState() => _ChangebriefState();
}

class _ChangebriefState extends State<Changebrief> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        centerTitle: true,
        title: Text(
          "个性签名",
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
        child: ChangeBriefBody(),
      ),
    );
  }
}

//更改个性签名的布局
class ChangeBriefBody extends StatefulWidget {
  @override
  _ChangeBriefBodyState createState() => _ChangeBriefBodyState();
}

class _ChangeBriefBodyState extends State<ChangeBriefBody> {

  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  String _textfield;

  void formSubmitted() {
    var _form = _key.currentState;
    if (_form.validate()) {
      _form.save();
      print(_textfield);
      Global.userinfo.Brief=_textfield;
      //上传信息并下载信息
      Global.userinfo.UploadInfo().then((value) => Global.userinfo.Reload());
    }
  }

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
//setState很重要不然数据不会更新！！！
    setState((){
      _controller = new TextEditingController(text: Global.userinfo.Brief,);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 50,
          alignment: Alignment.centerLeft,
          child: Text(
            "个性签名:",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        Form(
          key: _key,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              maxLines: 1,
              minLines: 1,
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
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              validator: (v) {
                if (v.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "请输入你的个性签名",
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black12,
                    textColor: Colors.black54,
                  );
                }
                print(v.toString());
                return null;
              },
              onSaved: (String str) {
                _textfield = str;

              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            height: 1,
            child: Container(
              color: Color.fromRGBO(245, 240, 230, 1.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20,top: 10,bottom: 20),
          alignment: Alignment.centerLeft,
          child: Text("快向他人展示你独特的一面吧！",
            style: TextStyle(
                color: Color.fromRGBO(138, 138, 138, 1.0)
            ),),
        ),
        //确认键
        Container(
          height: 50,
          width: 200,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35)),
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
              if (_textfield.isEmpty) {
              } else {
                setState(() {
                  Global.userinfo.Brief=_textfield;
                  //上传信息并下载信息
                  Global.userinfo.UploadInfo().then((value) => Global.userinfo.Reload());
                });
                Fluttertoast.showToast(
                    msg: "更改成功",
                    timeInSecForIos: 2,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey
                );
                //睡眠，强制等待2秒
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                  reFresh();

                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfo()));
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

  void reFresh() {
    var _list = [1, 2, 3, 4, 5];

    RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _list.add(_list.length + 1);
        });

      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('老孟${_list[index]}'),
          );
        },
        itemExtent: 50,
        itemCount: _list.length,
      ),
    );
  }

}
