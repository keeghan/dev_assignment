import '../data/entity/post.dart';

enum PostStatus { initial, loading, success, failure }

//Class representing the state of the main data to be called
//primarily used inn the HomeScreen
final class PostState {
  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.searchQuery = '',
    this.exception = null,
  });

  final PostStatus status;
  final List<Post> posts;
  final String searchQuery;
  final Exception? exception;

  //Called in homeScreen to produce
  //"posts" or filtered posts
  List<Post> get filteredPosts {
    if (status == PostStatus.failure) return []; //errorCheck
    if (searchQuery.isEmpty) return posts;
    return posts
        .where((post) => post.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}
