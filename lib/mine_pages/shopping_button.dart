import 'package:flutter/material.dart';



//faith 2020年04月20日11:05:57
class NumberControllerWidget extends StatefulWidget {
  //高度
  final double height;

  //输入框的宽度 总体宽度为自适应
  final double width;

  //按钮的宽度
  final double iconWidth;

  //默认输入框显示的数量
  final String numText;

  //点击加号回调 数量
  final ValueChanged addValueChanged;

  //点击减号回调 数量
  final ValueChanged removeValueChanged;

  //点击加号减号任意一个回调 数量
  final ValueChanged updateValueChanged;

  //手动输入字的回调
  final ValueChanged textEditChanged;

  NumberControllerWidget({
    this.height = 20,
    this.width = 20,
    this.iconWidth = 20,
    this.numText = '0',
    this.addValueChanged,
    this.removeValueChanged,
    this.updateValueChanged,
    this.textEditChanged,
  });

  @override
  _NumberControllerWidgetState createState() => _NumberControllerWidgetState();
}

class _NumberControllerWidgetState extends State<NumberControllerWidget> {
  var textController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.textController.text = widget.numText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: widget.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(width: 1, color: Colors.black12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //减号
              Container(
                child: CoustomIconButton(icon: Icons.remove, isAdd: false,),
              ),
              //输入框
              Container(
                width: widget.width,
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 1, color: Colors.black12),
                        right: BorderSide(width: 1, color: Colors.black12))),
                child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(left: 1, top: 2, bottom: 2, right: 0),
                      border: const OutlineInputBorder(
                        gapPadding: 0,
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                    onEditingComplete:(){
                      widget.textEditChanged(textController.text);
                    }
                ),
              ),
              //加号
              CoustomIconButton(icon: Icons.add, isAdd: true),
            ],
          ),
        )
      ],
    );
  }

  //加减框的
  Widget CoustomIconButton({IconData icon, bool isAdd}) {
    return Container(
      width: widget.iconWidth,
      child: IconButton(
        iconSize: 13,
        padding: EdgeInsets.all(0),
        icon: Icon(icon),
        onPressed: () {
          var num = int.parse(textController.text);
          if (!isAdd && num == 0) return;
          if (isAdd) {
            num++;
            if (widget.addValueChanged != null) widget.addValueChanged(num);
          } else {
            num--;
            if (widget.removeValueChanged != null)
              widget.removeValueChanged(num);
          }
          textController.text = '$num';
          if (widget.updateValueChanged != null) widget.updateValueChanged(num);
        },
      ),
    );
  }
}