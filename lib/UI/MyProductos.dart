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
    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'My Products',
              style: TextStyle(
                color: Color(0xFF13566b),
                fontSize: 30.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          floatingActionButton: new FloatingActionButton(
            backgroundColor: Colors.grey[100],
            child: new Icon(Icons.add,color: Color(0xFF13566b),size: 35.0,),
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
                  leading: (widget.list[i]['PictureLink']==null || widget.list[i]['PictureLink']=='')
                      ? Icon (
                    Icons.announcement,
                    size: 60.0,
                  )
                      : Image.network(
                    'https://the-seller20200630093320.azurewebsites.net/Images/${widget.list[i]['PictureLink']}',
                    height: 80.0,
                    width: 80.0,
                    loadingBuilder: (context,child,progress){
                      return progress==null
                          ? child
                          : Container(child: CircularProgressIndicator(),
                        width: 80.0,height: 80.0,);
                    },
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
