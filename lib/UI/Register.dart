import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  final TextEditingController _phoneNumber= new TextEditingController();
  final TextEditingController _email= new TextEditingController();
  var result = "";
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void _onLogin() async {
    print(_username.text.trim().toString());
    print(_password.text.trim().toString());
     await (databaseHelper.registerData(
        _username.text.trim().toString(), _password.text.trim().toString()
        ,_email.text.trim().toString(),_phoneNumber.text.trim().toString()).then((value) {
       print(value["IsAdded"]);
       if (value["IsAdded"]==0){
        setState(() {
          print('**************${value["Message"]}*************');
          result = value["Message"];
        });
      } else Navigator.of(context).pop();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF104454),
            title: Text("The Seller"),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                Image.asset(
                  'images/back_login.jpg',
                  height: 256.0,
                  width: 300.0,
                  fit: BoxFit.fill,
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Color(0xFF13566b)),
                          hintText: "Enter your name",
                          labelText: "User Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                        controller: _username,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color(0xFF13566b)),
                            hintText: "Enter your password",
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          controller: _password,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color(0xFF13566b)),
                            hintText: "Enter your Phone number",
                            labelText: "Phone number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          controller: _phoneNumber,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color(0xFF13566b)),
                            hintText: "Enter your email",
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Container(
                        width: 300.0,
                        margin: EdgeInsets.only(top: 20.0),
                        padding: EdgeInsets.all(3.0),
                        child: FlatButton(
                          color: Color(0xFF104454),
                          textColor: Colors.white,
                          onPressed: () => _onLogin(),
                          child: new Text('Login'),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      "$result",
                      style: TextStyle(fontSize: 19.0, color: Colors.pink),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
