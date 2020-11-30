import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ich/common/Function.dart';
import 'package:ich/models/ICHArticle.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleDetailPage extends StatefulWidget {
  int articleid;
  String title;

  ArticleDetailPage(this.articleid, this.title);

  @override
  _ArticleDetailPageState createState() =>
      new _ArticleDetailPageState(articleid, title);
}

const htmlData2 = """
  <p>&nbsp;　　浦江乱弹是一个古老的传统戏曲剧种，流行于浙江浦江、临安、建德、桐庐一带和婺、衢、处、温、台以及江西等地，影响遍及浙中、浙南、浙西和江西、福建的大部分地区，是浙江婺剧的主要声腔之一。因为它发源于浦江，故称浦江乱弹。</p><p>&nbsp;　　浦江乱弹是以浦江当地民歌“菜篮曲”为基础，并在“诸宫调”讲唱艺术和我国最早的戏剧南戏的相互影响下形成和发展起来的。菜篮曲又名踏歌，曲调自由，歌词不一，顺口溜唱，一歌一和，各适其适，亦称“天下和”，主要用于婚丧礼仪和祭神等活动，宋代已盛行于浦江民间，成为脍炙人口的乐曲。如今在浦江农村，农民们挑担行路、上山下山时随口哼出来的浦江乱弹，依稀还有当年踏歌的痕迹。
</p>
""";
const htmlData = """
<h1>Header 1</h1>
<h2>Header 2</h2>
<h3>Header 3</h3>
<h4>Header 4</h4>
<h5>Header 5</h5>
<h6>Header 6</h6>
<h3>Ruby Support:</h3>
      <p>
        <ruby>
          漢<rt>かん</rt>
          字<rt>じ</rt>
        </ruby>
        &nbsp;is Japanese Kanji.
      </p>
      <h3>Support for <code>sub</code>/<code>sup</code></h3>
      Solve for <var>x<sub>n</sub></var>: log<sub>2</sub>(<var>x</var><sup>2</sup>+<var>n</var>) = 9<sup>3</sup>
      <p>One of the most <span>common</span> equations in all of physics is <br /><var>E</var>=<var>m</var><var>c</var><sup>2</sup>.</p>
      <h3>Table support (with custom styling!):</h3>
      <p>
      <q>Famous quote...</q>
      </p>
      <table>
      <colgroup>
        <col width="50%" />
        <col width="25%" />
        <col width="25%" />
      </colgroup>
      <thead>
      <tr><th>One</th><th>Two</th><th>Three</th></tr>
      </thead>
      <tbody>
      <tr>
        <td>Data</td><td>Data</td><td>Data</td>
      </tr>
      <tr>
        <td>Data</td><td>Data</td><td>Data</td>
      </tr>
      </tbody>
      <tfoot>
      <tr><td>fData</td><td>fData</td><td>fData</td></tr>
      </tfoot>
      </table>
      <h3>Custom Element Support:</h3>
      <flutter></flutter>
      <flutter horizontal></flutter>
      <h3>SVG support:</h3>
      <svg id='svg1' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>
            <circle r="32" cx="35" cy="65" fill="#F00" opacity="0.5"/>
            <circle r="32" cx="65" cy="65" fill="#0F0" opacity="0.5"/>
            <circle r="32" cx="50" cy="35" fill="#00F" opacity="0.5"/>
      </svg>
      <h3>List support:</h3>
      <ol>
            <li>This</li>
            <li><p>is</p></li>
            <li>an</li>
            <li>
            ordered
            <ul>
            <li>With<br /><br />...</li>
            <li>a</li>
            <li>nested</li>
            <li>unordered
            <ol>
            <li>With a nested</li>
            <li>ordered list.</li>
            </ol>
            </li>
            <li>list</li>
            </ul>
            </li>
            <li>list! Lorem ipsum dolor sit amet.</li>
            <li><h2>Header 2</h2></li>
            <h2><li>Header 2</li></h2>
      </ol>
      <h3>Link support:</h3>
      <p>
        Linking to <a href='https://github.com'>websites</a> has never been easier.
      </p>
      <h3>Image support:</h3>
      <p>
        <img alt='Google' src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png' />
        <a href='https://google.com'><img alt='Google' src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png' /></a>
        <img alt='Alt Text of an intentionally broken image' src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30d' />
      </p>
      <!--
      <h3>Video support:</h3>
      <video controls>
        <source src="https://www.w3schools.com/html/mov_bbb.mp4" />
      </video>
      <h3>Audio support:</h3>
      <audio controls>
        <source src="https://www.w3schools.com/html/horse.mp3" />
      </audio>
      <h3>IFrame support:</h3>
      <iframe src="https://google.com"></iframe>
      -->
""";

