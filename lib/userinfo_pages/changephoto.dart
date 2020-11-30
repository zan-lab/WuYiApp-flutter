import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';//toast
import 'package:image_picker/image_picker.dart';//从相册里面选择图片或者拍照获取照片
import 'package:ich/common/Global.dart';

class ChangePhoto extends StatefulWidget {
  @override
  _ChangePhoto createState() => _ChangePhoto();
}

class _ChangePhoto extends State<ChangePhoto> {
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _upLoadImage(image);//上传图片
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        centerTitle: true,
        title: Text('选择图片',style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),),
        leading: (IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        )
        ),
      ),
      body: Center(
        child: Global.userinfo.ProfilePicUrl == null
            ? Image.asset('')
            : Image.network(Global.userinfo.ProfilePicUrl),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        backgroundColor: Colors.amber,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo,),
      ),
    );
  }
//上传图片
  _upLoadImage(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    // FormData formData = new FormData.fromMap({
    //   "file": new MultipartFile.fromFile (new File(path), name)
    // });

    FormData formdata = FormData.fromMap({
      'userid':Global.userinfo.Id,
      "image": await MultipartFile.fromFile(path, filename:name)
    });


    String rout = 'http://ich.laoluoli.cn/index.php/User/UploadPhoto';
    Dio dio = new Dio();
    var respone = await dio.post(rout, data: formdata);
    if (respone.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "图片上传成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey);
        Global.userinfo.Reload();
      // imageUrl=respone.data['data']['url'];

      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePhoto()));
    }
  }
}