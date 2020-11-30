import 'package:flutter/material.dart';
import 'package:ich/article_pages/ArticleDetail.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/models/ICH.dart';

//class SortPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Scaffold(
//        appBar: AppBar(
//          title: Text('Sort'),
//        ),
//        body: ArticleDetailPage(1,'kdsjf'),
//
//      ),
//    );
//  }
//}

//右边的布局的对象
CatICHWidget _right;

class SortPage extends StatefulWidget {
  @override
  _SortPageState createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
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
    var data = await request('/ICH/CatList');
    print(res);
    for (int i = 0; i < data.length; i++) {
      res.add(data[i]['Name']);
    }
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
              '分类',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        //title: Text('分类'),
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
                    ICHCat(snapshot.data),
                    _right = CatICHWidget(snapshot.data[0]),
                  ],
                );
            }
          }),
    );
  }

  Widget loadCatList() {}
}

class ICHCat extends StatefulWidget {
  List<String> _menuStr = [];

  ICHCat(this._menuStr);

  @override
  _ICHCatState createState() => _ICHCatState(_menuStr);
}

class _ICHCatState extends State<ICHCat> {
  //设置宽高
  final _menuHeight = 80.0;
  final _menuWidth = 80.0;

  List<String> _menuStr = [];
  int _selectedIdx = 0;

  _ICHCatState(this._menuStr);

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

class CatICHWidget extends StatefulWidget {
  String catname;

  CatICHWidget(this.catname);

  _CatICHWidgetState _shoppingWidgetState;

  void changeCat() {
    this._shoppingWidgetState.reloadCat(catname);
  }

  @override
  _CatICHWidgetState createState() =>
      _shoppingWidgetState = _CatICHWidgetState(catname);
}

class _CatICHWidgetState extends State<CatICHWidget> {
  String catname;

  _CatICHWidgetState(this.catname);

  void reloadCat(String newcatname) {
    setState(() {
      this.catname = newcatname;
    });
  }

  Future<List<ICH>> getData(String catname) async {
    List data =
    await request('/ICH/ListByCatname', formData: {'catname': catname});
    //print(data[0]);
    List<ICH> res = new List<ICH>();
    for (int i = 0; i < data.length; i++) {
      res.add(ICH.fromJson(data[i]));
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
            FutureBuilder<List<ICH>>(
              future: getData(catname),
              builder:
                  (BuildContext context, AsyncSnapshot<List<ICH>> snapshot) {
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
                    return ICHList(snapshot.data);
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


}

class ICHList extends StatefulWidget {
  List<ICH> data;

  ICHList(this.data);

  @override
  _ICHListState createState() => _ICHListState(data);
}

class _ICHListState extends State<ICHList> {
  List<ICH> data;

  _ICHListState(this.data);

  @override
  Widget build(BuildContext context) {
    //print(data.length);
    return Expanded(
      child: ListView(shrinkWrap: true, primary: false, children: [
        Container(
          child: Column(
            children: [
              Container(
//            height: 300.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 9/10,
                    crossAxisCount: 2,
                  ),

                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
//              primary: false,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ICHWidget(data[index]);
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

class ICHWidget extends StatelessWidget {
  ICH ich;

  ICHWidget(this.ich);

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
                    ich.PicUrl,
                    fit: BoxFit.cover,
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
                  ich.Name,
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

            ],
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ArticleDetailPage(ich.Id,'')));
          },
        ));
  }
}