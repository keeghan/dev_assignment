import 'package:dev_assignment/state/PostBloc.dart';
import 'package:dev_assignment/state/postevent.dart';
import 'package:dev_assignment/state/poststate.dart';
import 'package:dev_assignment/ui/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          //Display based on State of List
          switch (state.status) {
            case PostStatus.loading:
              return Center(child: CircularProgressIndicator());

            case PostStatus.success:
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  //Create list of posts
                  //Pass Post router object to PostDetailScreen
                  return PostItemWidget(
                    onTapPost: () {
                      context.pushNamed('post_details', extra: post);
                    },
                    postId: post.id,
                    postTitle: post.title,
                  );
                },
              );

            case PostStatus.failure:
              return Column(
                children: [
                  Text('Failed to load posts: ${state.exception.toString()}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PostBloc>().add(FetchPostsEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'retry',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );

            //Defalut == State.initial
            //Do nothing Post is loaded in Main router
            default:
              return Center();
          }
        },
      ),
    );
  }
}
