import 'package:flutter/material.dart';

//Widget representing a Post item
class PostItemWidget extends StatelessWidget {
  final int postId;
  final String postTitle;
  final VoidCallback onTapPost;

  const PostItemWidget(
      {super.key, required this.onTapPost, required this.postId, required this.postTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      //Use ListTile instead of inkwell
      child: ListTile(
        title: Text(
          'id: $postId',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          postTitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        onTap: onTapPost,
      ),
    );
  }
}
