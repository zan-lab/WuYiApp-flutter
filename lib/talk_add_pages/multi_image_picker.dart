import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class Multi_Image_Picker extends StatefulWidget {
  @override
  _Multi_Image_PickerState createState() => new _Multi_Image_PickerState();
}

class _Multi_Image_PickerState extends State<Multi_Image_Picker> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

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

//不上传的版本，先不删除
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
//            Center(child: Text('Error: $_error')),
          Container(
            width: 137,
            height: 137,
            child: RaisedButton(
              child: Text("Pick images"),
              onPressed: uploadImages,
            ),
          ),

          Expanded(
            child: buildGridView(),
          )
        ],
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
      // 使用 dio 上传图片
//      var response = await dio.post(url, data: formData, queryParameters: params);
      //
      // do something with response...
//      print(response.data);

    }
    setState(() {
      images = resultList;
      _error = error;
    });
  }
}

//class Test{
//  List<Asset> images = List<Asset>();
//
//  // 选择照片并上传
//  Future<void> uploadImages() async {
//    setState(() {
//      images = List<Asset>();
//    });
//    List<Asset> resultList;
//
//    try {
//      resultList = await MultiImagePicker.pickImages(
//        // 选择图片的最大数量
//        maxImages: 9,
//        // 是否支持拍照
//        enableCamera: true,
//        materialOptions: MaterialOptions(
//          // 显示所有照片，值为 false 时显示相册
//            startInAllView: true,
//            allViewTitle: '所有照片',
//            actionBarColor: '#2196F3',
//            textOnNothingSelected: '没有选择照片'
//        ),
//      );
//    } on Exception catch (e) {
//      e.toString();
//    }
//
//    if (!mounted) return;
//    images = (resultList == null) ? [] : resultList;
//    // 上传照片时一张一张上传
//    for(int i = 0; i < images.length; i++) {
//      // 获取 ByteData
//      ByteData byteData = await images[i].getByteData();
//      List<int> imageData = byteData.buffer.asUint8List();
//
//      MultipartFile multipartFile = MultipartFile.fromBytes(
//        imageData,
//        // 文件名
//        filename: 'some-file-name.jpg',
//        // 文件类型
//        contentType: MediaType("image", "jpg"),
//      );
//      FormData formData = FormData.fromMap({
//        // 后端接口的参数名称
//        "files": multipartFile
//      });
//      // 后端接口 url
//      String url = ''；
//      // 后端接口的其他参数
//      Map<String, dynamic> params = Map();
//      // 使用 dio 上传图片
//      var response = await dio.post(url, data: formData, queryParameters: params);
//      //
//      // do something with response...
//    }
//  }
//}
