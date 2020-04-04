import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// create by 张风捷特烈 on 2020-03-28
/// contact me by email 1981462002@qq.com
/// 说明: 贝塞尔曲线测试画布
class TolyWave extends StatefulWidget {
  @override
  _TolyWaveState createState() => _TolyWaveState();
}

class _TolyWaveState extends State<TolyWave> with SingleTickerProviderStateMixin{

  AnimationController _controller;
Animation _anim;
  @override
  void initState() {
    //横屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    //全屏显示
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = AnimationController(vsync: this,duration: Duration(milliseconds: 1200))
      ..addListener((){
      setState(() {

      });
    });
    _anim = CurveTween(curve: Curves.linear).animate(_controller);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: BezierPainter(factor: _anim.value),
      ),
    );


//      GestureDetector(
//      onPanDown: (detail) => _controller.repeat(reverse: false),
//      child: ,
//    );
  }
}

class BezierPainter extends CustomPainter {
  Paint _gridPaint;
  Path _gridPath;

  Paint _mainPaint;
  Path _mainPath;
  int selectPos;
  Paint _helpPaint;

  List<Offset> pos;

  Offset center = Offset(200, 0);

  double radius = 10;
  double cRadius = 40;
  double height =10;

  double waveWidth = 80;
  double waveHeight = 8;
  double wrapHeight =100;

  double factor;

  BezierPainter({this.factor=1}) {
    _gridPaint = Paint()..style = PaintingStyle.stroke;
    _gridPath = Path();

    _mainPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _mainPath = Path();

    _helpPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
  }

  //单位圆(即半径为1)控制线长
  final rate = 1;
  double oY = 10;
  double top = 10;

  @override
  void paint(Canvas canvas, Size size) {
    center = center.translate(-size.width / 2, 0);

    canvas.drawColor(Colors.white, BlendMode.color);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.clipPath(Path()
      ..addOval(Rect.fromCenter(
          center: Offset( waveWidth, 0),width: waveWidth*2,height: waveWidth*2)));

//    canvas.clipPath(Path()
//      ..addRRect(RRect.fromRectXY(Rect.fromCenter(
//          center: Offset( waveWidth, 0),
//          width: waveWidth*2,height: 200.0), 30 , 30)));
//    _drawGrid(canvas, size); //绘制格线
//    _drawAxis(canvas, size); //绘制轴线

    canvas.save();
    canvas.save();
    canvas.translate(-4*waveWidth+2*waveWidth*factor, 0);
    drawWave(canvas);
    canvas.drawPath(_mainPath, _mainPaint..style=PaintingStyle.fill..color=Colors.red.withAlpha(88));
    canvas.restore();

    canvas.translate(-4*waveWidth+2*waveWidth*factor*2, 0);
    drawWave(canvas);
    canvas.drawPath(_mainPath, _mainPaint..style=PaintingStyle.fill..color=Colors.red);
    canvas.restore();
  }

  void drawWave(Canvas canvas) {
    _mainPath.moveTo(0, 0);
    _mainPath.relativeQuadraticBezierTo(waveWidth/2, -waveHeight*2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(waveWidth/2, waveHeight*2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(waveWidth/2, -waveHeight*2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(waveWidth/2, waveHeight*2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(waveWidth/2, -waveHeight*2, waveWidth, 0);
    _mainPath.relativeQuadraticBezierTo(waveWidth/2, waveHeight*2, waveWidth, 0);
    _mainPath.relativeLineTo(0, wrapHeight);
    _mainPath.relativeLineTo(-waveWidth*3 * 2.0, 0);
    _mainPath.close();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void _drawGrid(Canvas canvas, Size size) {
    _gridPaint
      ..color = Colors.grey
      ..strokeWidth = 0.5;
    _gridPath = _buildGridPath(_gridPath, size);
    canvas.drawPath(_buildGridPath(_gridPath, size), _gridPaint);

    canvas.save();
    canvas.scale(1, -1); //沿x轴镜像
    canvas.drawPath(_gridPath, _gridPaint);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1); //沿y轴镜像
    canvas.drawPath(_gridPath, _gridPaint);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    canvas.drawPath(_gridPath, _gridPaint);
    canvas.restore();
  }

  void _drawAxis(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.lines,
        [
          Offset(-size.width / 2, 0),
          Offset(size.width / 2, 0),
          Offset(0, -size.height / 2),
          Offset(0, size.height / 2),
          Offset(0, size.height / 2),
          Offset(0 - 7.0, size.height / 2 - 10),
          Offset(0, size.height / 2),
          Offset(0 + 7.0, size.height / 2 - 10),
          Offset(size.width / 2, 0),
          Offset(size.width / 2 - 10, 7),
          Offset(size.width / 2, 0),
          Offset(size.width / 2 - 10, -7),
        ],
        _gridPaint
          ..color = Colors.blue
          ..strokeWidth = 1.5);
  }

  Path _buildGridPath(Path path, Size size, {step = 20.0}) {
    for (int i = 0; i < size.height / 2 / step; i++) {
      path.moveTo(0, step * i);
      path.relativeLineTo(size.width / 2, 0);
    }
    for (int i = 0; i < size.width / 2 / step; i++) {
      path.moveTo(step * i, 0);
      path.relativeLineTo(
        0,
        size.height / 2,
      );
    }
    return path;
  }

  void _drawHelp(Canvas canvas) {
    canvas.drawPoints(PointMode.lines, pos, _helpPaint..strokeWidth = 1);
    canvas.drawPoints(PointMode.points, pos, _helpPaint..strokeWidth = 8);
  }

  void _drawSelectPos(Canvas canvas) {
    if (selectPos == null) return;
    canvas.drawCircle(
        pos[selectPos],
        10,
        _helpPaint
          ..color = Colors.green
          ..strokeWidth = 2);
  }
}
