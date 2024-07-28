// @dart=2.9
import 'package:flutter/material.dart';
import 'Screen/homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      title: 'video_editor_git',
      home: HomePage(),
    );
  }
}




