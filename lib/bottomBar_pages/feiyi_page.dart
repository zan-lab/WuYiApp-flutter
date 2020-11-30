import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/ichSpeack_pages/add_comment_page.dart';
import 'package:ich/models/ICHTalk.dart';
import 'package:ich/models/ICHTalkComment.dart';
import 'package:ich/photo_view_pages/photo_view_page.dart';
import 'package:ich/search_bar_pages/search_page.dart';
import 'package:ich/talk_add_pages/talk_add_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/common/Function.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController _controller;
String _title = "webview";

class FeiyiPage extends StatefulWidget {
  @override
  _FeiyiPageState createState() => _FeiyiPageState();
}
Future<List<ICHTalk>> loadDefaultData()async {
  Map formData={
    'limit':5,
    'page':1
  };
  Map response = await request('/ICHTalk/List',formData: formData,rowData: true);
  List data=response['data'];
  List<ICHTalk> res = new List<ICHTalk>();
  for (int i = 0; i < data.length; i++) {
    ICHTalk e = ICHTalk.fromJson(data[i]);
    await e.loadUser();
    //print(e.userName);
    res.add(e);
  }
  return res;
}
class _FeiyiPageState extends State<FeiyiPage> {
  @override


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        body: Container(
          child: Stack(
            children: [
              FutureBuilder<List<ICHTalk>>(
                  future: loadDefaultData(),
                  builder: (BuildContext context, AsyncSnapshot<List<ICHTalk>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          height: 700,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      case ConnectionState.done:
                        return FeiyiSpeakListView(snapshot.data);
                    }
                  }),

//                  FloatBtn(),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: AddICHBottom(),
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

}



//添加非遗说的按钮
class AddICHBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
//      width: 500,
//      height: MediaQuery.of(context).size.height-MediaQuery.of(context).viewInsets.bottom,
//    color: Colors.amber,
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.only(
        bottom: 20.0,
        right: 20.0,
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TalkAddWidget()));
        },
        child: Icon(
          Icons.add,
          size: 35.0,
        ),
        backgroundColor: Colors.amberAccent,
      ),
    );
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
        onTap: () {
          showSearch(context: context, delegate: SearchBarWidget());
        },
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

class FeiyiSpeakListView extends StatefulWidget {
  List<ICHTalk>defaultData;
  FeiyiSpeakListView(this.defaultData);
  @override
  _FeiyiSpeakListViewState createState() => _FeiyiSpeakListViewState(defaultData);
}

class _FeiyiSpeakListViewState extends State<FeiyiSpeakListView> {
  List<ICHTalk> _ichlist; //数据列表
  int _pageindex; //当前第几页
  int _limit; //每页的数量
  bool isLoading = false; //当前是否在加载
  bool isEnd=false;//是否数据结束了
  ScrollController _scrollController = ScrollController();
  _FeiyiSpeakListViewState(this._ichlist);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageindex = 1;
    _limit = 5;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }
  Future<List<ICHTalk>> getData(int page) async {
    Map formData={
      'limit':_limit,
      'page':_pageindex
    };
    Map response = await request('/ICHTalk/List',formData: formData,rowData: true);

    if((page-1)*_limit>response['count']){
      return null;
    }
    List data=response['data'];
    List<ICHTalk> res = new List<ICHTalk>();
    for (int i = 0; i < data.length; i++) {
      ICHTalk e = ICHTalk.fromJson(data[i]);
      await e.loadUser();
      //print(e.userName);
      res.add(e);
    }
    return res;
  }
  _getMore() async{
    if(!isEnd){
      if(!isLoading){
        setState(() {
          isLoading = true;
          _pageindex++;
        });

        List<ICHTalk> res=await getData(_pageindex);
        if(res==null){
          //显示已经到底了
          Fluttertoast.showToast(
              msg: "已经到底啦",
              timeInSecForIos: 5,
              gravity: ToastGravity.CENTER,
              textColor: Colors.grey);
          setState(() {
            isEnd=true;
            isLoading=false;
          });
        }
        else{
          setState(() {
            _ichlist.addAll(res);
            isLoading=false;
          });
        }

      }
    }


  }

  @override
  void didChangeDependencies() {
    ///在initState之后调 Called when a dependency of this [State] object changes.
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return
      RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              controller: _scrollController,
              itemCount: _ichlist.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < _ichlist.length) {
                  return ICHCard(_ichlist[index]);
                }
                return _getMoreWidget();
              }),
        ),
      );

  }

  Future<Null> _onRefresh() async {
    if(isEnd==true){
      Navigator.of(context).pushNamedAndRemoveUntil("/BottomBarPageBranch2", ModalRoute.withName("/BottomBarPageBranch2"));
    }
    else{
      getData(1).then((value) {
        setState(() {
          _ichlist = value;
          _pageindex=1;
          isEnd=false;
        });
      });
    }

  }

  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...     ',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }
}

