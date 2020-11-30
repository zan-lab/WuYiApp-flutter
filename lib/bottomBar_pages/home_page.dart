import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ich/article_pages/ArticleDetail.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/ichSpeack_pages/add_comment_page.dart';
import 'package:ich/models/Goods.dart';
import 'package:ich/models/ICH.dart';
import 'package:ich/models/ICHArticle.dart';
import 'package:ich/models/ICHTalk.dart';
import 'package:ich/search_bar_pages/search_page.dart';
import 'package:ich/shop_pages/shop_detail_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ich/scripts/home_page_script.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController _controller;
String _title = "webview";


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0.0),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(252, 250, 245, 1.0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: Container(
            padding: EdgeInsets.only(top: 0.0),
            child: AppBar(
              elevation: 0,
              backgroundColor: Color.fromRGBO(255, 202, 0, 1.0),
              title: TextFileWidget(),
              leading: Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                  child: Image.asset('images/logo.png')),
              actions: <Widget>[
                Container(
                  width: 50,
                  margin: EdgeInsets.only(right: 5),
                  child:FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: Image.asset('images/scan.png',height: 30,fit: BoxFit.fill,),
                    onPressed:scan,
                  ) ,

                ),
              ],
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 0.0),
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              Column(
                children: <Widget>[
                  AspectRatioWidget(),
                  ICHBlockBottomWidget(),
                  NewsView(),
                  HotNewsView(),
                  HotICHSpeak(),
                  RecommentWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  扫描二维码
  Future<String> scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      print('扫码结果: '+barcode);
      openWebPage(barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException{
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }

  openWebPage(url){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          onPageFinished: (url) {
            _controller
                .evaluateJavascript("document.title")
                .then((result) {
              setState(() {
                _title = result;
              });
            });
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("myapp://")) {
              print("即将打开 ${request.url}");

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          javascriptChannels: <JavascriptChannel>[
            JavascriptChannel(
                name: "share",
                onMessageReceived:
                    (JavascriptMessage message) {
                  print("参数： ${message.message}");
                }),
          ].toSet(),
        ),
      ),
    );
  }
  //弹窗url
  void showAlertDialog(url) {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('是否跳转扫码结果'),
            //可滑动
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WebView(
                        initialUrl: url,
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (controller) {
                          _controller = controller;
                        },
                        onPageFinished: (url) {
                          _controller
                              .evaluateJavascript("document.title")
                              .then((result) {
                            setState(() {
                              _title = result;
                            });
                          });
                        },
                        navigationDelegate: (NavigationRequest request) {
                          if (request.url.startsWith("myapp://")) {
                            print("即将打开 ${request.url}");

                            return NavigationDecision.prevent;
                          }
                          return NavigationDecision.navigate;
                        },
                        javascriptChannels: <JavascriptChannel>[
                          JavascriptChannel(
                              name: "share",
                              onMessageReceived:
                                  (JavascriptMessage message) {
                                print("参数： ${message.message}");
                              }),
                        ].toSet(),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

}

//搜索框
class TextFileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Widget editView() {
    return Container(
      //修饰背景和圆角
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.all((Radius.circular(15.0))),
      ),
      alignment: Alignment.center,
      height: 30,
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
      child: TextField(
        onTap: (){showSearch(context: context, delegate: SearchBarWidget());},
        cursorColor: Colors.black12,
        decoration: InputDecoration(
          //输入框decoration属性
          contentPadding: EdgeInsets.fromLTRB(-15.0, -20.0, 0.0, 0.0),
          border: InputBorder.none,
          icon: Image.asset(
            'images/search1.png',
            width: 20.0,
            height: 20.0,
          ),
          hintText: "诸葛村古村落营造技艺",
          hintStyle: TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(191, 191, 191, 1.0),
          ),
        ),
        style: TextStyle(
          fontSize: 15,
          //color: Colors.black
        ),
      ),
    );
  }
}


//轮播图

class AspectRatioWidget extends StatefulWidget {
  @override
  _AspectRatioWidgetState createState() => _AspectRatioWidgetState();
}

class _AspectRatioWidgetState extends State<AspectRatioWidget> {


  List<Map> imageList = [
    {"url": "images/lbt001.jpg"},
    {"url": "images/lbt002.jpg"},
    {"url": "images/lbt003.jpg"},
    {"url": "images/lbt004.jpg"},
  ];

  List urlList = [
    "https://baijiahao.baidu.com/s?id=1650688195458999214&wfr=spider&for=pc",
    "https://www.jhnews.com.cn/xw/sh/202009/t20200918_333174.shtml",
    "https://www.sohu.com/a/357700583_785801",
    "https://www.sohu.com/a/419060136_162943",
  ];

//  List<String> imageUrl;

