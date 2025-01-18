import 'dart:convert';
import 'package:dev_assignment/data/entity/post.dart';
import 'package:dev_assignment/data/simple_cache_manager.dart';
import 'package:dev_assignment/state/poststate.dart';
import 'package:http/http.dart' as http;

//Repository to Perform data calls and cache Posts
class Repository {
  PostState _state = PostState();
  PostState get state => _state;
  late final CacheManager _cacheManager;
  static const String POSTS_CACHE_KEY = 'posts_cache';

  Repository() {
    _initializeCache();
  }

  Future<void> _initializeCache() async {
    _cacheManager = await CacheManager.create();
  }

  Future<void> fetchPosts() async {
    //set Initial State
    _state = PostState(status: PostStatus.loading);

    try {
      //check cache first
      final cachedData = _cacheManager.getData(POSTS_CACHE_KEY);
      //Valid
      if (cachedData != null) {
        onSuccess(cachedData);
        return;
      }

      //Not Valid, fetch from API
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        await _cacheManager.saveData(POSTS_CACHE_KEY, response.body,Duration(days: 1));
        onSuccess(response.body);
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

  //helper Method
  //convert from jsonString and update state
  void onSuccess(String jsonStringData) {
    final List<dynamic> jsonData = json.decode(jsonStringData);
    final posts = jsonData.map((json) => Post.fromJson(json)).toList();
    _state = PostState(
      status: PostStatus.success,
      posts: posts,
    );
  }
}



//Manually referesh post
// Future<void> refreshPosts() async {
//     _state = PostState(status: PostStatus.loading);

//     try {
//       final response = await http.get(
//         Uri.parse('https://jsonplaceholder.typicode.com/posts'),
//       );

//       if (response.statusCode == 200) {
//         // Update cache with new data
//         await _cacheManager.saveData(POSTS_CACHE_KEY, response.body);
//        onSuccess(response.body);
//       } else {
//         _state = PostState(
//           status: PostStatus.failure,
//           exception: Exception('Post refresh failed'),
//           posts: <Post>[],
//         );
//       }
//     } catch (e) {
//       _state = PostState(
//         status: PostStatus.failure,
//         exception: e as Exception,
//         posts: <Post>[],
//       );
//     }
//   }