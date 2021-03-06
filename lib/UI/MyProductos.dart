import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'dart:async';
import 'AddProduct.dart';

class MyProducts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyProductsState();
  }
}

Future<List> list;

class MyProductsState extends State<MyProducts> with WidgetsBindingObserver {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    databaseHelper.loadData(context);
    list = databaseHelper.getMyProducts(DatabaseHelper.userId);
  }

  Future<Null> getData() async {
    Completer<Null> completer = Completer<Null>();
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      list =
          databaseHelper.getMyProducts(DatabaseHelper.userId).whenComplete(() {
        completer.complete();
      });
    });
    return completer.future;
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
          child: new Icon(
            Icons.add,
            color: Color(0xFF13566b),
            size: 35.0,
          ),
          onPressed: () => Navigator.of(context)
              .push(new MaterialPageRoute(
            builder: (BuildContext context) =>
                AddProduct(null, '', '', '', '', '', null),
          ))
              .then((value) {
            setState(() {
              DatabaseHelper.myProducts = 1;
            });
            getData();
          }),
        ),
        body: RefreshIndicator(
          onRefresh: getData,
          child: FutureBuilder<List>(
            future: list,
            builder: (context, snapshot) {
              if (snapshot.hasData) print(snapshot.error);
              return (DatabaseHelper.myProducts == 0)
                  ? Center(
                      child: Text('Add your first product'),
                    )
                  : snapshot.hasData
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
  final List list;

  ItemList({this.list});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemListState();
  }
}

class ItemListState extends State<ItemList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (DatabaseHelper.myProducts == 0)
        ? Center(
            child: Text("Add your first product"),
          )
        : ListView.builder(
            padding: EdgeInsets.all(7.0),
            itemCount: widget.list.length,
            itemBuilder: (context, i) {
              return Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AddProduct(
                          widget.list[i]['ToolID'],
                          widget.list[i]['ToolName'],
                          widget.list[i]['ToolDes'],
                          widget.list[i]['ToolPrice'],
                          widget.list[i]['PictureLink'],
                          widget.list[i]['ToolTypeID'],
                          widget.list[i]['ToolCity']);
                    },
                  )).then((value) {
                    if (value != null)
                      setState(() {
                        widget.list[i]['ToolName'] = value['ToolName'];
                        widget.list[i]['ToolDes'] = value['ToolDes'];
                        widget.list[i]['ToolPrice'] = value['ToolPrice'];
                        widget.list[i]['PictureLink'] = value['PictureLink'];
                        widget.list[i]['ToolTypeID'] = value['ToolTypeID'];
                        widget.list[i]['ToolCity'] = value['ToolCity'];
                      });
                  }),
                  onDoubleTap: () => print(i),
                  child: Dismissible(
                    key: UniqueKey(),
                    child: ListTile(
                      title: Text(widget.list[i]['ToolName']),
                      leading: (widget.list[i]['PictureLink'] == null ||
                              widget.list[i]['PictureLink'] == '' ||
                              widget.list[i]['PictureLink'] == '0')
                          ? Icon(
                              Icons.announcement,
                              size: 60.0,
                            )
                          : Image.network(
                              'https://the-seller20200630093320.azurewebsites.net/Images/${widget.list[i]['PictureLink']}',
                              height: 80.0,
                              width: 80.0,
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Container(
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(),
                                        width: 80.0,
                                        height: 80.0,
                                      );
                              },
                            ),
                      subtitle: Text('${widget.list[i]['ToolDes']}'),
                      trailing: Text('\$${widget.list[i]['ToolPrice']}'),
                      tileColor: Colors.white70,
                    ),
                    onDismissed: (direction) {
                      databaseHelper.deleteProduct(widget.list[i]['ToolID']);
                      setState(() {
                        widget.list.removeAt(i);
                        if (widget.list.length == 0)
                          DatabaseHelper.myProducts = 0;
                      });
                    },
                  ),
                ),
              );
            });
  }
}
