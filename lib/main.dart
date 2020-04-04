import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterplaybezier/flutter_wave.dart';
import 'package:flutterplaybezier/toly_slider.dart';
import 'package:flutterplaybezier/toly_wave.dart';
import 'package:flutterplaybezier/vitium_paper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    //全屏显示
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('波浪测试'),
        ),
        body: Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 30,
          runSpacing: 20,
          children: <Widget>[
            FlutterWaveLoading(),
            FlutterWaveLoading(
              color: Colors.red,
            ),
            FlutterWaveLoading(
              isOval: true,
              color: Colors.blue,
            ),

            FlutterWaveLoading(
              isOval: true,
              color: Colors.purple,
              progress: 0.8,
              width: 100,
              height: 100,
            ),


//            ...List.generate(9, (v) => 0.1 * v+0.1)
//                .map((e) => FlutterWaveLoading(
//                      width: 75,
//                      height: 75,
//                      isOval: true,
//                      progress: e,
//                      waveHeight: 3,
//                      color: Colors.blue,
//                    ))
//                .toList()
          ],
        )),
      ),
    );
  }
}
