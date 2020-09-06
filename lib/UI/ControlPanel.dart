import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'package:the_seller/UI/MyProductos.dart';
import 'package:the_seller/UI/posts.dart';

import 'modelsPost.dart';

class ControlPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ControlPanelState();
  }
}
enum PopMenu{logOut}
 var valType=0;
List listType= [
  0,
  1,
  2,
  3,
];
List listValueType= [
  'All Types',
  'Car',
  'Phones',
  'Clothes'
];
 var valCity=0;
List listCity= [
  0,
  1,
  2,
  3,
];
List listValueCity= [
  'All Cities',
  'Riyadh',
  'Dammam',
  'Jedah'
];
class ControlPanelState extends State<ControlPanel> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<RefreshIndicatorState> refreshKey;
  Future<List<dynamic>> list;
  var isRefresh=false;
  PopMenu _selction;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.loadData(context);
    refreshKey= GlobalKey<RefreshIndicatorState>();
    print ('list $list');
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
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  setState(() {
                    _showMyDialog();
                  });
                },
              ),
              PopupMenuButton<PopMenu>(
                onSelected: (result){
                  DatabaseHelper databaseHelper = DatabaseHelper();
                  databaseHelper.save("empty");
                  databaseHelper.loadData(context);
                  setState(() {
                    _selction=result;
                  });
                },
                  itemBuilder: (context)=><PopupMenuEntry<PopMenu>> [
                    const PopupMenuItem<PopMenu>(
                        value: PopMenu.logOut,
                        child: Text('Log out',)
                    )
                  ]
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
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return MyDialog();
      },
    );
  }



}

class MyDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyDialogState();
  }
}

class _MyDialogState extends State<MyDialog> {

  Widget _createDropdownType() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: valType,
              onChanged: (value) {
                setState(() {
                  valType=value;
                  print('$valType');
                });
              },
              items: listType.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Container(child: Text(
                    listValueType[value],
                    style: TextStyle(color: Colors.grey[600]),
                  )
                  ),
                );
              }).toList(),
              hint: Text('Type'),
            ),
          ),
        ),
      ),
    );
  }
  Widget _createDropdownCity() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: valCity,
              onChanged: (value) {
                setState(() {
                  valCity=value;
                  print('$valCity');
                });
              },
              items: listCity.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Container(child: Text(
                    listValueCity[value],
                    style: TextStyle(color: Colors.grey[600]),
                  )
                  ),
                );
              }).toList(),
//              hint: Text('City'),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text('Filter'),
      content: SingleChildScrollView(
        child: ListBody(children: [_createDropdownType()
          ,Padding(padding: EdgeInsets.only(top: 5.0,bottom: 5.0),),
          _createDropdownCity(),],),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Done'),
          onPressed: () {
            PostsModel.city=valCity.toString();
            PostsModel.type=valType.toString();
            Navigator.of(context).pushNamedAndRemoveUntil('/controlPanel', (Route<dynamic> route) => false);

          },
        ),
      ],
    );
  }


}


//
//final _rowHeight = 100.0;
//final _borderRadius = BorderRadius.circular(_rowHeight / 2);
//class ItemList extends StatelessWidget {
//  List list;
//  static const _baseColors =
//  ColorSwatch(0xFF6AB7A8, {
//  'highlight':  Colors.white70,
//  'splash': Colors.amberAccent,
//  });
//  ItemList({this.list});
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return ListView.builder(
//        itemCount: list.length,
//        itemBuilder: (context, i) {
//          return Material(
//            color: Colors.white,
//            child: Container(
//              height: 150.0,
//              padding: const EdgeInsets.only(bottom: 4),
//              child: InkWell(
//                highlightColor: _baseColors['highlight'],
//                splashColor: _baseColors['splash'],
////                onTap:() => Navigator.of(context).push(MaterialPageRoute<Null>(
////                      builder: (BuildContext context) =>
////                          ShowData(list: list, index: i),
////                    )),
//                child: Padding(
//                  padding: EdgeInsets.all(8.0),
////                  child: GestureDetector(
////                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
////                      builder: (BuildContext context) =>
////                          ShowData(list: list, index: i),
////                    )),
//                    child: Row(
//                      children: [
//                        Divider(key: UniqueKey(),height: 3.0,color: Colors.black,),
//                        Padding(
//                          padding: EdgeInsets.all(16.0),
//                          child: (list[i]['PictureLink']==null || list[i]['PictureLink']=='')
//                          ? Icon (
//                            Icons.announcement,
//                            size: 60.0,
//                          )
//                          : Image.network(
//                            'https://the-seller20200630093320.azurewebsites.net/Images/${list[i]['PictureLink']}',
//                            height: 80.0,
//                            width: 80.0,
//                            loadingBuilder: (context,child,progress){
//                              return progress==null
//                                  ? child
//                                  : Container(child:CircularProgressIndicator(),
//                              width: 80.0,height: 80.0,);
//                            },
////                            placeholder: (c,b)=>CircularProgressIndicator(),
//                          ),
//                        ),
//                        Center(
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Text(
//                                list[i]['ToolName'],
//                                textAlign: TextAlign.center,
//                                style: TextStyle(
//                                    color: Color(0xFF13566b),
//                                  fontSize: 20.0,
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
////                              Text(
////                                list[i]['ToolDes'],
////                                textAlign: TextAlign.center,
////                                style: Theme.of(context).textTheme.bodyText1,
////                              ),
//                            ],
//                          ),
//                        ),
//                        Expanded(
//                            child: Padding(
//                              padding: EdgeInsets.only(top: 15.0),
//                              child: Align(
//                                alignment: Alignment.topRight,
//                                child: Text(
//                                  '\$${list[i]['ToolPrice']}',
//                                  textAlign: TextAlign.center,
//                                  style: TextStyle(
//                                    fontSize: 16.0
//                                  ),
//                                ),
//                              ),
//                            )
//                        ),
////                        ListTile(
////                          title: Text(list[i]['ToolName']),
////                          leading: Image.network(
////                            'https://the-seller20200630093320.azurewebsites.net/Images/${list[i]['PictureLink']}',
////                            height: 50.0,
////                            width: 50.0,
////                          ),
////                          subtitle: Text('${list[i]['ToolDes']}'),
////                          trailing: Text('\$${list[i]['ToolPrice']}'),
////                        ),
//                      ],
//                    ),
////                  ),
//                ),
//              ),
//            ),
//          );
//        });
//  }
//}
