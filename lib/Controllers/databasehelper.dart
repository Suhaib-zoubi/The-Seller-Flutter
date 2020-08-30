import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_seller/UI/Login.dart';
import 'package:xml_parser/xml_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class DatabaseHelper {
  String serverUrl =
      "https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx";
  static String userId = "empty";
  static String pickPath = "";

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

  Future<List> getToolListing(String userId) async {
    String myUrl = '$serverUrl/GetToolListing?'
        'UserID=$userId&Distance=5000&From=0&to=100&ToolTypeID=0&ToolID=0&q=@';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('TEST ToolData');
    print(res["ToolData"]);
    return res["ToolData"];
  }

  Future<List> getMyTools(String userId) async {
    String myUrl = '$serverUrl/GetMyTool?UserID=$userId';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('TEST ToolData');
    print(res["ToolData"]);
    return res["ToolData"];
  }

  Future<Map> UploadImage(String image, String tempToolID) async {
    String myUrl = '$serverUrl/UploadImage';
    http.Response response = await http
        .post(myUrl, body: {"image": image, "TempToolID": tempToolID});
    var res = json.decode(response.body);

    print('response: $res');
    return res;
  }

  AddTools(String userID, String toolName, String toolDes, String toolPrice,
      String toolTypeID,
      String tempToolID) async {
    String myUrl = '$serverUrl/AddTools?'
        'UserID=$userId&ToolName=$toolName&ToolDes=$toolDes&ToolPrice=$toolPrice&ToolTypeID=$toolTypeID&TempToolID=$tempToolID';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('url: $myUrl');
    print('AddTools: ${res["IsAdded"]}');
  }

  UpdateTool(String toolID, String toolName, String toolDes, String toolPrice,
      String toolTypeID, String pictureLink) async {
    String myUrl = '$serverUrl/UpdateTool?'
        'ToolID=$toolID&ToolName=$toolName&ToolDes=$toolDes&ToolPrice=$toolPrice&ToolTypeID=$toolTypeID&PicPath=$pictureLink';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('url: $myUrl');
    print('UpdateTool: ${res["IsUpdate"]}');
  }

  DeleteTool(String toolID) async {
    String myUrl = '$serverUrl/DeleteTool?'
        'ToolID=$toolID';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('url: $myUrl');
    print('DeleteTool: ${res["IsDelete"]}');
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
    if (userId == "empty")
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Login(),
      ));
  }
}
