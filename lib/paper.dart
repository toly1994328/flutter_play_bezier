import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bezier_paper.dart';

/// create by 张风捷特烈 on 2020-03-27
/// contact me by email 1981462002@qq.com
/// 说明: 纸

class Paper extends StatefulWidget {
  @override
  _PaperState createState() => _PaperState();
}

class _PaperState extends State<Paper> {
  Offset _pointer = Offset.zero;

  @override
  void initState() {
    //横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    //全屏显示
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onPanUpdate: (detail){
        setState(() {
          _pointer = detail.localPosition;
        });
        return ;
      },
      child: CustomPaint(
          painter: BezierPainter(pointer: _pointer),
      ),
    );
  }
}

