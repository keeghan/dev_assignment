import 'package:dev_assignment/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'postevent.dart';
import 'poststate.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Repository repository;

  PostBloc({required this.repository}) : super(PostState()) {
    on<FetchPostsEvent>(_onFetchPosts);
    on<RefreshPostsEvent>(_onRefreshPosts);
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
