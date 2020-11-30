import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/models/Goods.dart';
import 'package:ich/shop_pages/shop_detail_page.dart';

//右边的布局的对象
ShoppingWidget _right;

class ShopIndexPage extends StatefulWidget {
  @override
  _ShopIndexPageState createState() => _ShopIndexPageState();
}

class _ShopIndexPageState extends State<ShopIndexPage> {
  @override
  void initState() {
    //输出menu1...20
    //_menuStr = new List<String>.generate(4, (i) => "menu $i");
    //_menuStr = new List<String>();
    //getCat();
    super.initState();
  }

  Future<List> getCat() async {
    List<String> res = new List<String>();
    var data = await request('/Shop/CatList');
    //print(data is List);
    for (int i = 0; i < data.length; i++) {
      res.add(data[i]['Name']);
    }
    ;
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 202, 0, 1.0),
        leading: Container(
          alignment: Alignment.center,
          child: Text(
            '商城',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List>(
          future: getCat(),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                return Row(
                  children: <Widget>[
                    ShoppingCat(snapshot.data),
                    _right = ShoppingWidget(snapshot.data[0]),
                  ],
                );
            }
          }),
    );
  }

  Widget loadCatList() {}
}

class ShoppingCat extends StatefulWidget {
  List<String> _menuStr = [];

  ShoppingCat(this._menuStr);

  @override
  _ShoppingCatState createState() => _ShoppingCatState(_menuStr);
}

class _ShoppingCatState extends State<ShoppingCat> {
  //设置宽高
  final _menuHeight = 80.0;
  final _menuWidth = 80.0;

  List<String> _menuStr = [];
  int _selectedIdx = 0;

  _ShoppingCatState(this._menuStr);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _menuWidth,
      child: ListView.builder(
        itemCount: _menuStr.length,
        itemBuilder: (context, index) {
          String str = _menuStr[index];
          return GestureDetector(
            onTap: () {
              _right.catname = _menuStr[index];
              _right.changeCat();
              setState(() {
                _selectedIdx = index;
              });
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: _menuHeight,
                  color: (_selectedIdx == index)
                      ? Color.fromRGBO(235, 235, 220, 0.5)
                      : Colors.white,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text(str),
                        ),
                      ),
                      Container(
                        width: _menuWidth,
                        height: 2,
                        color: (_selectedIdx == index)
                            ? Color.fromRGBO(255, 202, 0, 1.0)
                            : Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Color.fromRGBO(238, 238, 238, 1.0),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ShoppingWidget extends StatefulWidget {
  String catname;

  ShoppingWidget(this.catname);

  _ShoppingWidgetState _shoppingWidgetState;

  void changeCat() {
    this._shoppingWidgetState.reloadCat(catname);
  }

  @override
  _ShoppingWidgetState createState() =>
      _shoppingWidgetState = _ShoppingWidgetState(catname);
}

class _ShoppingWidgetState extends State<ShoppingWidget> {
  String catname;

  _ShoppingWidgetState(this.catname);

  void reloadCat(String newcatname) {
    setState(() {
      this.catname = newcatname;
    });
  }

  Future<List<Goods>> getData(String catname) async {
    List data =
        await request('/Shop/GoodsByCatname', formData: {'catname': catname});
    //print(data[0]);
    List<Goods> res = new List<Goods>();
    for (int i = 0; i < data.length; i++) {
      res.add(Goods.fromJson(data[i]));
    }
    // print(res.elementAt(0).Id);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color.fromRGBO(252, 250, 245, 1.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 10.0),
              alignment: Alignment.centerLeft,
              child: Text(
                catname,
                //为你推荐',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FutureBuilder<List<Goods>>(
              future: getData(catname),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Goods>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.none:
                    return Container(
                        height: 400,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ));
                  case ConnectionState.done:
                    return GoodsList(snapshot.data);
//                    return Container(
//                      child: Center(
//                        child: CircularProgressIndicator(),
//                      ),
//                      height: 400,
//                    );
                }
              },
            ),
            //GoodsList(),
          ],
        ),
//              child: Center(
//                child: RecommentWidget(),
//                Text(
//                  _menuStr[_selectedIdx],
//                  style: TextStyle(color: Colors.white),
//                ),
//              ),
      ),
    );
  }

//  Widget getContent() {
//    return Expanded(
//      child: ListView(shrinkWrap: true, primary: false, children: [
//        Container(
//          child: Column(
//            children: [
//              Container(
////            height: 300.0,
//                child: GridView.count(
//                  childAspectRatio: 4 / 5,
//                  shrinkWrap: true,
//                  physics: NeverScrollableScrollPhysics(),
////              primary: false,
//                  crossAxisCount: 2,
//                  children: [GoodsWidget(), GoodsWidget()],
//                ),
//              ),
//            ],
//          ),
//        )
//      ]),
//    );
//  }
}

class GoodsList extends StatefulWidget {
  List<Goods> data;

  GoodsList(this.data);

  @override
  _GoodsListState createState() => _GoodsListState(data);
}

class _GoodsListState extends State<GoodsList> {
  List<Goods> data;

  _GoodsListState(this.data);

  @override
  Widget build(BuildContext context) {
    //print(data.length);
    return Expanded(
      child: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
        Container(
          child: Column(
            children: [
              Container(
//            height: 300.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 4 / 5,
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
//              primary: false,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GoodsWidget(data[index]);
                  },
                  //children: [GoodsWidget(), GoodsWidget()],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class GoodsWidget extends StatelessWidget {
  Goods goods;

  GoodsWidget(this.goods);

  @override
  Widget build(BuildContext context) {
    //print(goods.Price);
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 10.0),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                width: double.infinity,
                height: 110.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.network(
                    //'http://ich.laoluoli.cn/uploads/GoodsPic/20200829/bfd62a06811cf3900b6e134d57d6eee9.jpg',
                    goods.PicUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                height: 40.0,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 15.0,
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                          padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0.0),
//                        width: 200.0,
                  child: Text(
                    goods.Name,
//                    '婺剧门票sdfhjdskgkfdkgfdjgndjg',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0,top: 10.0),
                      child: Text(
                        '￥' + goods.Price.toString(),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.redAccent,
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShopDetailPage(goods.Id),));
          },
        ));
  }
}
