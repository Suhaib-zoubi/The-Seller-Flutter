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

enum PopMenu { logOut }

class ControlPanelState extends State<ControlPanel> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<RefreshIndicatorState> refreshKey;
  var isRefresh = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.loadData(context);
    refreshKey = GlobalKey<RefreshIndicatorState>();
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
              onSelected: (result) {
                DatabaseHelper databaseHelper = DatabaseHelper();
                databaseHelper.save("empty");
                databaseHelper.loadData(context); //Logout
              },
              itemBuilder: (context) => <PopupMenuEntry<PopMenu>>[
                    const PopupMenuItem<PopMenu>(
                        value: PopMenu.logOut,
                        child: Text(
                          'Log out',
                        ))
                  ])
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 50.0, right: 50.0, bottom: 10.0),
        width: 200.0,
        child: RaisedButton(
          child: Text(
            'My Products',
            style: TextStyle(
              color: Color(0xFF13566b),
            ),
          ),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext) => MyProducts())),
          color: Colors.grey[100],
        ),
        color: Colors.white,
      ),
      body: Posts(),
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
  var _valType = 0;
  List _listType = [
    0,
    1,
    2,
    3,
  ];
  List _listValueType = ['All Types', 'Car', 'Phones', 'Clothes'];
  var _valCity = 0;
  List _listCity = [
    0,
    1,
    2,
    3,
  ];
  List _listValueCity = ['All Cities', 'Riyadh', 'Dammam', 'Jedah'];

  Widget _createDropdownType() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: _valType,
              onChanged: (value) {
                setState(() {
                  _valType = value;
                  print('$_valType');
                });
              },
              items: _listType.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Container(
                      child: Text(
                    _listValueType[value],
                    style: TextStyle(color: Colors.grey[600]),
                  )),
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
              value: _valCity,
              onChanged: (value) {
                setState(() {
                  _valCity = value;
                  print('$_valCity');
                });
              },
              items: _listCity.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Container(
                      child: Text(
                    _listValueCity[value],
                    style: TextStyle(color: Colors.grey[600]),
                  )),
                );
              }).toList(),
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
        child: ListBody(
          children: [
            _createDropdownType(),
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            _createDropdownCity(),
          ],
        ),
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
            PostsModel.city = _valCity.toString();
            PostsModel.type = _valType.toString();
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/controlPanel', (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}
