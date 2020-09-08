import 'package:flutter/material.dart';
import 'package:the_seller/UI/Login.dart';
import 'package:the_seller/UI/MyProductos.dart';
import 'package:the_seller/UI/Register.dart';
import 'UI/ControlPanel.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Seller',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Raleway',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        // This colors the [InputOutlineBorder] when it is selected
        primaryColor: Colors.grey[500],
        textSelectionHandleColor: Colors.grey[400],
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) => Register(),
        '/login': (BuildContext context) => Login(),
        '/controlPanel': (BuildContext context) => ControlPanel(),
        '/myProducts': (BuildContext context) => MyProducts(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setDelay();
  }

  Future<Null> setDelay() async {
    await Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/controlPanel', (route) => false);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text(
          'The Seller',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
    );
  }
}