  @override
  Widget build(BuildContext context) {
//    getImage(index)
    return Center(
      child: Stack(
        children: [
          Image(
            width: double.infinity,
            image: AssetImage('images/bgImage3.png'),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                  blurRadius: 10.0, //阴影模糊程度
                  spreadRadius: -15.0, //阴影扩散程度
                ),
              ],
            ),
            //            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
            padding: EdgeInsets.all(18),
            //            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            height: 200,
            width: 370,
            child: AspectRatio(
              aspectRatio: 16 / 11,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: FlatButton(
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          //改变图片弧度
                          image: DecorationImage(
                            image: AssetImage(
                              imageList[index]['url'],
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) => WebView(
                            initialUrl: urlList[index],
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated: (controller) {
                              _controller = controller;
                            },
                            onPageFinished: (url) {
                              _controller
                                  .evaluateJavascript("document.title")
                                  .then((result) {
                                setState(() {
                                  _title = result;
                                });
                              });
                            },
                            navigationDelegate: (NavigationRequest request) {
                              if (request.url.startsWith("myapp://")) {
                                print("即将打开 ${request.url}");

                                return NavigationDecision.prevent;
                              }
                              return NavigationDecision.navigate;
                            },
                            javascriptChannels: <JavascriptChannel>[
                              JavascriptChannel(
                                  name: "share",
                                  onMessageReceived:
                                      (JavascriptMessage message) {
                                    print("参数： ${message.message}");
                                  }),
                            ].toSet(),
                          ),
                        ),
                        );
                      },
                    ),
                  );
                },
                itemCount: 4,
                autoplay: true,
                autoplayDisableOnInteraction: true,
                loop: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//轮播图后面的块块
class ICHBlockBottomWidget extends StatefulWidget {
  @override
  _ICHBlockBottomWidgetState createState() => _ICHBlockBottomWidgetState();
}

class _ICHBlockBottomWidgetState extends State<ICHBlockBottomWidget> {
  List textlist = ['黄大仙', '金华火腿', '诸葛古村', '金华婺剧', '赶茶场', '永康锡雕', '东阳木雕', '浦江剪纸',];
  List imagelist = ['images/1.jpg', 'images/2.jpg', 'images/3.jpg', 'images/4.jpg',
    'images/5.jpg', 'images/6.jpg', 'images/7.jpg', 'images/8.jpg',];
  List<int> idlist = [18, 6, 7, 2, 20, 9, 27, 29,];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 225.0,
      margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      padding: EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 30.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 2 / 3,
        ),
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return ICHBlockBottom(imagelist[index], textlist[index], idlist[index]);
        },
      ),
    );
  }
}

//滚动组件的块块
class ICHBlockBottom extends StatelessWidget {
  String imageurl;
  String textcontent;
  int id;

  ICHBlockBottom(this.imageurl, this.textcontent, this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: FlatButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
//        color: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        padding: EdgeInsets.all(0.0),
        //修改图片样式，加一个弧度
        child: Container(
          width: 70.0,
          height: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 45.0,
                height: 45.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150.0),
                  child: Image.asset(
                    imageurl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  textcontent,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 2.0,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ArticleDetailPage(id,'')));
        },
      ),
    );
  }
}

//非遗资讯
class NewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      height: 50,
//      width: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
            child: Text(
              '非遗资讯',
              style: TextStyle(
                color: Color.fromRGBO(242, 190, 69, 1.0),
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15.0),
              child: FutureBuilder<List<ICHArticle>>(
                future: getTopArticle(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      return VerticalSwiperWidget(snapshot.data);
                  }
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 2.0),
            width: 80.0,
            child: FlatButton(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Container(
//                      padding: EdgeInsets.only(right: 0.0),
                      child: Text(
                        '更多',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Color.fromRGBO(123, 120, 120, 1.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(123, 120, 120, 1.0),
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil("/BottomBarPageBranch1", ModalRoute.withName("/BottomBarPageBranch1"));
                //Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false)
              },
            ),
          ),
        ],
      ),
    );
  }
}

//非遗资讯滚动组件
class VerticalSwiperWidget extends StatelessWidget {
  List<ICHArticle> data;

  VerticalSwiperWidget(this.data);

