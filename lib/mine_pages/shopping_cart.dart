import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/common/Global.dart';
import 'package:ich/common/acecheckbox.dart';
import 'package:ich/mine_pages/shopping_button.dart';
import 'package:ich/models/ShoppingCart.dart';
import 'package:ich/style_pages/textstyle.dart';

class ShoppingCartPage extends StatefulWidget {
  int test;
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

Widget cartNullText() {
  return Container(
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 300),
          child: Icon(
            Icons.add_shopping_cart,
            size: 30,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 300),
          child: Text(
            "您的购物车居然是空的^_^",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ],
    ),
  );
}
class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShoppingCart>>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<List<ShoppingCart>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Scaffold(
              backgroundColor: Color.fromRGBO(252, 250, 245, 1.0),
              appBar: new AppBar(
                elevation: 0,
                titleSpacing: 0.0,
                title: new Text(
                  '我的购物车',
                  textAlign: TextAlign.left,
                  style: buildAppBarTexStyle(),
                ),
                leading: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: "编辑",
                    onPressed: () {},
                  ),
                ],
                backgroundColor: Color.fromRGBO(255, 202, 0, 1.0),
              ),
              body: Container(
                height: 200,
                child: Center(child: CircularProgressIndicator(),),
              ),
            );
          case ConnectionState.done:
            //if(snapshot.data.length==0)return cartNullText();
            return CartCount(snapshot.data);
        }
      },
    );
  }

}

class CartCount extends StatefulWidget {
  List<ShoppingCart> data;
  CartCount(this.data);
  @override
  _CartCountState createState() => _CartCountState(data);
}

Future<List<ShoppingCart>> getData() async {
  List<ShoppingCart> res = new List<ShoppingCart>();
  List response = await request('/Shop/UserCart?userid=' + Global.userinfo.Id.toString());
  for (int i = 0; i < response.length; i++) {
    ShoppingCart s = ShoppingCart.fromJson(response[i]);
    await s.loadGoods();
    res.add(s);
  }
  return res;
}

class _CartCountState extends State<CartCount> {
  _CartCountState(this._list);
  final Widget _delText = Text("删除");
  final Widget _payText = Text("结算");
  Widget multiAction;
  List<ShoppingCart> _list = []; //列表
  List<int> deleteIds = []; //要删除的ID数组
  bool _isOff = false; //相关组件显示隐藏控制，true代表隐藏
  bool _checkValue = false; //总的复选框控制开关

  //先初始化一些数据，当然这些数据实际中会调用接口的
  @override
  void initState() {
    multiAction = _payText;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(252, 250, 245, 1.0),
      appBar: new AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        title: new Text(
          '我的购物车',
          textAlign: TextAlign.left,
          style: buildAppBarTexStyle(),
        ),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "编辑",
            onPressed: () {
              this.deleteIds = []; //重置选中的ID数组
              setState(() {
                //this._isOff = !this._isOff; //显示隐藏总开关
                this._checkValue = false; //所有复选框设置为未选中
                if (multiAction == this._delText) {
                  //取消编辑
                  multiAction = _payText;
                } else {
                  //进入删除的编辑模式
                  multiAction = _delText;
                }
              });
            },
          ),
        ],
        backgroundColor: Color.fromRGBO(255, 202, 0, 1.0),
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: getItemContent(),
                flex: 1,
              ),
              getItem(),
//          Positioned(
//            left: 0,
//            right: 0,
//            bottom: 0,
//            child: getItem(),
//          ),
            ],
          )),
    );
  }

  //空购物车样式


