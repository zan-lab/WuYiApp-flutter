import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ich/article_pages/ArticleDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';

//搜索提示
//List searchList = <String>['黄大仙', '金华火腿', '诸葛古村', '金华婺剧', '赶茶场', '永康锡雕', '东阳木雕', '浦江剪纸',];
//显示在搜索界面下面的那两列（可扩展为历史记录）
List<String> defaultValue = [
  '黄大仙',
  '金华火腿',
  '诸葛古村',
  '金华婺剧',
  '赶茶场',
  '永康锡雕',
  '东阳木雕',
  '浦江剪纸',
];
List<int> idlist = [
  18,
  6,
  7,
  2,
  20,
  9,
  27,
  29,
];

//使用SearchDelegate组件
class SearchBarWidget extends SearchDelegate {
  //通过异步来获取api地址
  Future<String> querylj(String query1) async {
    //定义地址
    //使用get方法需要将获取的将申请名字填上，如'?keyword='+data
    //使用post方法只需要把api地址放出来，然后使用post(url,data: {'keyword': 'query1'})
    var url = 'https://api.oioweb.cn/api/ljfl.php?keyword=' + query1;
    Response res = await Dio().get(url);
    print(res);
    var data = res.data['newslist'][0]['title'];
    return data;
  }

  Widget getData(context) {
    for (int i = 0; i < datalist.length; i++) {
      if (query == datalist[i]['name']) {
        print(query);
        return RaisedButton(
          child: Text('lll'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ArticleDetailPage(datalist[i]['id'], '')));
          },
        );
      } else {
//        return Text('暂无查询内容...');
        RaisedButton(
          child: Text('lll'),
        );
      }
    }
  }

  //复写点击搜索框右侧图标方法,此方法也就是点击右侧图标的回调函数,点击右侧图标把搜索内容情空
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear,color: Colors.black,),
        //点击后清楚搜索框内容
        onPressed: () => query = '',
      ),
    ];
  }

  //点击搜索框左侧的图标,放的是返回按钮
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0.0),
      // ignore: missing_required_param
      icon: IconButton(
        icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
      ),
      onPressed: () => close(context, null),
    );
  }

  //点击了搜索显示的页面
  @override
  Widget buildResults(BuildContext context) {
    var a = 1;
    return Container(
//      height: 65,
      width: double.infinity,
      padding: EdgeInsets.only(left: 20.0),
      alignment: Alignment.centerLeft,
      color: Colors.white12,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 500,
            child: GestureDetector(
                child: Container(
                  height: 60,
                  width: 500,
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      Container(width: 13,),
                      Expanded(
                        child: Text(
                          query,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  String text;
                  text = query;
                  bool sucFlag = false;
                  for (int i = 0; i < datalist.length; i++) {
                    if (datalist[i]['Name'] == text) {
                      sucFlag = true;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(datalist[i]['Id'], '')));
                      break;
                    }
                  }
                  if (!sucFlag) {
                    Fluttertoast.showToast(
                        msg: "暂无搜索内容",
                        timeInSecForIos: 2,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.grey);
                  }
                }),
          ),
          Divider(),
        ],
      ),
    );
  }

  //提示性文字
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 500,
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              '大家都在搜',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: defaultValue.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      defaultValue[index],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailPage(idlist[index], '')));
                    },
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

List<Map> datalist = [
  {"Id": 1, "Name": "浦江乱弹"},
  {"Id": 2, "Name": "金华婺剧"},
  {"Id": 3, "Name": "醒感戏"},
  {"Id": 4, "Name": "金华酒传统酿造技艺"},
  {"Id": 5, "Name": "婺州举岩茶制作技艺"},
  {"Id": 6, "Name": "金华火腿腌制技艺"},
  {"Id": 7, "Name": "诸葛古村落营造技艺"},
  {"Id": 8, "Name": "东阳卢宅建筑技艺"},
  {"Id": 9, "Name": "永康锡雕"},
  {"Id": 10, "Name": "浦江郑义门营造技艺"},
  {"Id": 11, "Name": "武义俞源古建筑群营造技艺"},
  {"Id": 12, "Name": "婺州窑陶瓷烧制技艺"},
  {"Id": 13, "Name": "义乌红糖制作技艺"},
  {"Id": 14, "Name": "兰溪摊簧"},
  {"Id": 15, "Name": "金华道情"},
  {"Id": 16, "Name": "义乌道情"},
  {"Id": 17, "Name": "永康鼓词"},
  {"Id": 18, "Name": "黄大仙"},
  {"Id": 19, "Name": "浦江迎会"},
  {"Id": 20, "Name": "赶茶场"},
  {"Id": 21, "Name": "永康方岩庙会"},
  {"Id": 22, "Name": "诸葛后裔祭祖"},
  {"Id": 23, "Name": "浦江板凳龙"},
  {"Id": 24, "Name": "兰溪断头龙"},
  {"Id": 25, "Name": "永康十八蝴蝶"},
  {"Id": 26, "Name": "永康九狮图"},
  {"Id": 27, "Name": "东阳木雕"},
  {"Id": 28, "Name": "东阳竹编"},
  {"Id": 29, "Name": "浦江剪纸"},
  {"Id": 30, "Name": "浦江麦秆剪贴"},
  {"Id": 31, "Name": "东阳翻九楼"},
  {"Id": 32, "Name": "武义寿仙谷中药文化"}
];
