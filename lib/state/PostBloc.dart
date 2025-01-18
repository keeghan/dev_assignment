import 'package:dev_assignment/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'postevent.dart';
import 'poststate.dart';

//Block to handle state of posts
class PostBloc extends Bloc<PostEvent, PostState> {
  final Repository repository;

  PostBloc({required this.repository}) : super(PostState()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<SearchPostsEvent>(_onSearchPosts);
  }

  //search event to trigger new state emission
  void _onSearchPosts(
    SearchPostsEvent event,
    Emitter<PostState> emit,
  ) {
    if (state.status == PostStatus.failure) return;
    //emit copy of current state with new SearchPostEvent query
    emit(PostState(
      status: state.status,
      searchQuery: event.query,
      exception: state.exception,
      posts: state.posts,
    ));
  }

  Future<void> _onFetchPosts(
    FetchPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostState(status: PostStatus.loading));

    try {
      await repository.fetchPosts();
      emit(repository.state);
    } catch (e) {
      emit(PostState(
        status: PostStatus.failure,
        exception: e as Exception,
        posts: [],
      ));
    }
  }

  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      await repository.fetchPosts();
      emit(repository.state);
    } catch (e) {
      emit(PostState(
        status: PostStatus.failure,
        exception: e as Exception,
        posts: [],
      ));
    }
  }
}
