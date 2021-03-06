import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

class AddProduct extends StatefulWidget {
  final String _product_toolId;
  final String _product_name;
  final String _product_desc;
  final String _product_price;
  String _product_pictureLink;
  final String _product_toolType;
  final String _product_toolCity;

  AddProduct(
      this._product_toolId,
      this._product_name,
      this._product_desc,
      this._product_price,
      this._product_pictureLink,
      this._product_toolType,
      this._product_toolCity);

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
  TextEditingController _productName;
  TextEditingController _productDesc;
  TextEditingController _productPrice;
  final Random random = Random();
  String tempToolID = '';
  int valType;
  var valCity;
  var imageText = 'No Image';
  var isPressed = false;
  var _formKey = GlobalKey<FormState>();
  var isErrorType = false;
  var isErrorCity = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.loadData(context);
    _productName = TextEditingController(text: widget._product_name);
    _productDesc = TextEditingController(text: widget._product_desc);
    _productPrice = TextEditingController(text: widget._product_price);
    String diceRoll = '${random.nextInt(70000000) + 5000}';
    tempToolID = '${DatabaseHelper.userId}000000$diceRoll';
    setState(() {
      if (widget._product_toolId != null) if (widget._product_toolType !=
              null ||
          widget._product_toolType != ' ')
        valType = int.parse(widget._product_toolType) - 1;
      if (widget._product_toolCity != null) if (widget._product_toolCity !=
              null ||
          widget._product_toolCity != ' ')
        valCity = int.parse(widget._product_toolCity) - 1;
    });
    print('valType $valType');
  }

  picker() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);
    if (img != null) {
      setState(() {
        isPressed = true;
      });
      image = img;
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      if (widget._product_toolId == null) {
        print('ifStatment');
        await databaseHelper.uploadImage(base64Image, tempToolID).then((value) {
          setState(() {
            isPressed = false;
            if (value['type'] == 'error')
              imageText = 'Please select Png format';
            else if (value['type'] == 'Png' || value['type'] == 'error')
              imageText = 'No Image';
            else
              imageText = 'Please select Png format';
          });
        });
        setState(() {});
      } else {
        print('_pictureLink-1 ${widget._product_pictureLink}');
        await databaseHelper.uploadImage(base64Image, tempToolID).then((value) {
          print('_pictureLinkValue ${value['PicPath']}');
          print('cond ${value['type'] == 'Png'}');
          setState(() {
            isPressed = false;

            if (value['type'] == 'error')
              imageText = 'Please select Png format';
            else if (value['type'] == 'Png') {
              widget._product_pictureLink = value['PicPath'];
              imageText = 'No Image';
            } else
              imageText = 'Please select Png format';
          });
        });
      }
    }
  }

  _add() async {
    await databaseHelper
        .addProducts(
            DatabaseHelper.userId,
            _productName.text,
            _productDesc.text,
            _productPrice.text,
            (valType + 1).toString(),
            tempToolID,
            (valCity + 1).toString())
        .then((value) {
      Navigator.of(context).pop();
    });
  }

  _update() async {
    Map map;
    map = {
      'ToolName': _productName.text,
      'ToolDes': _productDesc.text,
      'ToolPrice': _productPrice.text,
      'PictureLink': widget._product_pictureLink,
      'ToolTypeID': (valType + 1).toString(),
      'ToolCity': (valCity + 1).toString(),
    };
    print('_pictureLink ${widget._product_pictureLink}');
    await databaseHelper
        .updateProduct(
            widget._product_toolId,
            _productName.text,
            _productDesc.text,
            _productPrice.text,
            (valType + 1).toString(),
            widget._product_pictureLink,
            (valCity + 1).toString())
        .then((value) {
      Navigator.of(context).pop(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          (widget._product_toolId == null) ? 'Add Product' : 'Edit Product',
          style: TextStyle(
            color: Color(0xFF13566b),
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15.0),
          children: [
            TextFormField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _productName,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (String value) {
                if (value.isEmpty)
                  return 'Please enter product Name';
                else
                  return null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            TextFormField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _productDesc,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (String value) {
                if (value.isEmpty)
                  return 'Please enter Description';
                else
                  return null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            TextFormField(
              style: TextStyle(fontSize: 15.0, color: Colors.black),
              controller: _productPrice,
              decoration: InputDecoration(labelText: 'Price'),
              validator: (String value) {
                if (value.isEmpty)
                  return 'Please enter Price';
                else if (!RegExp(r"^\d+(\.\d+)*$").hasMatch(value))
                  return 'Allow just numbers and dot ex: 25.75 or 25';
                else
                  return null;
              },
              keyboardType: TextInputType.phone,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
            ),
            Row(
              children: [
                Expanded(child: _createDropdownType()),
                Padding(
                  padding: EdgeInsets.only(right: 10.0, left: 10.0),
                ),
                Expanded(
                  child: _createDropdownCity(),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Container(
              alignment: Alignment.center,
              width: 200.0,
              child: RaisedButton(
                color: Colors.grey[100],
                textColor: Color(0xFF13566b),
                onPressed: () {
                  setState(() {
                    if (_formKey.currentState.validate() &&
                        isPressed == false &&
                        valCity != null &&
                        valType != null) if (widget._product_toolId == null)
                      _add();
                    else
                      _update();
                  });
                },
                child: widget._product_toolId == null
                    ? new Text(
                        '          Add          ',
                        style: TextStyle(fontSize: 20.0),
                      )
                    : new Text('          Update          '),
                elevation: 7.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Container(
              width: 200.0,
              height: 200.0,
              child: (isPressed)
                  ? Container(
                      alignment: Alignment.center,
                      width: 60.0,
                      height: 60.0,
                      child: CircularProgressIndicator())
                  : widget._product_toolId == null
                      ? Center(
                          child: (image == null ||
                                  imageText == 'Please select Png format')
                              ? Text('$imageText')
                              : Image.file(image),
                        )
                      : Center(
                          child: (imageText == 'Please select Png format')
                              ? Text('$imageText')
                              : (widget._product_pictureLink == '0')
                                  ? Text('$imageText')
                                  : Image.network(
                                      'https://the-seller20200630093320.azurewebsites.net/Images/${widget._product_pictureLink}'),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: picker,
        backgroundColor: Colors.grey[100],
        child: Icon(Icons.add_photo_alternate, color: Color(0xFF13566b)),
      ),
    );
  }

  List _listType = [
    0,
    1,
    2,
  ];
  List _listValueType = ['Car', 'Phones', 'Clothes'];
  List _listCity = [
    0,
    1,
    2,
  ];
  List _listValueCity = ['Riyadh', 'Dammam', 'Jedah'];

  Widget _createDropdownType() {
    return Container(
      alignment: Alignment.center,
      width: 100.0,
      margin: EdgeInsets.only(top: 16.0),
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
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              value: valType,
              onChanged: (value) {
                setState(() {
                  valType = value;
                  print('$valType');
                });
              },
              validator: (value) => value == null ? 'field required' : null,
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
              style: Theme.of(context).textTheme.title,
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
      width: 100.0,
      margin: EdgeInsets.only(top: 16.0),
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
            child: DropdownButtonFormField(
              value: valCity,
              onChanged: (value) {
                setState(() {
                  valCity = value;
                  print('$valCity');
                });
              },
              validator: (value) => value == null ? 'field required' : null,
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
              style: Theme.of(context).textTheme.title,
              hint: Text('City'),
            ),
          ),
        ),
      ),
    );
  }
}
