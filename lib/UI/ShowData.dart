import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'package:the_seller/UI/ControlPanel.dart';

import 'modelsPost.dart';

class ShowData extends StatefulWidget {


  final PostModel post;

  ShowData(this.post);
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
    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'Product details',
              style: TextStyle(
                color: Color(0xFF13566b),
                fontSize: 30.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
        body: ListView(
          padding: const EdgeInsets.only(top: 15.0,left: 12.0,right: 12.0,bottom: 12.0),
          children: [
            (widget.post.pictureLink==null || widget.post.pictureLink =='')
                ? Icon(Icons.ac_unit)
                :Image.network(
              'https://the-seller20200630093320.azurewebsites.net/Images/${widget.post.pictureLink}',
              width: 100.0,
              height: 100.0,
              loadingBuilder: (context,child,progress){
                return progress==null
                    ? child
                    : Container(alignment: Alignment.center,width:100.0,height:100.0,child: CircularProgressIndicator());
              },
            ),
            new Padding(padding: new EdgeInsets.only(top: 44.0),),
            Container(
              height: 50,
              child: new Text(
                "Name : ${ widget.post.toolName}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 30.0),),
            Container(
              height: 50,
              child: new Text(
                " Description : ${widget.post.toolDes}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            new Padding(padding: new EdgeInsets.only(top: 30.0),),

            Container(
              height: 50,
              child: new Text(
                " \$${widget.post.toolPrice}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              height: 50,
              child: new Text(
                " Date add : ${widget.post.dateAdd}",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
    );
  }

}