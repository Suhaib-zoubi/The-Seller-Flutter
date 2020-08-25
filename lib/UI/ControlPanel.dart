import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

class ControlPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ControlPanelState();
  }
}

class ControlPanelState extends State<ControlPanel> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF104454),
            title: Text("The Seller"),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  DatabaseHelper databaseHelper = DatabaseHelper();
                  databaseHelper.save("empty");
                  databaseHelper.loadData(context);
                },
              )
            ],
          ),
        ));
  }
}
