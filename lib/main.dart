import 'package:dev_assignment/data/repository.dart';
import 'package:dev_assignment/state/postbloc.dart';
import 'package:dev_assignment/state/postevent.dart';
import 'package:dev_assignment/ui/homescreen.dart';
import 'package:dev_assignment/ui/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'data/entity/post.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp()); 
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  //Using DI for repository
  final repository = Repository();

  //Go gouter Config
  late final GoRouter _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return RepositoryProvider.value(
            value: repository,
            child: BlocProvider(
              create: (context) {
                //Create Bloc and load Posts so that its available
                //as soon as HomeScreen is loaded
                final bloc = PostBloc(repository: context.read<Repository>());
                bloc.add(FetchPostsEvent());
                return bloc;
              },
              child: child,
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'post',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/details',
            name: 'post_details',
            builder: (context, state) {
              final post = state.extra as Post;
              return PostDetailScreen(post: post);
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Posts App',
      theme: ThemeData.dark(),
    );
  }
}
