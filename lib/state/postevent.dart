import 'package:equatable/equatable.dart';

//Events to b e sent to PostBloc to update State
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsEvent  extends PostEvent{}
class RefreshPostsEvent extends PostEvent{}