//热门非遗说卡面
class ICHCard extends StatelessWidget {
  ICHTalk data;

  ICHCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
//      height: 300.0,
      child: Card(
        color: Color.fromRGBO(247, 244, 233, 1.0),
        elevation: 0.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            //用户头像、名称、时间、浏览
            Container(
//              color: Colors.red,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              child: Row(
                children: [
                  //头像图片
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    height: 40.0,
                    width: 40.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        //'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2907227418,1639643895&fm=26&gp=0.jpg',
                        data.userProfilePicUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  //用户名、时间、浏览
                  Container(
                    child: Column(
                      children: [
                        //用户名
                        Container(
                          width: 200.0,
                          child: Text(
                            //'用户28454',
                            data.userName,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              height: 1.5,
                            ),
                          ),
                        ),
                        //时间+浏览
                        Container(
                          width: 200.0,
                          child: Text(
                            //'今天11:57' + '    浏览19.7w',
                            data.CreateDate + '    浏览19.7w',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(138, 138, 138, 1.0),
                              height: 1.5,
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
                ],
              ),
            ),
            //非遗说文字内容
            Container(
              width: 500,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                //'走在街上突然听到一句熟悉的吆喝声：“打镴喔……补铜 壶修锁喔……”，我一下子被拉回到的几十年前的街头巷 尾，那时候的永康锡雕被',
                data.Content,
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            //图片
            Container(
              child:
              ImagesWidget(data.Photo1Url, data.Photo2Url, data.Photo3Url),
            ),
            //底部按钮
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(''),
                  ),
                  //点赞按钮
                  Container(child: ICHLikeButton(data.LikeCount,data.Id)),
                  //评论按钮
                  Container(
                    child: ICHCommentBottom(data.Id),
                  ),
                  //转发按钮
                  Container(
                    child: ICHForwardBottom(data.Id),
                  ),
                ],
              ),
            ),
            //评论内容
            Container(
              child: CommentListView(data.Id),
            ),
          ],
        ),
      ),
    );
  }
}

Widget ImagesWidget(String url1, String url2, String url3) {
  if (url1 == null || url1 == "") {
    return null;
  } else {
    List<String> data = new List<String>();
    data.add(url1);
    if (url2 != null && url2 != "") {
      data.add(url2);
      if (url3 != null && url3 != "") {
        data.add(url3);
      }
    }
    return ImageGridView(data);
  }
}

//图片
class ImageGridView extends StatefulWidget {
  List<String> data;

  ImageGridView(this.data);

  @override
  _ImageGridViewState createState() => _ImageGridViewState(data);
}

class _ImageGridViewState extends State<ImageGridView> {
  _ImageGridViewState(this.imageList);

  List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: GestureDetector(
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
              ),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    child: Image.network(
                      imageList[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    //FadeRoute是自定义的切换过度动画（渐隐渐现） 如果不需要 可以使用默认的MaterialPageRoute
                    Navigator.of(context).push(new FadeRoute(
                        page: PhotoViewGalleryScreen(
                          images: imageList,
                          // images: List.generate(3, (index) =>imageList[index]['url']), //传入图片list
                          index: index,
                          //传入当前点击的图片的index
                          heroTag: 'img', //传入当前点击的图片的hero tag （可选）
                        )));
                  },
                );
              },
            )));
  }
}

//点赞按钮 变色 +1
class ICHLikeButton extends StatefulWidget {
  int count;
  int talkid;
  ICHLikeButton(this.count,this.talkid);
  @override
  _ICHLikeButtonState createState() => _ICHLikeButtonState(count,talkid);
}

