import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/mine_pages/info.dart';
import 'package:ich/models/ShoppingOrder.dart';
import 'package:ich/shop_pages/shop_detail_page.dart';

class MyOrderinfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        centerTitle: true,
        title: Text(
          "我的订单",
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
        )),
      ),
      body: BodyWidget(),
    );
  }
}

Future<List<ShoppingOrder>> getData() async {
  List response = await request('/Shop/UserOrder',
      formData: {'userid': Global.userinfo.Id}, rowData: false);
  List<ShoppingOrder> res = new List<ShoppingOrder>();
  for (int i = 0; i < response.length; i++) {
    ShoppingOrder e = ShoppingOrder.fromJson(response[i]);
    await e.loadGoods();
    res.add(e);
  }
  return res;
}

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  Widget ordertext() {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 270,bottom: 20),
              child: Icon(Icons.library_books,size: 40,),
            ),
            Text("您还没有订单^-^", style: TextStyle(fontSize: 30),),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(255, 255, 255, 1.0),
        child: FutureBuilder<List<ShoppingOrder>>(
          future: getData(),
          // ignore: missing_return
          builder: (BuildContext context,
              AsyncSnapshot<List<ShoppingOrder>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
              case ConnectionState.none:
                return Container(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case ConnectionState.done:
              //if(snapshot.data==null)return Center(child: CircularProgressIndicator(),);
                print(snapshot.data);
                if (snapshot.data == null) {
                  return ordertext();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(snapshot.data.length);
                      return MyOrderinfo(snapshot.data[index]);
                    },
                  );
                }
            }
          },
        ));
  }
}

//d订单的UI界面
class MyOrderinfo extends StatefulWidget {
  ShoppingOrder data;

  MyOrderinfo(this.data);

  @override
  _MyOrderinfoState createState() => _MyOrderinfoState(data);
}

class _MyOrderinfoState extends State<MyOrderinfo> {
  ShoppingOrder data;

  _MyOrderinfoState(this.data);

  @override
  Widget build(BuildContext context) {
    print(data.goodsName);
    print(data.GoodsId);
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemExtent: null,
        itemCount: data.Count,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 430,
            height: 200,
            alignment: Alignment.center,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                print(data.GoodsId);
                print(data.Count);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShopDetailPage(data.GoodsId)));
              },
              child: Card(
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  //z轴的高度，设置card的阴影
                  elevation: 0.0,
                  //设置shape，这里设置成了R角
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: false,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(children: <Widget>[
                          Expanded(
                            child: Container(
                              width: 230,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "订单编号: ",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text("1258852-"),
                                  ),
                                  Container(
                                    //child: Text("1"),
                                    child: Text(data.Id.toString()),
                                  ),
                                ],
                              ),
                            ),
                          ), //订单编号
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(top: 13),
                              child: Text(
                                "已完成",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.green),
                              ),
                            ),
                          ), //已完成
                        ]),
                        margin: EdgeInsets.only(top: 10, left: 40, right: 50),
                      ),
                      Expanded(
                        child: Container(
                            margin:
                            EdgeInsets.only(top: 10, left: 40, right: 50),
                            child: FlatButton(
                              splashColor: Colors.white,
                              highlightColor: Colors.white,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  side: BorderSide(
                                      color: Colors.black12,
                                      style: BorderStyle.solid,
                                      width: 1)),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          width: 10,
                                          margin: EdgeInsets.only(right: 20),
                                          child: IconButton(
                                            color: Colors.black,
                                            icon: Icon(Icons.card_giftcard),
                                            alignment: Alignment.centerRight,
                                          )),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          //"名字",
                                          data.goodsName,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        child:Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child:Text(
                                             "已送达",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                decoration:
                                                TextDecoration.underline,
                                                fontSize: 13,
                                                color: Colors.green),
                                          ),
                                        ),

                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: 130,
                                          height: 80,
                                          child: Image.network(
                                            //"http://ich.laoluoli.cn/uploads/GoodsPic/20200829/de9fd45d1fe59a5548a53ecef2b23806.jpg"
                                              data.goodsPicUrl),
                                          //data.goodsPicUrl,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text(
                                                "共1件",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.black26),
                                              ),
                                              width: 120,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 20),
                                              width: 150,
                                              alignment: Alignment.centerRight,
                                              child: FlatButton(
                                                splashColor: Colors.white,
                                                highlightColor: Colors.white,
                                                color: Colors.white,
                                                padding: EdgeInsets.all(10.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        30),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        style:
                                                        BorderStyle.solid,
                                                        width: 1)),
                                                child: Text(
                                                  "查看详情",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black),
                                                ),
                                                textColor: Colors.black,
                                                onPressed: () {
                                                  print(data.GoodsId);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ShopDetailPage(
                                                                  data
                                                                      .GoodsId)));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  )
                //getUserCard(),
              ),
            ),
          );
        },
      ),
    );
  }
}
