import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// create by 张风捷特烈 on 2020-03-27
/// contact me by email 1981462002@qq.com
/// 说明: 贝塞尔曲线测试画布


Offset p0 = Offset(0, 0);
Offset p1 = Offset(100, 100);
Offset p2 = Offset(120, -60);
Offset p3 = Offset(200, 160);

class BezierPainter extends CustomPainter {
  Paint _gridPaint;
  Path _gridPath;

  Paint _mainPaint;
  Path _mainPath;

  Paint _helpPaint;

  final Offset pointer;

  BezierPainter({this.pointer}) {
    _gridPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;
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
    _judge(pointer - Offset(size.width / 2, size.height / 2));

    canvas.drawColor(Colors.white, BlendMode.color);
    canvas.translate(size.width / 2, size.height / 2);
    _drawGrid(canvas, size); //绘制格线
    _drawAxis(canvas, size); //绘制轴线

    _mainPath.moveTo(p0.dx, p0.dy);
//    _mainPath.cubicTo(p1.dx, p1.dy,p2.dx, p2.dy,p3.dx, p3.dy,);
    _mainPath.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
//    _mainPath.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    canvas.drawPath(_mainPath, _mainPaint);

    _drawHelp(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  ///判断出是否在某点的半径为r圆范围内
  bool judgeCircleArea(Offset src, Offset dst, double r) =>
      (src - dst).distance <= r;

  void _drawGrid(Canvas canvas, Size size) {
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
    canvas.drawPoints(
        PointMode.lines, [p0, p1, p1, p2], _helpPaint..strokeWidth = 1);
    canvas.drawPoints(
        PointMode.points, [p0, p1, p1, p2], _helpPaint..strokeWidth = 8);
  }

  void _judge(Offset src) {
    if (judgeCircleArea(src, p0, 15)) {
      p0 = src;
    }
    if (judgeCircleArea(src, p1, 15)) {
      p1 = src;
    }
    if (judgeCircleArea(src, p2, 15)) {
      p2 = src;
    }
    print(p0);
  }
}
