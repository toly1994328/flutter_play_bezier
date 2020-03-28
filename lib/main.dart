import 'package:flutter/material.dart';

import 'circle_bezier.dart';
import 'circle_bezier_clip.dart';
import 'paper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CircleBezierClipPage(),
    );
  }
}
