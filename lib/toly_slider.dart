import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// create by 张风捷特烈 on 2020-03-28
/// contact me by email 1981462002@qq.com
/// 说明: 贝塞尔曲线测试画布
class TolySlider extends StatefulWidget {
  @override
  _TolySliderState createState() => _TolySliderState();
}

class _TolySliderState extends State<TolySlider> {
  List<Offset> _pos = <Offset>[];
  int selectPos;
  Offset _center = Offset(0, 0);

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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onPanDown: (detail) {
//        if (_pos.length < 4) {
//          _pos.add(detail.localPosition);
//        }
//        setState(() => judgeSelect(detail.localPosition));
//      },
//      onPanEnd: (detail) {
//        setState(() => selectPos = null);
//      },
      onPanUpdate: (detail) {
        setState(() => updateCenter(detail.localPosition));
      },
      child: CustomPaint(
            painter: BezierPainter(center: _center),

      ),
    );
  }

  void updateCenter(Offset src) {
    _center = Offset(src.dx, 0);
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

  BezierPainter({this.center}) {
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

  //单位圆(即半径为1)控制线长
  final rate = 1;
  double oY = 10;
  double top = 10;

  @override
  void paint(Canvas canvas, Size size) {
    center = center.translate(-size.width / 2, 0);
    canvas.drawColor(Colors.white, BlendMode.color);
    canvas.translate(size.width / 2, size.height / 2);
//    _drawGrid(canvas, size); //绘制格线
//    _drawAxis(canvas, size); //绘制轴线

    _mainPath.moveTo(0, 0);
    _mainPath.relativeCubicTo(
        rate*cRadius, 0,
        (2-rate)*cRadius, cRadius, 2*cRadius, cRadius);
    _mainPath.relativeCubicTo(
        rate*cRadius, 0,
        (2-rate)*cRadius, cRadius, 2*cRadius, cRadius);
    _mainPath.relativeCubicTo(
        rate*cRadius, 0,
        (2-rate)*cRadius, cRadius, 2*cRadius, cRadius);
    _mainPath.relativeCubicTo(
        rate*cRadius, 0,
        (2-rate)*cRadius, cRadius, 2*cRadius, cRadius);
    //    _mainPath.moveTo(-size.width / 2, -radius*1.5);
//    _mainPath.lineTo(-2 * radius + center.dx, -radius*1.5);

//    _mainPath.relativeCubicTo(
//        0, -height * rate,
//        cRadius * (1 - rate), -height,
//        cRadius, -height);
//
//    _mainPath.relativeCubicTo(
//        cRadius * rate, 0,
//        cRadius, height * (1 - rate),
//        cRadius, height);
//
//    _mainPath.relativeLineTo(size.width / 2 - radius - center.dx, 0);
//
    canvas.drawPath(_mainPath, _mainPaint);
//    canvas.drawCircle(center, radius, _mainPaint);

//    if(pos.length<4){
//      canvas.drawPoints(PointMode.points, pos, _helpPaint..strokeWidth = 8);
//    }else{
//      _mainPath.moveTo(pos[0].dx, pos[0].dy);
//      _mainPath.cubicTo(pos[1].dx, pos[1].dy, pos[2].dx, pos[2].dy, pos[3].dx, pos[3].dy);
//      canvas.drawPath(_mainPath, _mainPaint);
//
//      _drawHelp(canvas);
//      _drawSelectPos(canvas);
//    }
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
