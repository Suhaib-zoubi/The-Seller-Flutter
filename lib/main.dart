import 'package:flutter/material.dart';
import 'package:the_seller/UI/Login.dart';
import 'package:the_seller/UI/Register.dart';
import 'UI/ControlPanel.dart';
import 'UI/ShowData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Seller',
      theme: ThemeData(
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        ),
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.green[500],
      ),
      home: ControlPanel(),
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext) => Register(),
        '/login': (BuildContext) => Login(),
        '/controlPanel': (BuildContext) => ControlPanel(),
      },
    );
  }
}
