import 'dart:convert';
import 'package:dev_assignment/data/entity/post.dart';
import 'package:dev_assignment/state/poststate.dart';
import 'package:http/http.dart' as http;


//Repository to Perform data calls
class Repository {
  PostState _state = PostState();
  PostState get state => _state;

  Future<void> fetchPosts() async {
    //set Initial State
    _state = PostState(status: PostStatus.loading);

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final posts = jsonData.map((json) => Post.fromJson(json)).toList();
        //if successful setState
        _state = PostState(
          status: PostStatus.success,
          posts: posts,
        );
      } else {
        //onFailure setState
        _state = PostState(
          status: PostStatus.failure,
          exception: Exception('Post load failed'),
          posts: <Post>[],
        );
      }
    } catch (e) {
      _state = PostState(
        status: PostStatus.failure,
        exception: e as Exception,
        posts: <Post>[],
      );
    }
  }
}
