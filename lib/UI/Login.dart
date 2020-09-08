import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';
import 'ControlPanel.dart';
import 'package:the_seller/UI/Register.dart';

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
  DatabaseHelper _databaseHelper = DatabaseHelper();
  var _isPressed;
  var _currentIndex = 0;
  var _showValidationUserNameError = false;
  var _showValidationPasswordError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelper.save("empty");
    _isPressed = false;
  }

  _updateUserNameValue(String text) {
    if (text == '' || text.isEmpty)
      setState(() {
        _showValidationUserNameError = true;
      });
    else
      setState(() {
        _showValidationUserNameError = false;
      });
  }

  _updatePasswordValue(String text) {
    if (text == '')
      setState(() {
        _showValidationPasswordError = true;
      });
    else
      setState(() {
        _showValidationPasswordError = false;
      });
  }

  void _onLogin() async {
    setState(() {
      _isPressed = true;
      result = '';
    });

    await _databaseHelper
        .loginData(
            _username.text.trim().toString(), _password.text.trim().toString())
        .then((value) {
      print('userID; ${DatabaseHelper.userId}');
      print('value= $value');
      if (value == null)
        setState(() {
          result = "Oh no! We can't connect right now!";
          _isPressed = false;
        });
      else {
        if (value["UserID"].toString() == '0') {
          setState(() {
            result = value["Message"];
            _isPressed = false;
          });
        } else {
          print('**************${value["UserID"]}*************');
          setState(() {
            _isPressed = false;
            _showValidationUserNameError = false;
            _showValidationPasswordError = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext) => ControlPanel(),
          ));
        }
      }
    });
  }

  _login(Orientation orientation) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Complete your shopping',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.all(16.0)),
                (orientation != Orientation.portrait)
                    ? _landscapeLogin()
                    : _portraitLogin()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _portraitLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          style: Theme.of(context).textTheme.display1,
          autofocus: false,
          decoration: InputDecoration(
            labelStyle: Theme.of(context).textTheme.display1,
            labelText: "User Name",
            errorText: _showValidationUserNameError
                ? 'Invalid UserName entered'
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
          onChanged: _updateUserNameValue,
          controller: _username,
        ),
        Container(
          margin: EdgeInsets.only(top: 16.0),
          child: TextField(
            style: Theme.of(context).textTheme.display1,
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: Theme.of(context).textTheme.display1,
              labelText: "Password",
              errorText: _showValidationPasswordError
                  ? 'Invalid Password entered'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            onChanged: _updatePasswordValue,
            controller: _password,
          ),
        ),
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
            onPressed: (_password.text.isEmpty || _username.text.isEmpty)
                ? null
                : _onLogin,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.all(3.0),
            child: _isPressed
                ? CircularProgressIndicator()
                : Text(
                    "$result",
                    style: TextStyle(fontSize: 19.0, color: Colors.pink),
                  ),
          ),
        ),
      ],
    );
  }

  _landscapeLogin() {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "User Name",
                errorText: _showValidationUserNameError
                    ? 'Invalid UserName entered'
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onChanged: _updateUserNameValue,
              controller: _username,
            ),
            Container(
              margin: EdgeInsets.only(top: 16.0),
              child: TextField(
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _showValidationPasswordError
                      ? 'Invalid Password entered'
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
                onChanged: _updatePasswordValue,
                controller: _password,
              ),
            ),
          ],
        )),
        Expanded(
            child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(
                  color: Colors.grey[400],
                  width: 1.0,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 50.0,
                onPressed: (_password.text.isEmpty || _username.text.isEmpty)
                    ? null
                    : _onLogin,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.all(3.0),
                child: _isPressed
                    ? CircularProgressIndicator()
                    : Text(
                        "$result",
                        style: TextStyle(fontSize: 19.0, color: Colors.pink),
                      ),
              ),
            ),
          ],
        ))
      ],
    );
  }

  @override
  build(BuildContext context) {
    tab(int index) {
      final _tab = [
        _login(MediaQuery.of(context).orientation),
        Register(),
      ];
      return _tab[index];
    }

    assert(debugCheckHasMediaQuery(context));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          _currentIndex == 0 ? 'Login' : 'Register',
          style: TextStyle(
            color: Color(0xFF13566b),
            fontSize: 30.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF13566b),
        selectedIconTheme: IconThemeData(size: 50.0),
        selectedFontSize: 15.0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.login),
              title: Text(
                'Login',
              ),
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              title: Text(
                'Register',
              ),
              icon: Icon(Icons.app_registration),
              backgroundColor: Colors.deepPurple),
        ],
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
      ),
      body: tab(_currentIndex),
    );
  }
}
