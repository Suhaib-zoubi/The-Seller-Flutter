import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

import 'AddProduct.dart';

class MyProducts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyProductsState();
  }
}

class MyProductsState extends State<MyProducts> {
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
            actions: [],
          ),
          floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  AddProduct(null, '', '', '', null),
            )),
          ),
          body: FutureBuilder<List>(
            future: databaseHelper.getMyTools(DatabaseHelper.userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) print(snapshot.error);
              return snapshot.hasData
                  ? ItemList(list: snapshot.data)
                  : Center(
                      child: new CircularProgressIndicator(),
                    );
            },
          ),
        ));
  }
}

class ItemList extends StatefulWidget {
  List list;

  ItemList({this.list});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItenListState();
  }
}

class ItenListState extends State<ItemList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        padding: EdgeInsets.all(7.0),
        itemCount: widget.list.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.only(bottom: 4),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => AddProduct(
                    widget.list[i]['ToolID'],
                    widget.list[i]['ToolName'],
                    widget.list[i]['ToolDes'],
                    widget.list[i]['ToolPrice'],
                    widget.list[i]['PictureLink']),
              )),
              onDoubleTap: () => print(i),
              child: Dismissible(
                key: UniqueKey(),
                child: ListTile(
                  title: Text(widget.list[i]['ToolName']),
                  leading: Image.network(
                    'https://the-seller20200630093320.azurewebsites.net/Images/${widget.list[i]['PictureLink']}',
                    height: 50.0,
                    width: 50.0,
                  ),
                  subtitle: Text('${widget.list[i]['ToolDes']}'),
                  trailing: Text('\$${widget.list[i]['ToolPrice']}'),
                  tileColor: Colors.white70,
                ),
                onDismissed: (direction) {
                  databaseHelper.DeleteTool(widget.list[i]['ToolID']);
                  setState(() {
                    widget.list.removeAt(i);
                  });
                },
              ),
            ),
          );
        });
  }
}
