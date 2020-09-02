import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'package:the_seller/UI/ControlPanel.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
   TextEditingController _username;
   TextEditingController _password ;
   TextEditingController _email;
   TextEditingController _phoneNumber;
   var _formKey= GlobalKey<FormState>();
   bool enable= false;
  var result = "";
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _email = new TextEditingController();
    _phoneNumber = new TextEditingController();
    setState(() {
      _username = new TextEditingController();
      _password = new TextEditingController();
    });
  }
@override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    enable=(_password.text.trim().isEmpty || _username.text.trim().isEmpty);

}
  void _onRegister() async {
    print(_username.text.trim().toString());
    print(_password.text.trim().toString());
    await (databaseHelper.registerData(
        _username.text.trim().toString(), _password.text.trim().toString()
        , _email.text.trim().toString(), _phoneNumber.text.trim().toString(),val.toString())
        .then((value) async {
      print(value["IsAdded"]);
      if (value["IsAdded"] == 0) {
        setState(() {
          print('**************${value["Message"]}*************');
          result = value["Message"];
        });
      } else {
        await databaseHelper
            .loginData(
            _username.text.trim().toString(), _password.text.trim().toString())
            .then((value) {
          print('**************${value["UserID"]}*************');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext) => ControlPanel(),
          ));
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                children: <Widget>[
            Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
            TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            validator: (String value){
              if (value.isEmpty)
                return 'Please enter user name';
              else return null;
            },
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.grey[600]),
              labelText: "User Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
            controller: _username,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: TextFormField(
              style: TextStyle(
                color: Colors.black,
              ),
              autofocus: false,
              obscureText: true,
              validator: (String value){
                if (value.isEmpty)
                  return 'Please enter password';
                else if (value.length<6)
                  return 'Must be at least 6 character';
                else return null;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey[600]),
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
            child: TextFormField(
              style: TextStyle(
                color: Colors.black,
              ),
              validator: (String value){
                if (value.isEmpty)
                  return 'Please enter phone number';
                else if(!RegExp(r"^(?:[+0]9)?[0-9]{10}$").hasMatch(value))
                  return 'Please valid enter phone number';
                else return null;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey[600]),
                labelText: "Phone number",
                hintText: 'ex: 0511234567',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              controller: _phoneNumber,
              keyboardType: TextInputType.phone,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: TextFormField(
              style: TextStyle(
                color: Colors.black,
              ),
              validator: (String value){
                if (value.isEmpty)
                  return 'Please enter email';
                else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                  return 'Please valid enter email';
                  else return null;
              },
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey[600]),
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
          ),

                Padding(padding: EdgeInsets.all(16.0)),
                _createDropdown(),
                Padding(padding: EdgeInsets.all(16.0)),
                Container(
            decoration: BoxDecoration(
              // This sets the color of the [DropdownButton] itself
              color: Colors.grey[50],
              border: Border.all(
                color: Colors.grey[400],
                width: 1.0,
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward),
              iconSize: 50.0,
              onPressed: (){
                setState(() {
                  if (_formKey.currentState.validate())
                      _onRegister();
                });
              },
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
    ],
    ),
    ),
        ));
  }

  var val=0;
   List list= [
     0,
     1
   ];
   List listValue= [
     'Female',
     'Male'
   ];
   Widget _createDropdown() {
     return Container(
       margin: EdgeInsets.only(top: 16.0),
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
               hint: Text('Gender'),
               value: val,
               onChanged: (value) {
                 setState(() {
                   val=value;
                   print('$val');
                 });
               },
               items: list.map((value) {
                 return DropdownMenuItem(
                   value: value,
                   child: Container(child: Text(
                       listValue[value],
                     style: TextStyle(color: Colors.grey[600]),
                   )
                   ),
                 );
               }).toList(),
               style: Theme.of(context).textTheme.title,
             ),
           ),
         ),
       ),
     );
   }



}
