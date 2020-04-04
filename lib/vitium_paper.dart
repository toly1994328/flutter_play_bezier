import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// create by 张风捷特烈 on 2020-04-03
/// contact me by email 1981462002@qq.com
/// 说明: 

class VitiumWidget extends StatefulWidget {
  @override
  _VitiumWidgetState createState() => _VitiumWidgetState();
}

class _VitiumWidgetState extends State<VitiumWidget> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: VitiumPainter(),
              ),
            ),
          ),
        ],
    );
  }
}


class VitiumPainter extends CustomPainter {
  final int navCount; //导航总数
  final double moveTween; //移动补间
  final double padding; //间隙
  VitiumPainter({this.navCount=5, this.moveTween=2, this.padding=20});

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    Paint paint = Paint()
      ..color = (Colors.blue)
      ..style = PaintingStyle.stroke; //画笔
    double width = size.width; //导航栏总宽度，即canvas宽度
    double singleWidth = width / navCount; //单个导航项宽度
    double height = size.height; //导航栏高度，即canvas高度
    double arcRadius = height * 2 / 3; //圆弧半径
    double restSpace = (singleWidth - arcRadius * 2) / 2; //单个导航项减去圆弧直径后单边剩余宽度

    Path path = Path() //路径
      ..relativeLineTo(moveTween * singleWidth, 0)
      ..relativeCubicTo(
          restSpace + padding, 0,
          restSpace + padding / 2,
          arcRadius, singleWidth / 2, arcRadius) //圆弧左半边

      ..relativeCubicTo(
          arcRadius, 0,
          arcRadius - padding, -arcRadius,
          restSpace + arcRadius, -arcRadius) //圆弧右半边

      ..relativeLineTo(width - (moveTween + 1) * singleWidth, 0)
      ..relativeLineTo(0, height)
      ..relativeLineTo(-width, 0)
      ..relativeLineTo(0, -height)
      ..close();
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}