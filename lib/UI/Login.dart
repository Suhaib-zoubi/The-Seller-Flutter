import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final TextEditingController _username = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  var result = "";
  DatabaseHelper databaseHelper = DatabaseHelper();
  var isPressed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper.save("empty");
    isPressed = false;
  }

  void _onLogin() async {
    setState(() {
      isPressed = true;
      result = '';
    });
    print(_username.text.trim().toString());
    print(_password.text.trim().toString());

    await databaseHelper
        .loginData(
            _username.text.trim().toString(), _password.text.trim().toString())
        .then((value) {
      if (DatabaseHelper.userId == "0") {
        setState(() {
          isPressed = false;
          result = value;
          print('**************$result*************');
          print('**************${DatabaseHelper.userId}*************');
        });
        print('here');
      } else {
        setState(() {
          isPressed = false;
        });
        Navigator.pushReplacementNamed(context, '/controlPanel');
        print('here2');
        print(DatabaseHelper.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      width: 300.0,
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(3.0),
                      child: RaisedButton(
                        color: Color(0xFF104454),
                        textColor: Colors.white,
                        onPressed: () => _onLogin(),
                        child: new Text('Login'),
                        elevation: 7.0,
                      ),
                    ),
                    Container(
                      width: 300.0,
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(3.0),
                      child: RaisedButton(
                        color: Color(0xFF104454),
                        textColor: Colors.white,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: new Text('Register'),
                        elevation: 7.0,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.all(3.0),
                  child: isPressed
                      ? CircularProgressIndicator()
                      : Text(
                          "$result",
                          style: TextStyle(fontSize: 19.0, color: Colors.pink),
                        ),
                ),
              )
            ],
          ),
        ));
  }
}