// 减少按钮
  Widget getItem() {
    if (_list==null) {
      return Container(
        child: cartNullText(),
      );
    } else {
      return Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
//            getItemContent(), //这里是列表的内容
            getItemBottom(), //这里是底部删除全选操作的内容
          ],
        ),
      );
    }
  }

  //底部操作样式
  Widget getItemBottom() {
    return Offstage(
      offstage: _isOff,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Container(
//          height: 80,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ACECheckbox(
                      activeColor: Color.fromRGBO(255, 202, 0, 1.0),
                      // 激活时的背景颜色
                      checkColor: Colors.white,
                      // 指针色，
                      unCheckColor: Colors.black26,
                      value: _checkValue,
                      onChanged: (value) {
                        selectAll(value);
                      },
                      type: ACECheckBoxType.circle,
                    ),
                    Text('全选'),
                  ],
                ),
                Container(
                  width: 70,
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: new Material(
                    child: Ink(
                      //用ink圆角矩形
                      // color: Colors.red,
                      decoration: new BoxDecoration(
                        //不能同时”使用Ink的变量color属性以及decoration属性，两个只能存在一个
                        color: Color.fromRGBO(255, 202, 0, 1.0),
                        //设置圆角
                        borderRadius:
                        new BorderRadius.all(new Radius.circular(25.0)),
                      ),
                      child: Center(
                        // 设置背景颜色 默认矩形
                        child: InkWell(
                          //圆角设置,给水波纹也设置同样的圆角
                          //如果这里不设置就会出现矩形的水波纹效果
                          borderRadius: new BorderRadius.circular(25.0),
                          //设置点击事件回调
                          child: multiAction,
                          onTap: () {
                            if (multiAction == _delText) {
                              deletelist();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  //底部复选框的操作逻辑
  selectAll(value) {
    //print(value);
    this.deleteIds = []; //要删除的数组ID重置
    setState(() {
      _checkValue = value;
      _list = _list;
    });
  }

  void deletelist() {
    deleteIds.forEach((element) {
      request('/Shop/DeleteCart?id=' + element.toString());
    });
    List<ShoppingCart> deleteItem = new List<ShoppingCart>();
    _list.forEach((e) {
      if (deleteIds.contains(e.Id)) {
        deleteItem.add(e);
      }
    });
    deleteItem.forEach((element) {
      setState(() {
        _list.remove(element);
      });
    });
    print(_list);
  }

  //列表
  Widget getItemContent() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _createGridViewItem(_list[index]);
      },
      itemCount: (_list == null) ? 0 : _list.length,
    );
  }

  //单个crad,这里可以自己定义一些样式
  Widget _createGridViewItem(ShoppingCart item) {
    Color color = Colors.white;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
      child: Container(
        height: 165,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Offstage(
                offstage: _isOff,
                child: ACECheckbox(
                  activeColor: Color.fromRGBO(255, 202, 0, 1.0),
                  // 激活时的背景颜色
                  checkColor: Colors.white,
                  // 指针色，
                  unCheckColor: Colors.black26,
                  type: ACECheckBoxType.circle,
                  value: false,
                  onChanged: (value) {
                    if (value == false) {
                      this.deleteIds.remove(item.Id);
                    } else {
                      this.deleteIds.add(item.Id);
                    }
                    setState(() {
                      //item['select'] = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              width: 350,
              child: CartBody(item),
            ),
          ],
        ),
      ),
    );
  }
}

class CartBody extends StatelessWidget {
  ShoppingCart data;

  CartBody(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 165,
      child: Card(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          //z轴的高度，设置card的阴影
          elevation: 0.0,
          //设置shape，这里设置成了R角
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
          clipBehavior: Clip.antiAlias,
          semanticContainer: false,
          child: new Row(
            children: <Widget>[
//              Container(
//                child: SwitchACECheckBoxTestRoute(),
//                margin: EdgeInsets.only(left: 13),
//                width: 10,
//              ),
              Container(
                margin: EdgeInsets.only(left: 0),
                child: Image.network(
                  //"http://ich.laoluoli.cn/uploads/GoodsPic/20200829/de9fd45d1fe59a5548a53ecef2b23806.jpg",
                  data.goods.PicUrl,
                  //scale:1.0,
                  fit: BoxFit.contain, //当外部容器设置了尺寸，这个有必要设置
                ),
                height: 80,
                width: 130,
              ),
              Column(children: <Widget>[
                Container(
                  width: 200,
                  padding: EdgeInsets.only(top: 35, left: 10),
                  child: Text(
                    //"文创商品名字",
                    data.goods.Name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text(
                    "库存1390件",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black26,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          child: Text(
                            //"￥98",
                            "￥"+data.goods.Price.toString(),
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                          margin: EdgeInsets.only(top: 10, left: 30),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: NumberControllerWidget(
                            numText: data.Count.toString(),
                            addValueChanged:(value){changeNum(value);},
                            removeValueChanged:(value){changeNum(value);},
                            textEditChanged:(value){changeNum(value);},
                          ),
                          margin: EdgeInsets.only(left: 30, top: 20),
                        ),
                      ),

                    ],
                  ),
                ),
              ]),
            ],
          )
//getUserCard(),
      ),
    );

  }

  void changeNum(int value){
    //显示toast
    Fluttertoast.showToast(
        msg: "修改成功",
        timeInSecForIos: 2,
        gravity: ToastGravity.CENTER,
        textColor: Colors.grey
    );
    changeNumUpload(value);
  }
  Future changeNumUpload(int value)async{
    Map formData={
      'id':data.Id,
      'newcount':value
    };
    request('/Shop/CartChangeCount',formData: formData);
  }
}
