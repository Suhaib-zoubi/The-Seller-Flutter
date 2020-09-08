import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_seller/UI/Login.dart';

class DatabaseHelper {
  String host = 'the-seller20200630093320.azurewebsites.net';
  String webService = '/UsersWS.asmx';
  String serverUrl =
      "https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx";
  static String userId;

  static var connectivityResult = false;

  final HttpClient _httpClient = HttpClient();
  static var hasMore;
  static var myProducts; //to know when i have zero product to display 'Add your first product' in MyProducts.dart

  Future<Map> loginData(String username, String password) async {
    try {
      final uri = Uri.https('$host', '$webService/Login',
          {'UserName': username, 'Password': password});
      final res = await _getJson(uri);
      print('urlLogin $uri');
      if (res == null) {
        print('Error retrieving data.');
        return null;
      }
      save(res["UserID"].toString());
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> registerData(String username, String password, String email,
      String phoneNumber, String gender) async {
    try {
      final uri = Uri.https('$host', '$webService/Register', {
        'UserName': username,
        'Password': password,
        'Email': email,
        'PhoneNumber': phoneNumber,
        'Logtit': '25',
        'Latitle': '89',
        // Logtit and Latitle not active until now
        'gender': gender
      });
      final res = await _getJson(uri);
      print('urRegister $uri');
      if (res == null) return null;
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map>> getProductListing(
      String userId, String toolTypeID, String toolCity) async {
    try {
      final uri = Uri.https('the-seller20200630093320.azurewebsites.net',
          '/UsersWS.asmx/GetToolListing', {
        'UserID': userId,
        'ToolTypeID': toolTypeID,
        'ToolID': '0',
        'q': '@',
        // 'ToolID': '0' mean get all products and 'q': '@' mean not there any specification in the search
        'ToolCity': toolCity
      });
      final res = await _getJson(uri);
      print('urlGetToolListing $uri');
      if (res == null) {
        print('Error retrieving data.');
        return null;
      }

      List toolData = res["ToolData"];
      hasMore = toolData.length;
      if (toolData.length == 1) {
        List<Map> list;
        Map map = {
          "ToolName": res["ToolData"][0]['ToolName'],
          "PictureLink": res["ToolData"][0]['ToolName'],
          "ToolDes": res["ToolData"][0]['ToolName'],
          "ToolPrice": res["ToolData"][0]['ToolName'],
          "DateAdd": res["ToolData"][0]['ToolName'],
        };
        list = [map];
        return Future.delayed(Duration(seconds: 1), () {
          return list;
        });
      }
      if (toolData.length == 0)
        return Future.delayed(Duration(seconds: 1), () {
          return List<Map>.generate(1, (int index) {
            return {
              "ToolName": '',
              "PictureLink": '',
              "ToolDes": '',
              "ToolPrice": '',
              "DateAdd": '0',
            };
          });
        });

      return Future.delayed(Duration(seconds: 1), () {
        return List<Map>.generate(toolData.length, (int index) {
          print('generate ${toolData.length} and $index');
          return {
            "ToolName": res["ToolData"][index]['ToolName'],
            "PictureLink": '${res["ToolData"][index]['PictureLink']}',
            "ToolDes": '${res["ToolData"][index]['ToolDes']}',
            "ToolPrice": '${res["ToolData"][index]['ToolPrice']}',
            "DateAdd": '${res["ToolData"][index]['DateAdd']}',
          };
        });
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List> getMyProducts(String userId) async {
    try {
      String myUrl = '$serverUrl/GetMyTool?UserID=$userId';
      http.Response response = await http.get(myUrl);
      final res = json.decode(response.body);
      List list = res["ToolData"];
      if (list.length == 0)
        myProducts = 0;
      else
        myProducts = 1;
      return res["ToolData"];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> uploadImage(String image, String tempToolID) async {
    String myUrl = '$serverUrl/UploadImage';
    try {
      http.Response response = await http
          .post(myUrl, body: {"image": image, "TempToolID": tempToolID});
      var res = json.decode(response.body);
      print('response: $res');
      return res;
    } catch (e) {
      print(e);
      return {'IsAdded': '', 'PicPath': '', 'type': 'error'};
    }
  }

  addProducts(String userID, String toolName, String toolDes, String toolPrice,
      String toolTypeID, String tempToolID, String toolCity) async {
    try {
      String myUrl = '$serverUrl/AddTools?'
          'UserID=$userId&ToolName=$toolName&ToolDes=$toolDes&ToolPrice=$toolPrice'
          '&ToolTypeID=$toolTypeID&TempToolID=$tempToolID&ToolCity=$toolCity';
      http.Response response = await http.get(myUrl);
      final res = json.decode(response.body);
      print('AddTools: ${res["IsAdded"]}');
    } catch (e) {
      print(e);
      return null;
    }
  }

  updateProduct(
      String toolID,
      String toolName,
      String toolDes,
      String toolPrice,
      String toolTypeID,
      String pictureLink,
      String toolCity) async {
    try {
      String myUrl = '$serverUrl/UpdateTool?'
          'ToolID=$toolID&ToolName=$toolName&ToolDes=$toolDes&ToolPrice=$toolPrice'
          '&ToolTypeID=$toolTypeID&PicPath=$pictureLink&ToolCity=$toolCity';
      http.Response response = await http.get(myUrl);
      final res = json.decode(response.body);
      print('url: $myUrl');
      print('UpdateTool: ${res["IsUpdate"]}');
    } catch (e) {
      print(e);
      return null;
    }
  }

  deleteProduct(String toolID) async {
    try {
      String myUrl = '$serverUrl/DeleteTool?'
          'ToolID=$toolID';
      http.Response response = await http.get(myUrl);
      final res = json.decode(response.body);
      print('url: $myUrl');
      print('DeleteTool: ${res["IsDelete"]}');
    } catch (e) {
      print(e);
      return null;
    }
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
    connectivityResult = await _checkInternetConnectivity();
    final key = 'UserID';
    print('TEST connectivityResult : $connectivityResult');

    userId = await prefs.get(key) ?? "empty";
    if (userId == "empty" || userId == '0')
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
