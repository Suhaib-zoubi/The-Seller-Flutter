import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

/// Example data as it might be returned by an external service
/// ...this is often a `Map` representing `JSON` or a `FireStore` document
final HttpClient _httpClient = HttpClient();

Future<Map<String, dynamic>> _getJson(Uri uri) async {
  try {
    final httpRequest = await _httpClient.getUrl(uri);
    final httpResponse = await httpRequest.close();
    if (httpResponse.statusCode != HttpStatus.OK) {
      return null;
    }
    // The response is sent as a Stream of bytes that we need to convert to a
    // `String`.
    final responseBody = await httpResponse.transform(utf8.decoder).join();
    // Finally, the string is parsed into a JSON object.
    return json.decode(responseBody);
  } on Exception catch (e) {
    print('$e');
    return null;
  }
}

/// PostModel has a constructor that can handle the `Map` data
/// ...from the server.
class PostModel {
  String toolName;
  String pictureLink;
  String toolDes;
  String toolPrice;
  String dateAdd;

  PostModel(
      {this.toolName,
      this.pictureLink,
      this.toolDes,
      this.toolPrice,
      this.dateAdd});

  factory PostModel.fromServerMap(Map data) {
    return PostModel(
        toolName: data['ToolName'],
        pictureLink: data['PictureLink'],
        toolDes: data['ToolDes'],
        toolPrice: data['ToolPrice'],
        dateAdd: data['DateAdd']);
  }
}

/// PostsModel controls a `Stream` of posts and handles
/// ...refreshing data and loading more posts
class PostsModel {
  Stream<List<PostModel>> stream;
  bool hasMore;
  static String type = '0';
  static String city = '0';
  bool _isLoading;
  List<Map> _data;
  StreamController<List<Map>> _controller;
  DatabaseHelper databaseHelper = DatabaseHelper();
  final key = 'UserID';
  var hasData = true;

  PostsModel() {
    _data = List<Map>();
    _controller = StreamController<List<Map>>.broadcast();
    _isLoading = false;
    print('UserrID ${DatabaseHelper.userId}');
    stream = _controller.stream.map((List<Map> postsData) {
      return postsData.map((Map postData) {
        return PostModel.fromServerMap(postData);
      }).toList();
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (clearCachedData) {
      _data = List<Map>();
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return databaseHelper
        .getToolListing(prefs.get(key) ?? "empty",type,city)
        .then((postsData) async {
      if (postsData == null) {
        hasData = false;
      } else
        hasData = true;
      print('postsData $postsData');
      print('DatabaseHelper.userId ${DatabaseHelper.userId}');
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = (_data.length < DatabaseHelper.hasMore);
      _controller.add(_data);
    });
  }
}