//获取除了文章标题以外得数据
Future<ICHArticle> loadData(int id) async {
  var res = await request('/ICH/ArticleByIchId', formData: {'ichid': id});
  //print(res);
  ICHArticle article = ICHArticle.fromJson(res[0]);
  return article;
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  int articleid;
  String title;

  _ArticleDetailPageState(this.articleid, this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
//      backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          elevation: 0.0,
          //title: Text('非遗名称'),
//          title: Text(title),
//          centerTitle: true,
        backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
            onPressed: (){
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
        body: FutureBuilder<ICHArticle>(
              future: loadData(this.articleid),
              // ignore: missing_return
              builder: (BuildContext context, AsyncSnapshot<ICHArticle> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      height: 400,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.done:
        //              return Container(
        //                height: 400,
        //                child: Center(child: CircularProgressIndicator(),),
        //              );
                    return ArticleWidget(snapshot.data);
                }
              },
            ));
  }
}

class ArticleWidget extends StatelessWidget {
  ICHArticle article;


  ArticleWidget(this.article);
  void getTitle(){
//    int titlelength = article.Title.indexOf('：');


  }

  @override
  Widget build(BuildContext context) {
    final int subtitlelength = article.Title.indexOf('——');
    final int titlelength = article.Title.lastIndexOf('——');
    final double height = MediaQuery.of(context).size.height;
    print(height);
    //print(article.Content);
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0),
                child: Center(
                  //child:Text("文章标题")
                  child: Text(
                    article.Title.substring(0,titlelength),

                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),

              Center(
                child: Text(
                  article.Title.substring(subtitlelength),
                  style: TextStyle(
                    fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 19,right: 15,),
                child: Center(child: getContent(article.Content),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getContent(String content) {
    return Html(
      shrinkWrap: true,
      data: content,
      //Optional parameters:
      style: {
        "html": Style(
          margin: EdgeInsets.only(top: 0),
          padding: EdgeInsets.only(top: 0),
          //backgroundColor: Colors.black12,
          fontSize: FontSize(18),
//              color: Colors.white,
        ),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
//            "table": Style(
//              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
//            ),
//            "tr": Style(
//              border: Border(bottom: BorderSide(color: Colors.grey)),
//            ),
//            "th": Style(
//              padding: EdgeInsets.all(6),
//              backgroundColor: Colors.grey,
//            ),
//            "td": Style(
//              padding: EdgeInsets.all(6),
//            ),
//            "var": Style(fontFamily: 'serif'),
      },
//          customRender: {
//            "flutter": (RenderContext context, Widget child, attributes, _) {
//              return FlutterLogo(
//                style: (attributes['horizontal'] != null)
//                    ? FlutterLogoStyle.horizontal
//                    : FlutterLogoStyle.markOnly,
//                textColor: context.style.color,
//                size: context.style.fontSize.size * 5,
//              );
//            },
//          },
      onLinkTap: (url) {
        print("Opening $url...");
      },
      onImageTap: (src) {
        print(src);
      },
      onImageError: (exception, stackTrace) {
        print(exception);
      },
//          ),
//        ],
//      ),
    );
  }
}
