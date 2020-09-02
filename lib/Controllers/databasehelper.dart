import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_seller/UI/Login.dart';

class DatabaseHelper {
  String host='https://the-seller20200630093320.azurewebsites.net/';
  String webService='UsersWS.asmx';
  String serverUrl =
      "https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx";
  static String userId ;
  static var connectivityResult=false  ;
  final HttpClient _httpClient = HttpClient();

  Future<Map> loginData(String username, String password) async {
    final uri = Uri.https('$host', '$webService/Login',
        {'UserName': username, 'Password': password});
    final res = await _getJson(uri);
    print('urlLogin $uri');
    if (res == null ) {
      print('Error retrieving data.');
      return null;
    }
    save(res["UserID"].toString());
    print('urlLogin $res');
    return res;
  }

  Future<Map> registerData(String username, String password, String email,
      String phoneNumber, String gender) async {
    String myUrl = '$serverUrl/Register?UserName=$username&Password=$password'
        '&Email=$email&PhoneNumber=$phoneNumber&Logtit=25&Latitle=89&gender=$gender';
    http.Response response = await http.get(myUrl);
    final res = json.decode(response.body);
    print('TEST register');
    print(res["Message"]);
    print('urRegister $myUrl');
    return res;
  }

  Future<List<Map>> getToolListing(String userId) async {
    final uri = Uri.https('the-seller20200630093320.azurewebsites.net', '/UsersWS.asmx/GetToolListing',
        {'UserID': userId, 'Distance': '5000', 'From': '0', 'to': '100',
          'ToolTypeID': '0', 'ToolID': '0', 'q': '@' });
    final res = await _getJson(uri);
    print('urlGetToolListing $res');
    if (res == null ) {
      print('Error retrieving data.');
      return null;
    }
    print('TEST url: $uri');
    print(res["ToolData"]);
    print('ToolName ${res["ToolData"][1]['ToolName']}');
    return Future.delayed(Duration(seconds: 1), () {
      return List<Map>.generate(10, (int index) {
        return {
          "ToolName": res["ToolData"][index]['ToolName'],
          "PictureLink": '${res["ToolData"][index]['PictureLink']}',
          "ToolDes": '${res["ToolData"][index]['ToolDes']}',
          "ToolPrice": '${res["ToolData"][index]['ToolPrice']}',
          "DateAdd": '${res["ToolData"][index]['DateAdd']}',
        };
      });
    });
//  return res["ToolData"];
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

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
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

    connectivityResult=await _checkInternetConnectivity();
     print('TEST connectivityResult : $connectivityResult');
     userId = await prefs.get(key) ?? "empty";
    print('TEST read : $userId');
    if (userId == "empty" ||userId=='0')
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Login(),
      ));
  }
  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print("You're not connected to a network");
      return false;
    } else {
      print("You're connected to a network");
      return true;
    }
  }
}
