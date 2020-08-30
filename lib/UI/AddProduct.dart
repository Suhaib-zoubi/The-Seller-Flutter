import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

class AddProduct extends StatefulWidget {
  String _product_toolId;
  String _product_name;
  String _product_desc;
  String _product_price;
  String _product_pictureLink;

  AddProduct(this._product_toolId, this._product_name, this._product_desc,
      this._product_price, this._product_pictureLink);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddProductState();
  }
}

class AddProductState extends State<AddProduct> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  File image;
  var path = '';
  TextEditingController _product_name;
  TextEditingController _product_desc;
  TextEditingController _product_price;
  final Random random = Random();
  String tempToolID = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.loadData(context);
    _product_name = TextEditingController(text: widget._product_name);
    _product_desc = TextEditingController(text: widget._product_desc);
    _product_price = TextEditingController(text: widget._product_price);
    String diceRoll = '${random.nextInt(70000000) + 5000}';
    tempToolID = '${DatabaseHelper.userId}000000$diceRoll';
  }

  picker() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    if (img != null) {
      image = img;
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      if (widget._product_toolId == null) {
        print('ifStatment');
        await databaseHelper.UploadImage(base64Image, tempToolID);
        setState(() {});
      } else {
        print('_pictureLink-1 ${widget._product_pictureLink}');
        await databaseHelper.UploadImage(base64Image, tempToolID).then((value) {
          setState(() {
            print('_pictureLinkValue ${value['PicPath']}');
            widget._product_pictureLink = value['PicPath'];
          });
        });

        print('elseStatement');
//        print('_pictureLinkDatabase ${databaseHelper.UploadImage(base64Image, tempToolID)}');
        print('_pictureLink0 ${widget._product_pictureLink}');
      }
    }
  }

  _Add() async {
    await databaseHelper.AddTools(DatabaseHelper.userId, _product_name.text,
            _product_desc.text, _product_price.text, '1', tempToolID)
        .then((value) {
      Navigator.of(context).pop();
    });
  }

  _Update() async {
    print('_pictureLink ${widget._product_pictureLink}');
    await databaseHelper.UpdateTool(
            widget._product_toolId,
            _product_name.text,
            _product_desc.text,
            _product_price.text,
            '1',
            widget._product_pictureLink)
        .then((value) {
      Navigator.of(context).pop();
    });
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
        body: ListView(
          padding: EdgeInsets.all(15.0),
          children: [
            TextField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _product_name,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            TextField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _product_desc,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            TextField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _product_price,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Container(
              child: widget._product_toolId == null
                  ? Center(
                      child:
                          image == null ? Text('No Image') : Image.file(image),
                    )
                  : Center(
                      child: widget._product_pictureLink == '0'
                          ? Text('No Image')
                          : Image.network(
                              'https://the-seller20200630093320.azurewebsites.net/Images/${widget._product_pictureLink}'),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            RaisedButton(
              color: Color(0xFF104454),
              textColor: Colors.white,
              onPressed: () {
                if (widget._product_toolId == null)
                  _Add();
                else
                  _Update();
              },
              child: widget._product_toolId == null
                  ? new Text('Add')
                  : new Text('Update'),
              elevation: 7.0,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: picker,
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }
}
