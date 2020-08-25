import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_seller/UI/Login.dart';

class DatabaseHelper {
  String serverUrl =
      "https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx";
  static String userId = "empty";

  Future<Object> loginData(String username, String password) async {
    String myUrl = '$serverUrl/Login?UserName=$username&Password=$password';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    save(res["UserID"].toString());
    return res["Message"];
  }

  Future<Map> registerData(String username, String password, String email,
      String phoneNumber) async {
    String myUrl = '$serverUrl/Register?UserName=$username&Password=$password'
        '&Email=$email&PhoneNumber=$phoneNumber&Logtit=25&Latitle=89&gender=1';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('TEST register');
    print(res["Message"]);
    return res;
  }

  /*
  https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx/GetToolListing?
  UserID=1&Distance=5000&From=1&to=10&ToolTypeID=1&ToolID=0&q=@
   */

  Future<List> getToolListing(String userId) async {
    String myUrl = '$serverUrl/GetToolListing?'
        'UserID=${userId}&Distance=5000&From=0&to=100&ToolTypeID=0&ToolID=0&q=@';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('TEST ToolData');
    print(res["ToolData"]);
    return res["ToolData"];
  }
  save(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'UserID';
    userId = userID;
    prefs.setString(key, userId);
  }

  loadData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'UserID';
    userId = prefs.get(key) ?? "empty";
    print('TEST read : $userId');
    if (userId == "empty") Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        )
    );
  }
}
