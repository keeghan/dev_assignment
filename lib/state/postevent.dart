import 'package:equatable/equatable.dart';

//Events to be sent to PostBloc to trigger State update
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsEvent extends PostEvent {}

class RefreshPostsEvent extends PostEvent {}

class SearchPostsEvent extends PostEvent {
  final String query;
  const SearchPostsEvent(this.query);
}
