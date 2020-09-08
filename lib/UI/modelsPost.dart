import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

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
        .getProductListing(prefs.get(key) ?? "empty", type, city)
        .then((postsData) async {
      if (postsData == null) {
        hasData = false;
      } else
        hasData = true;
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = (_data.length < DatabaseHelper.hasMore);
      _controller.add(_data);
    });
  }
}
