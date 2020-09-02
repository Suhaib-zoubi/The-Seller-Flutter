import 'package:flutter/material.dart';
import 'package:the_seller/UI/ShowData.dart';

import 'modelsPost.dart';


class Post extends StatelessWidget {
  final PostModel post;
  static const _baseColors =
  ColorSwatch(0xFF6AB7A8, {
    'highlight':  Colors.white70,
    'splash': Colors.amberAccent,
  });
  const Post({
    Key key,
    @required this.post,
  })  : assert(post != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(

      highlightColor: _baseColors['highlight'],
      splashColor: _baseColors['splash'],
      onTap:() => Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ShowData(post))),
      child: ListTile(
        leading: (post.pictureLink==null || post.pictureLink =='')
            ? Container(child: Icon(Icons.ac_unit),width: 60.0,height: 60.0,)
            :Image.network(
          'https://the-seller20200630093320.azurewebsites.net/Images/${post.pictureLink}',
          width: 60.0,
          height: 60.0,
          loadingBuilder: (context,child,progress){
            return progress==null
                ? child
                : CircularProgressIndicator();
          },
        ),
        title: Text(post.toolName),
      ),
    );
  }
}
