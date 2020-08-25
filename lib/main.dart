import 'package:flutter/material.dart';
import 'package:the_seller/UI/Login.dart';
import 'package:the_seller/UI/Register.dart';
import 'UI/ControlPanel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Seller',
      home: ControlPanel(),
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext) => Register(),
        '/login': (BuildContext) => Login(),
        '/controlPanel': (BuildContext) => ControlPanel(),
      },
    );
  }
}
