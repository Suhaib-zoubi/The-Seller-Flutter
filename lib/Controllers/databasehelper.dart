import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {

  String serverUrl = "https://the-seller20200630093320.azurewebsites.net/UsersWS.asmx";
  static String value="0";

  Future<Object> loginData(String username,String password) async {
    String myUrl = '$serverUrl/Login?UserName=$username&Password=$password';
    http.Response response = await http.get(myUrl);
    final res= json.decode(response.body);
    _save(res["UserID"].toString());
    return res["Message"];
  }


  _save(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'UserID';
     value = userID;
    prefs.setString(key, value);
  }


   loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'UserID';
     value = prefs.get(key ) ?? 0;
    print('TEST read : $value');
  }

}