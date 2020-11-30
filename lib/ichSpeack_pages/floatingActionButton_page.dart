import 'package:flutter/material.dart';
import 'package:ich/talk_add_pages/talk_add_page.dart';

class FloatBtn extends StatefulWidget {
  FloatBtn({Key key}) : super(key: key);

  @override
  _FloatBtnState createState() => _FloatBtnState();
}

class _FloatBtnState extends State<FloatBtn> {
//  Offset offsetA = Offset(320, kToolbarHeight + 570); //按钮的初始位置

  @override
  Widget build(BuildContext context) {
    Offset offsetA = Offset(320, kToolbarHeight + 570); //按钮的初始位置
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Stack(children: <Widget>[
      Positioned(
          left: offsetA.dx,
          top: offsetA.dy,
          child: Draggable(
            //创建可以被拖动的Widget
              child: FloatingActionButton(
                backgroundColor: Colors.amber,
                child: Icon(
                  Icons.add,
                  size: 35.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TalkAddWidget()));
                },
              ),
              //拖动过程中的Widget
              feedback: FloatingActionButton(
                backgroundColor: Colors.amber,
                child: Icon(
                  Icons.add,
                  size: 35.0,
                ),
                onPressed: () {},
              ),
              //拖动过程中，在原来位置停留的Widget，设定这个可以保留原本位置的残影，如果不需要可以直接设置为Container()
              childWhenDragging: Container(),
              //拖动结束后的Widget
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                // 计算组件可移动范围  更新位置信息
                setState(() {
                  var x = offset.dx;
                  var y = offset.dy;
                  if (offset.dx < 0) {
                    x = 20;
                  }
                  if (offset.dx > 375) {
                    x = 335;
                  }
                  if (offset.dy < kBottomNavigationBarHeight) {
                    y = kBottomNavigationBarHeight;
                  }
                  if (offset.dy > height - 100) {
                    y = height - 100;
                  }
                  offsetA = Offset(x, y);
                });
              }))
    ]);
  }
}
