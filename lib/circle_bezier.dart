import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// create by 张风捷特烈 on 2020-03-28
/// contact me by email 1981462002@qq.com
/// 说明: 贝塞尔曲线测试画布
class CircleBezierPage extends StatefulWidget {
  @override
  _CircleBezierPageState createState() => _CircleBezierPageState();
}

class _CircleBezierPageState extends State<CircleBezierPage> {
  List<Offset> _pos = <Offset>[];
  int selectPos;

  //单位圆(即半径为1)控制线长
  final rate = 0.551915024494;
  double _radius = 150;

  @override
  void initState() {
    //横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    //全屏显示
    SystemChrome.setEnabledSystemUIOverlays([]);
    _initPoints();
    super.initState();
  }

  void _initPoints() {
    _pos = List<Offset>();
    //第一段线
    _pos.add(Offset(0, rate) * _radius);
    _pos.add(Offset(1 - rate, 1) * _radius);
    _pos.add(Offset(1, 1) * _radius);
    //第二段线
    _pos.add(Offset(1 + rate, 1) * _radius);
    _pos.add(Offset(2, rate) * _radius);
    _pos.add(Offset(2, 0) * _radius);
    //第三段线
    _pos.add(Offset(2, -rate) * _radius);
    _pos.add(Offset(1 + rate, -1) * _radius);
    _pos.add(Offset(1, -1) * _radius);
    //第四段线
    _pos.add(Offset(1 - rate, -1) * _radius);
    _pos.add(Offset(0, -rate) * _radius);
    _pos.add(Offset(0, 0));
  }

  @override
  Widget build(BuildContext context) {
    var x = MediaQuery.of(context).size.width/2;
    var y = MediaQuery.of(context).size.height/2;

    return GestureDetector(
      onPanDown: (detail) {
        setState(() => judgeSelect(detail.localPosition,x: x,y: y));
      },
      onPanEnd: (detail) {
        setState(() => selectPos = null);
      },
      onPanUpdate: (detail) {
        setState(() => judgeZone(detail.localPosition,x: x,y: y));
      },
      child: CustomPaint(
        painter: BezierPainter(pos: _pos, selectPos: selectPos),
      ),
    );
  }

  ///判断出是否在某点的半径为r圆范围内
  bool judgeCircleArea(Offset src, Offset dst, double r) =>
      (src - dst).distance <= r;

  void judgeSelect(Offset src, {double x = 0, double y = 0}) {
    print(src);

    var p = src.translate(-x, -y);
    print(p);
    for (int i = 0; i < _pos.length; i++) {
      if (judgeCircleArea(p, _pos[i], 15)) {
        selectPos = i;
      }
    }
  }

  void judgeZone(Offset src, {double x = 0, double y = 0}) {
    var p = src.translate(-x, -y);
    for (int i = 0; i < _pos.length; i++) {
      if (judgeCircleArea(p, _pos[i], 15)) {
        selectPos = i;
        _pos[i] = p;
      }
    }
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

  BezierPainter({this.pos, this.selectPos}) {
    _gridPaint = Paint()..style = PaintingStyle.stroke;
    _gridPath = Path();

    _mainPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _mainPath = Path();

    _helpPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    pos =
//        pos.map((e) => e.translate(-size.width / 2, -size.height / 2)).toList();
    canvas.drawColor(Colors.white, BlendMode.color);
    canvas.translate(size.width / 2, size.height / 2);
    _drawGrid(canvas, size); //绘制格线
    _drawAxis(canvas, size); //绘制轴线

    _mainPath.moveTo(0, 0);
    for (int i = 0; i < pos.length / 3; i++) {
      _mainPath.cubicTo(pos[3 * i + 0].dx, pos[3 * i + 0].dy, pos[3 * i + 1].dx,
          pos[3 * i + 1].dy, pos[3 * i + 2].dx, pos[3 * i + 2].dy);
    }

    canvas.drawPath(_mainPath, _mainPaint);
    _drawHelp(canvas);
    _drawSelectPos(canvas);
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
    _helpPaint..strokeWidth = 1;
    canvas.drawLine(pos[0], pos[11], _helpPaint);
    canvas.drawLine(pos[1], pos[2], _helpPaint);
    canvas.drawLine(pos[2], pos[3], _helpPaint);
    canvas.drawLine(pos[4], pos[5], _helpPaint);
    canvas.drawLine(pos[5], pos[6], _helpPaint);
    canvas.drawLine(pos[7], pos[8], _helpPaint);
    canvas.drawLine(pos[8], pos[9], _helpPaint);
    canvas.drawLine(pos[10], pos[11], _helpPaint);
    canvas.drawLine(pos[11], pos[0], _helpPaint);
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