  List<Map> textList = [
    {"url": "金丽衢 “非遗市集” 亮相金华1"},
    {"url": "金丽衢 “非遗市集” 亮相金华2"},
    {"url": "金丽衢 “非遗市集” 亮相金华3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.black,
//      padding: const EdgeInsets.only(top: 14.5),
      height: 50, // 高度
      child: Swiper(
        scrollDirection: Axis.vertical,
        // 纵向
        itemCount: data.length,
        // 数量
        autoplay: true,
        // 自动翻页
//        autoplayDisableOnInteraction: true,
       physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          // 构建
          return Container(
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              child: Text(
                data[index].Title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ArticleDetailPage(data[index].ICHId,"")));
              },
            ),
          );
        },
      ),
    );
  }
}

//热门非遗
class HotNewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                child: Text(
                  '热门非遗',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(''),
              ),
              Container(
//                alignment: Alignment.centerRight,
                width: 80.0,
                child: FlatButton(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
//                      padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            '更多',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color.fromRGBO(123, 120, 120, 1.0),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromRGBO(123, 120, 120, 1.0),
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil("/BottomBarPageBranch1", ModalRoute.withName("/BottomBarPageBranch1"));
                  },
                ),
              ),
            ],
          ),
          FutureBuilder<List<ICH>>(
              future: getTopICH(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<ICH>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    return Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 6 / 10,
                        ),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return _HotICH(snapshot.data[index]);
                        },
                      ),
                    );
                }
              }),
        ],
      ),
    );
  }
}

class _HotICH extends StatelessWidget {
  ICH data;

  _HotICH(this.data);

  String pirurl =
      'http://ich.laoluoli.cn/uploads/ICHPic/20200829/8a71c9220a0eeb8ce63466039dad44b0.jpg';
  String name = "浦江乱弹";
  int id = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 140.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    data.PicUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onPressed: () {
                //将this。id传入文章详细页，详细页初始化时根据id加载
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ArticleDetailPage(data.Id,'')));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0.0),
            height: 25.0,
            child: Text(
              data.Name,
              overflow: TextOverflow.ellipsis,
//              maxLines: 2,
//              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//热门非遗说
class HotICHSpeak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                child: Text(
                  '热门非遗说',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(''),
              ),
              Container(
//                alignment: Alignment.centerRight,
                width: 80.0,
                child: FlatButton(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
//                      padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            '更多',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color.fromRGBO(123, 120, 120, 1.0),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromRGBO(123, 120, 120, 1.0),
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil("/BottomBarPageBranch2", ModalRoute.withName("/BottomBarPageBranch2"));
                  },
                ),
              ),
            ],
          ),
          FutureBuilder<List<ICHTalk>>(
            future: getTopTalk(),
            builder:
                (BuildContext context, AsyncSnapshot<List<ICHTalk>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  //print(snapshot.data);
                  return ICHSpeak(snapshot.data);
              }
            },
          )
          //ICHSpeak(),
        ],
      ),
    );
  }
}

//热门非遗说滚动组件
class ICHSpeak extends StatelessWidget {
  List<ICHTalk> data;

  ICHSpeak(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Swiper(
          itemCount: data.length,
          autoplay: true,
//          control: SwiperControl(
//              iconPrevious: Icons.arrow_back_ios,
//              iconNext: Icons.arrow_forward_ios,
//              color: Color.fromRGBO(229, 206, 130, 1.0),
//              size: 50.0,
//              padding: EdgeInsets.all(14.0)),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ICHCard(data[index]),
            );
          },
        ),
      ),
    );
  }
}

//热门非遗说卡面
class ICHCard extends StatelessWidget {
  ICHTalk data;

  ICHCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      height: 300.0,
      child: Card(
        color: Color.fromRGBO(247, 244, 233, 1.0),
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    height: 40.0,
                    width: 40.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        data.userProfilePicUrl,
                        //'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2907227418,1639643895&fm=26&gp=0.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: 100.0,
                          child: Text(
                            data.userName,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              height: 1.0,
                            ),
                          ),
                        ),
                        Container(
                          width: 100.0,
                          child: Text(
                            data.CreateDate,
                            //'今天11:57',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Color.fromRGBO(138, 138, 138, 1.0),
                              height: 1.2,
                              wordSpacing: 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                  Container(
                    width: 25.0,
                    height: 25.0,
                    child: Image.asset('images/location.png'),
                  ),
                  Container(
                    child: Text(
                      '金华·金华市博物馆',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
//              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20.0,right: 10.0,),
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 45.0,
                    width: 300.0,
                    child: Text(
                      data.Content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      //'婺上百年——陈尧山书画印展\n书法作品鉴赏·隶书 自题诗（1989年）',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0.0),
                    padding: EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        //'images/photo1.png',
                        data.Photo1Url,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 90,
                      ),
                    ),

                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(''),
                  ),
                  Container(child: HomeLikeButton(data.LikeCount,data.Id)),
                  Container(child: HomeCommentBottom(data.Id),),
                  Container(child: HomeForwardBottom(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//热门非遗说点赞变色
class HomeLikeButton extends StatefulWidget {
  int likeCount;
  int talkid;
  HomeLikeButton(this.likeCount,int talkid);

  @override
  _HomeLikeButtonState createState() => _HomeLikeButtonState(likeCount,talkid);
}
class _HomeLikeButtonState extends State<HomeLikeButton> {
  int talkid;
  _HomeLikeButtonState(this.likeCount,this.talkid);

  static final Image heartSolidicon = Image.asset('images/activelike.png');
  static final Image hearticon = Image.asset('images/like.png');
  Image image = _HomeLikeButtonState.hearticon;
  int likeCount = 90;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        children: [
          Container(
            width: 25.0,
            height: 25.0,
            child: IconButton(
              iconSize: 25.0,
//              splashColor: Colors.redAccent,
              padding: EdgeInsets.all(0.0),
              icon: image,
            ),
          ),
          Text(
            this.likeCount.toString(),
            style: TextStyle(
              fontSize: 13.0,
              height: 1.9,
            ),
          ),
        ],
      ),
    );
  }
}

//评论按钮 加一
class HomeCommentBottom extends StatefulWidget {
  int talkid;
  HomeCommentBottom(this.talkid);
  @override
  _HomeCommentBottomState createState() => _HomeCommentBottomState(talkid);
}
class _HomeCommentBottomState extends State<HomeCommentBottom> {
  int talkid;
  static final Image _commentImage = Image.asset('images/comment.png');
  int _p = 123;
_HomeCommentBottomState(this.talkid);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          //评论图标
          Container(
            margin: EdgeInsets.only(
              top: 0.0,
            ),
            width: 25.0,
            height: 25.0,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              iconSize: 25.0,
              padding: EdgeInsets.all(0.0),
              icon: _commentImage,
            ),
          ),
          //评论的数量
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              '',
              //_p.toString(),
              style: TextStyle(
                fontSize: 13.0,
                height: 1.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//转发按钮 弹框 +1
class HomeForwardBottom extends StatefulWidget {
  @override
  _HomeForwardBottomState createState() => _HomeForwardBottomState();
}
class _HomeForwardBottomState extends State<HomeForwardBottom> {
  static final Image _forwardImage = Image.asset('images/share.png');
  int _z = 456;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          //转发按钮
          Container(
            margin: EdgeInsets.only(bottom: 0.0),
            width: 25.0,
            height: 25.0,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 25.0,
              padding: EdgeInsets.all(0.0),
              icon: _forwardImage,
            ),
          ),
          //转发的数量
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: Text(
              //_z.toString(),
              '',
              style: TextStyle(
                fontSize: 13.0,
                height: 1.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//为你推荐
class RecommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
              '为你推荐',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
//            height: 300.0,
            child: FutureBuilder<List<Goods>>(
                future: getTopGoods(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Goods>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      return RecommondWidget(snapshot.data);
                  }
                }),
          )
        ],
      ),
    );
  }
}

class RecommondWidget extends StatelessWidget {
  List<Goods> data;

  RecommondWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 12/16,
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
        ),
        shrinkWrap: true,
        primary: false,
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return RecommentCardWidget(data[index]);
        },
      ),
    );
  }
}

//为你推荐卡片组件
class RecommentCardWidget extends StatelessWidget {
  Goods data;

  RecommentCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
//      margin: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 145.0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image.network(
                  data.PicUrl,
                  //'http://ich.laoluoli.cn/uploads/ICHPic/20200829/4c213083e4a565205e52d1f628873cd0.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
//              color: Colors.amber,
//                        width: 200.0,
              child: ListTile(
                title: Text(
                  data.Name,
                  overflow: TextOverflow.ellipsis,
                  //'婺剧门票',
                  style: TextStyle(
//                    height: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  data.Brief,
                  overflow: TextOverflow.ellipsis,
                  //'金华婺剧院精品婺剧门票热销中' + '\n',
                  style: TextStyle(
                    color: Color.fromRGBO(138, 138, 138, 1.0),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
              ),
            ),
            Container(
//              color: Colors.red,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Text(
                      '11580人付款',
                      style: TextStyle(
                        height: 0.0,
                        color: Color.fromRGBO(138, 138, 138, 1.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(''),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text(
                      '￥'+data.Price.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        height: 0.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShopDetailPage(data.Id)));

        },
      ),
    );
  }
}
