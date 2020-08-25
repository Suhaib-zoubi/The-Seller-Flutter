import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'package:the_seller/UI/ControlPanel.dart';

class ShowData extends StatefulWidget {

  List list;
  var index;

  ShowData({this.list,this.index});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowDataState();
  }
}

class ShowDataState extends State<ShowData> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF104454),
            title: Text("The Seller"),
          ),
        body: ListView(
          padding: const EdgeInsets.only(top: 15.0,left: 12.0,right: 12.0,bottom: 12.0),
          children: [
        Image.network('https://the-seller20200630093320.azurewebsites.net/Images/${widget.list[widget.index]['PictureLink']}'
          ,height: 200.0,
          width: 200.0,),
            new Padding(padding: new EdgeInsets.only(top: 44.0),),
            Container(
              height: 50,
              child: new Text(
                "Name : ${ widget.list[widget.index]['ToolName']}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 30.0),),
            Container(
              height: 50,
              child: new Text(
                " Description : ${widget.list[widget.index]['ToolDes']}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 30.0),),

            Container(
              height: 50,
              child: new Text(
                " \$${widget.list[widget.index]['ToolPrice']}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              height: 50,
              child: new Text(
                " Date add : ${widget.list[widget.index]['DateAdd']}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ),
    );
  }

}