import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }

  Future<Object> getData(String key,String username,String password) async {
    String myUrl = 'https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx/Login?UserName=$username&Password=$password';
    http.Response response = await http.get(myUrl);
    final res= json.decode(response.body);
    return res[key];
  }

}

class LoginState extends State<Login> {

  final TextEditingController _username=new TextEditingController();
  final TextEditingController _password=new TextEditingController();
  var result="hello";
  Login login = new Login();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: Scaffold (
          appBar: AppBar (
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
                       style: TextStyle(color: Colors.black,),
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
                         style: TextStyle(color: Colors.black,),
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
                     child: FlatButton(
                       color: Color(0xFF104454),
                       textColor: Colors.white,
                       onPressed: ()=>_onLogin(),
                       child: new Text('Login'),
                     ),
                   )],
                 ),

               ),
               Center(
                 child: Container(
                   margin: EdgeInsets.only(top: 20.0),
                   padding: EdgeInsets.all(3.0),

                   child: Text(
                     "$result",
                     style: TextStyle(fontSize: 19.0,color: Colors.pink),

                   ),
                 ),
               )
             ],
           ),
         ),
        )
    ) ;
  }

  void _onLogin() async{
    print(_username.text.trim().toString());
    print(_password.text.trim().toString());
    Object data = await (login.getData("Message",_username.text.trim().toString(),_password.text.trim().toString()));
    setState(() {
      result=data;
      print('**************$result*************');
    });

  }
   onLogin(BuildContext context)  {
//    setState(() async{
//      result = await (login.getData("Message",_username.text.trim().toString(),_password.text.trim().toString()));
//      print('**************$result*************');
      return showDialog<Null>(
        context: context,
        barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Login result'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('hi'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
//    });
  }

}

