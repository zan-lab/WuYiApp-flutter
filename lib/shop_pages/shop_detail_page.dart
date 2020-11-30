import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/models/Goods.dart';

Goods goods;

class ShopDetailPage extends StatefulWidget {
  int goodsid;
  ShopDetailPage(this.goodsid);

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState(goodsid);
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  int goodsid;
  _ShopDetailPageState(this.goodsid);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
                onPressed: (){},
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                onPressed: (){},
              ),
            ],
          ),
          body:FutureBuilder(
            future: getData(goodsid),
            builder: (BuildContext context,AsyncSnapshot<Goods> snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Container(
                    height: 400,
                    child: Center(child: CircularProgressIndicator(),),
                  );
                case ConnectionState.done:
                  goods=snapshot.data;
                  return ShopDetail();
              }
            },
          )
      ),
    );
  }
}
Future<Goods> getData(int id) async{
  var response=await request('/Shop/Goods',formData: {'id':id});
  //print(response);
  Goods g=Goods.fromJson(response);
  g.catName= await g.getCatname();
  return g;
}
class ShopDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TopImageWidget(),
                  GoodsBaseInfoBlock(),
                  GoodsBriefBlock(),
                ],
              ),
            ),
          ),
          BottomBar(),
        ],
      ),
    );
  }
}

//顶部的图片
class TopImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Image.network(
        goods.PicUrl,
        // 'http://ich.laoluoli.cn/uploads/GoodsPic/20200829/5bfbd62b4deb201c3b994f24ab8a67a2.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

//价格到服务
class GoodsBaseInfoBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
//      height: 100.0,
      child: Column(
        children: <Widget>[
          //￥28
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            width: 400.0,
            child: Text(
              '￥' + goods.Price.toString(),
              // '￥' + '28.00',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(242, 190, 69, 1.0),
              ),
            ),
          ),
          //红糖块以及月销
          Container(
//            height: 100.0,
            width: 500.0,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(0.0),
//                  color: Colors.lightGreen,
                  width: 220,
//                  height: 50,
                  child: Text(
                    goods.Name,
                    //'敲糖帮农家土红糖块',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true,
//                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(''),
                ),
                Container(
                  width: 100,
//                  height: 50,
//                  color: Colors.lightGreen,
                  child: Text(
                    '月销 6852',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color.fromRGBO(138, 138, 138, 1.0),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          //义乌红糖
          Container(
            width: 500,
            child: Text(
              goods.catName,
              //'义乌红糖',
              style: TextStyle(
                fontSize: 19.0,
                color: Color.fromRGBO(138, 138, 138, 1.0),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //下划线
          Container(
            margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
//            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(229, 229, 229, 1.0),
                ),
              ),
            ),
          ),
          //服务
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    '服务',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromRGBO(138, 138, 138, 1.0),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Text(''),
                ),
                Container(
                  child: Text(
                    '因商品特殊性非质量问题不支持7天无理由退换货',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          //下划线
          Container(
            margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
//            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(229, 229, 229, 1.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//产品介绍
class GoodsBriefBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          //产品介绍
          Container(
            width: 500.0,
            child: Text(
              '产品介绍',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          //内容
          Container(
            child: Text(
              goods.Brief,
              //'义乌“红糖之乡”的名声传扬已久。红糖又名义乌青，早在1929年的西湖博览会上就被授予了特别奖。为义乌著名的大宗土产品。',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

//底部按钮
class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      height: 70.0,
//      color: Colors.black12,
      child: Row(
        children: <Widget>[
          //客服
          Container(
            margin: EdgeInsets.only(left: 15.0),
            width: 50.0,
            height: 55.0,
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Container(
//                  width:40.0,
//                  height: 40.0,
                    child: Image.asset(
                      'images/advisory.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text('客服'),
                ],
              ),
              onPressed: () {},
            ),
          ),
          //收藏
          CollectBottomBar(),
          //加入购物车
          Container(
            margin: EdgeInsets.only(left: 10.0),
            height: 50.0,
            child: RaisedButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
                side: BorderSide(width: 1.0, color: Color.fromRGBO(160, 160, 160, 1.0),),
              ),
              color: Colors.white,
              child: Text('加入购物车',style: TextStyle(fontSize: 20.0),),
              onPressed: (){
                Map _formData={
                  'userid':Global.userinfo.Id,
                  'goodsid':goods.Id,
                };
                request('/Shop/AddCart',formData: _formData);
                Fluttertoast.showToast(
                    msg: "已加入购物车",
                    timeInSecForIos: 2,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey);
              },
            ),
          ),
          //立即购买
          Container(
            margin: EdgeInsets.only(left: 10.0),
            height: 50.0,
            child: RaisedButton(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
//                side: BorderSide(width: 1.0, color: Color.fromRGBO(160, 160, 160, 1.0),),
              ),
              color: Color.fromRGBO(242, 190, 69, 1.0),
              child: Text('立即购买',style: TextStyle(fontSize: 20.0,color: Colors.white),),
              onPressed: (){
                Map _formData={
                  'userid':Global.userinfo.Id,
                  'goodsid':goods.Id,
                };
                request('/Shop/Buy',formData: _formData);
                Fluttertoast.showToast(
                    msg: "购买成功",
                    timeInSecForIos: 2,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.grey);
              },
            ),
          ),
        ],
      ),
    );
  }
}

//收藏按钮点击变红
class CollectBottomBar extends StatefulWidget {
  @override
  _CollectBottomBarState createState() => _CollectBottomBarState();
}

class _CollectBottomBarState extends State<CollectBottomBar> {
  static final Image _CollectImage = Image.asset('images/collect.png');
  static final Image _activeCollectImage =
  Image.asset('images/activecollect.png');
  Image image = _CollectBottomBarState._CollectImage;
  String text = '收藏';
  String activeText = '已收藏';
  String _s = '收藏';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      width: 50.0,
      height: 55.0,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            image,
            Text(_s),
          ],
        ),
        onPressed: () {
          setState(() {
            if (image == _CollectBottomBarState._CollectImage) {
              image = _CollectBottomBarState._activeCollectImage;
              _s = activeText;
            } else {
              image = _CollectBottomBarState._CollectImage;
              _s = text;
            }
          });
        },
      ),
    );
  }
}