import '../data/entity/post.dart';

enum PostStatus { initial, loading, success, failure }

//Class representing the state of the main data to be called
//primarily used inn the HomeScreen
final class PostState {

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.exception = null,
  });

  final PostStatus status;
  final List<Post> posts;
  final Exception? exception;
}
