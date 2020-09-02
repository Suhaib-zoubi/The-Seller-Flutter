import 'package:flutter/material.dart';
import 'package:the_seller/Controllers/databasehelper.dart';

import './post.dart';
import 'modelsPost.dart';

class Posts extends StatefulWidget {
  const Posts({
    Key key,
  }) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final scrollController = ScrollController();
  PostsModel posts;
  DatabaseHelper databaseHelper = DatabaseHelper();
  var delay = 0.0;

  @override
  void initState() {
    posts = PostsModel();
    databaseHelper.loadData(context);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        posts.loadMore();
      }
    });
    super.initState();
  }

  _delay() async {
    await Future.delayed(Duration(seconds: 0), () {
      setState(() {
        delay = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: posts.stream,
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (!_snapshot.hasData) {
          print('connectivityResult :: ${DatabaseHelper.connectivityResult}');
          return Center(
              child: (!DatabaseHelper.connectivityResult)
                  ? FutureBuilder(
                      builder: (c, v) {
                        _delay();
                        return Opacity(
                          opacity: delay,
                          child: Center(
                              child: Container(
                                height: 300,
                                margin: EdgeInsets.all(16.0),
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Color(0xFF912D2D),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 180.0,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Oh no! We can't connect right now!",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                          ),
                        );
                      },
                    )
                  : CircularProgressIndicator()
          );
        } else if (!DatabaseHelper.connectivityResult) {
          return Text('No Data');
        } else {
          return RefreshIndicator(
            onRefresh: posts.refresh,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              controller: scrollController,
              separatorBuilder: (context, index) => Divider(),
              itemCount: _snapshot.data.length + 1,
              itemBuilder: (BuildContext _context, int index) {
                if (index < _snapshot.data.length) {
                  return Post(post: _snapshot.data[index]);
                } else if (posts.hasMore) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('nothing more to load!')),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