class _ICHLikeButtonState extends State<ICHLikeButton> {
  static final Image heartSolidicon = Image.asset('images/activelike.png');
  static final Image hearticon = Image.asset('images/like.png');
  Image image = _ICHLikeButtonState.hearticon;
  int likeCount = 90;
  int talkid;
  _ICHLikeButtonState(this.likeCount,this.talkid);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(right: 10.0),
      child: Row(
        children: [
          Container(
//            margin: EdgeInsets.only(right: 5.0),
            width: 25.0,
            height: 25.0,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
//              splashColor: Colors.redAccent,
              iconSize: 25.0,
              padding: EdgeInsets.all(0.0),
              icon: image,
              onPressed: () {
                setState(() {
                  if (image == _ICHLikeButtonState.hearticon) {
                    image = _ICHLikeButtonState.heartSolidicon;
                    this.likeCount++;
                    //网络接口
                   request('/ICHTalk/Like?talkid='+talkid.toString(),rowData: true).then((value) {print(value);});
                  } else {
                    image = _ICHLikeButtonState.hearticon;
                    this.likeCount--;
                    //网络点赞接口
                    request('/ICHTalk/CancelLike?talkid='+talkid.toString());
                  }
                });
              },
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
class ICHCommentBottom extends StatefulWidget {
  int talkid;
  ICHCommentBottom(this.talkid);

  @override
  _ICHCommentBottomState createState() => _ICHCommentBottomState(talkid);
}

class _ICHCommentBottomState extends State<ICHCommentBottom> {
  int talkid;

  static final Image _commentImage = Image.asset('images/comment.png');
  int _count = 123;

  _ICHCommentBottomState(this.talkid);

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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentAddWidget(talkid),
                ));
              },
            ),
          ),
          //评论的数量
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              "",
              //_count.toString(),
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
class ICHForwardBottom extends StatefulWidget {
  int talkid;
  ICHForwardBottom(this.talkid);
  @override
  _ICHForwardBottomState createState() => _ICHForwardBottomState(talkid);
}

class _ICHForwardBottomState extends State<ICHForwardBottom> {
  int talkid;
  static final Image _forwardImage = Image.asset('images/share.png');
  int _z = 456;
  _ICHForwardBottomState(this.talkid);
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
              onPressed: () {
                request('/ICHTalk/Forward?talkid='+talkid.toString()+"&userid="+Global.userinfo.Id.toString()).then((value)
                {Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil("/BottomBarPageBranch2", ModalRoute.withName("/BottomBarPageBranch2"));
                } );
                setState(() {
                  Fluttertoast.showToast(
                      msg: "转发成功",
                      timeInSecForIos: 2,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.grey);
                  this._z = _z + 1;
                });
              },
            ),
          ),
          //转发的数量
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: Text(
              "",
              //_z.toString(),
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

//评论列表
class CommentListView extends StatefulWidget {
  int talkId;

  CommentListView(this.talkId);

  @override
  _CommentListViewState createState() => _CommentListViewState(talkId);
}

class _CommentListViewState extends State<CommentListView> {
  int talkId;

  _CommentListViewState(this.talkId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color.fromRGBO(229, 229, 229, 1.0),
                    ))),
          ),
          FutureBuilder<List<ICHTalkComment>>(
            future: getComment(talkId),
            builder: (BuildContext context,
                AsyncSnapshot<List<ICHTalkComment>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                //print(snapshot.data.length);
                  if (snapshot.data.length == 0) {
                    //处理空的评论
                    return Text("还没有评论，快写一个吧！");
                  } else {
                    return Container(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CommentText(snapshot.data[index]);
                        },
                      ),
                    );
                  }
              }
            },
          )
        ],
      ),
    );
  }
}

Future<List<ICHTalkComment>> getComment(int talkid) async {
  List<ICHTalkComment> res = new List<ICHTalkComment>();
  Map response = await request('/ICHTalk/CommentsById',
      formData: {'talkid': talkid}, rowData: true);
  //print(response);
  if (response['code'] == '-3') {
    //print("nodata.............................................................................");
    return res;
  } else {
    // print('hasdata..............................................................................................');
    List data = response['data'];
    //print(data);

    for (int i = 0; i < data.length; i++) {
      ICHTalkComment e = ICHTalkComment.fromJson(data[i]);
      await e.loadUser();
      //print(e.userName);
      res.add(e);
    }
    return res;
  }
}

//评论内容
class CommentText extends StatelessWidget {
  ICHTalkComment data;

  CommentText(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 1.0, 15.0, 1.0),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
//            TextSpan(text: '过儿', style: TextStyle(fontWeight: FontWeight.w600)),
////            TextSpan(text: ': ', style: TextStyle(fontWeight: FontWeight.w600)),
////            TextSpan(text: '看来老兄的年纪已经不小了，我记得得好几十年前了吧。'),
            TextSpan(
                text: data.userName,
                style: TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: ': ', style: TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: data.Content),
          ],
        ),
//        ++,
//        style: TextStyle(
//          fontSize: 13.0,
//          fontWeight: FontWeight.w500
//        ),
      ),
    );
  }
}
