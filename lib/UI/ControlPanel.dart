import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'package:the_seller/UI/MyProductos.dart';
import 'package:the_seller/UI/posts.dart';

class ControlPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ControlPanelState();
  }
}

class ControlPanelState extends State<ControlPanel> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future<List<dynamic>> list;
  var isRefresh=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.loadData(context);
    refreshKey= GlobalKey<RefreshIndicatorState>();
    print ('list $list');
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
        list =  databaseHelper.getToolListing(DatabaseHelper.userId);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text(
              'The Seller',
              style: TextStyle(
                color: Color(0xFF13566b),
                fontSize: 30.0,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
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
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 50.0,right: 50.0,bottom: 10.0),
            width: 200.0,
              child: RaisedButton(
                child: Text(
                  'My Products',
                  style: TextStyle(
                  color: Color(0xFF13566b),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext) => MyProducts())),
                color: Colors.grey[100],
              ),


            color: Colors.white,
          ),
          body: Posts(),
//          Center(
//            child: RefreshIndicator(
//              key: refreshKey,
//              onRefresh: () {
//                Future.delayed((Duration(seconds: 3)));
//                print('delayed');
////                Navigator.of(context).pushReplacement(MaterialPageRoute(
////                    builder: (c)=>ControlPanel()));
//                setState(() {
//                  isRefresh=true;
////                  isRefresh=false;
//                  print('delayed2');
//                });
//                return null;
//              },
//              child: isRefresh
//                ? doThat()
//                : FutureBuilder<List>(
//                future: databaseHelper.getToolListing(DatabaseHelper.userId),
//                builder: (context, snapshot) {
//                  print ('snapshot ${snapshot.data}');
//                  if (snapshot.hasData) print(snapshot.error);
//                  return snapshot.hasData
//                      ? ItemList(list: snapshot.data)
//                      : Center(
//                    child: snapshot.data == null
//                        ? SingleChildScrollView(
//                      child: Center(
//                        child: Container(
//                          margin: EdgeInsets.all(16.0),
//                          padding: EdgeInsets.all(16.0),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(16.0),
//                            color: Color(0xFF912D2D),
//                          ),
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              Icon(
//                                Icons.error_outline,
//                                size: 180.0,
//                                color: Colors.white,
//                              ),
//                              Text(
//                                "Oh no! We can't connect right now!",
//                                textAlign: TextAlign.center,
//                                style: Theme.of(context).textTheme.headline.copyWith(
//                                  color: Colors.white,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    )
//                        : new CircularProgressIndicator(),
//                  );
//                },
//              ),
//
//            ),
//          ),
        );

  }
  Widget doThat(){
    setState(() {
      isRefresh=false;
    });
    return Text('');
  }
}
final _rowHeight = 100.0;
final _borderRadius = BorderRadius.circular(_rowHeight / 2);
class ItemList extends StatelessWidget {
  List list;
  static const _baseColors =
  ColorSwatch(0xFF6AB7A8, {
  'highlight':  Colors.white70,
  'splash': Colors.amberAccent,
  });
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          return Material(
            color: Colors.white,
            child: Container(
              height: 150.0,
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                highlightColor: _baseColors['highlight'],
                splashColor: _baseColors['splash'],
//                onTap:() => Navigator.of(context).push(MaterialPageRoute<Null>(
//                      builder: (BuildContext context) =>
//                          ShowData(list: list, index: i),
//                    )),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
//                  child: GestureDetector(
//                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext context) =>
//                          ShowData(list: list, index: i),
//                    )),
                    child: Row(
                      children: [
                        Divider(key: UniqueKey(),height: 3.0,color: Colors.black,),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: (list[i]['PictureLink']==null || list[i]['PictureLink']=='')
                          ? Icon (
                            Icons.announcement,
                            size: 60.0,
                          )
                          : Image.network(
                            'https://the-seller20200630093320.azurewebsites.net/Images/${list[i]['PictureLink']}',
                            height: 80.0,
                            width: 80.0,
                            loadingBuilder: (context,child,progress){
                              return progress==null
                                  ? child
                                  : Container(child:CircularProgressIndicator(),
                              width: 80.0,height: 80.0,);
                            },
//                            placeholder: (c,b)=>CircularProgressIndicator(),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                list[i]['ToolName'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF13566b),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
//                              Text(
//                                list[i]['ToolDes'],
//                                textAlign: TextAlign.center,
//                                style: Theme.of(context).textTheme.bodyText1,
//                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  '\$${list[i]['ToolPrice']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0
                                  ),
                                ),
                              ),
                            )
                        ),
//                        ListTile(
//                          title: Text(list[i]['ToolName']),
//                          leading: Image.network(
//                            'https://the-seller20200630093320.azurewebsites.net/Images/${list[i]['PictureLink']}',
//                            height: 50.0,
//                            width: 50.0,
//                          ),
//                          subtitle: Text('${list[i]['ToolDes']}'),
//                          trailing: Text('\$${list[i]['ToolPrice']}'),
//                        ),
                      ],
                    ),
//                  ),
                ),
              ),
            ),
          );
        });
  }
}
