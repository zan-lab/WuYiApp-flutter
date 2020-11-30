import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ich/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/common/Function.dart';

List<Asset> images = List<Asset>();
String _error = 'No Error Dectected';
String _picurl1;
String _picurl2;
String _picurl3;
String _content;

void _addPirurl(String url) {
  print(
      "....................................................................................................................................");
  print(_picurl1);
  print(_picurl2);
  print(_picurl3);
  if (_picurl1 == "") {
    _picurl1 = url;
  } else if (_picurl2 == "") {
    _picurl2 = url;
  } else if (_picurl3 == "") {
    _picurl3 = url;
  } else
    return;
}

class TalkAddWidget extends StatefulWidget {
  @override
  _TalkAddWidgetState createState() => _TalkAddWidgetState();
}

FormTalkAddWidget _formWidget;

class _TalkAddWidgetState extends State<TalkAddWidget> {
  @override
  void initState() {
    _picurl1 = "";
    _picurl2 = "";
    _picurl3 = "";
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
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
              //隐藏点击的波纹
//              highlightColor: Colors.transparent,
//              splashColor: Colors.transparent,
              onPressed: () {
                images = List<Asset>();
                Navigator.pop(context);
              },
            ),
          ),
          actions: <Widget>[
            Container(
//              width: 80.0,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(Icons.image,color: Colors.black,),
                //隐藏点击的波纹
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  uploadImages();
                },
              ),
            ),
          ],
        ),
        body: Container(
          child: FormTalkAddWidget(),
        ),
      ),
    );
  }

  Future<void> uploadImages() async {
    String error = 'No Error Dectected';
    Dio dio = new Dio();
    setState(() {
      images = List<Asset>();
    });
    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 3,
        // 是否支持拍照
        enableCamera: true,
        materialOptions: MaterialOptions(
            // 显示所有照片，值为 false 时显示相册
            startInAllView: true,
            allViewTitle: '所有照片',
            actionBarColor: '#2196F3',
            textOnNothingSelected: '没有选择照片'),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    images = (resultList == null) ? [] : resultList;
    // 上传照片时一张一张上传
    for (int i = 0; i < images.length; i++) {
      // 获取 ByteData
      var byteData = await images[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        // 文件名
        filename: 'some-file-name.jpg',
        // 文件类型
        contentType: MediaType("image", "jpg"),
      );
      FormData formData = FormData.fromMap({
        // 后端接口的参数名称
        "image": multipartFile
      });
      // 后端接口 url
      String url = 'http://ich.laoluoli.cn/index.php//ICHTalk/UploadPic';
      // 后端接口的其他参数
      Map<String, dynamic> params = Map();
      var response =
          await dio.post(url, data: formData, queryParameters: params);
      print(response.data);
      _addPirurl(response.data['data']['url']);
    }
    // 使用 dio 上传图片
    setState(() {
      images = resultList;
      _error = error;
    });
    //do something with response...
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

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  void forSubmitted() {
    var _form = _key.currentState;
    if (_form.validate()) {
      _form.save();
      print(_textfield);
      _content = _textfield;
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
                hintText: '分享新鲜事...',
                hintStyle: TextStyle(fontSize: 20.0),
                contentPadding: EdgeInsets.all(10.0),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                //取消自带的下划线
                border: InputBorder.none,
              ),
//                onChanged: (String str){
//                  print(str);
//                },
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
            //图片显示
            Container(
              height: 150.0,
              child: buildGridView(),
            ),
            //下划线
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: Colors.black12),
                ),
              ),
            ),
            //发表按钮
            Container(
              width: 500.0,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 15.0,top: 10),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.amber,
                padding: EdgeInsets.all(0.0),
                child: Text(
                  '发表',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  forSubmitted();
                  if(_textfield.isEmpty){}
                  else{
                    Fluttertoast.showToast(
                        msg: "发布成功",
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
      ),
    );
  }
}

Future<void> uploadForm() async {
  var path = '/ICHTalk/Add';
  var data = {
    'userid': Global.userinfo.Id,
    'content': _content,
    'photo1url': _picurl1,
    'photo2url': _picurl2,
    'photo3url': _picurl3,
  };
  print(data);
  var res = await request(path, formData: data);
  print(res);
}
