import 'package:dev_assignment/state/postbloc.dart';
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  //disable Searchbar onLoading/onfailure
                  enabled: state.status == PostStatus.success,
                  decoration: InputDecoration(
                    hintText: 'Search posts...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    context.read<PostBloc>().add(SearchPostsEvent(query));
                  },
                ),
              ),
              Expanded(
                  child: switch (state.status) {
                //Loading
                PostStatus.loading => Center(child: CircularProgressIndicator()),
                //Success
                PostStatus.success => state.filteredPosts.isEmpty && state.searchQuery.isEmpty
                    ? Center(child: Text('No posts found matching "${state.searchQuery}"'))
                    :
                    //Build ListView with filtered Posts
                    ListView.builder(
                        itemCount: state.filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = state.filteredPosts[index];
                          //Pass Post router object to PostDetailScreen
                          return PostItemWidget(
                            onTapPost: () => context.pushNamed('post_details', extra: post),
                            postId: post.id,
                            postTitle: post.title,
                          );
                        },
                      ),
                //onFailure
                PostStatus.failure => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load posts: ${state.exception.toString()}',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          //add Reload event
                          onPressed: () => context.read<PostBloc>().add(FetchPostsEvent()),
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
                    ),
                  ),

                //Defalut == State.initial
                //Do nothing Post is loaded in Main router
                _ => Center()
              }),
            ],
          );
        },
      ),
    );
  }
}
