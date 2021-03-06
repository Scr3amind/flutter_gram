import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/blocs/auth/auth_bloc.dart';
import 'package:flutter_gram/config/custom_router.dart';
import 'package:flutter_gram/enums/bottom_nav_item.dart';
import 'package:flutter_gram/repositories/post/post_repository.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:flutter_gram/screens/create_post/cubit/create_post_cubit.dart';
import 'package:flutter_gram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_gram/screens/screens.dart';
import 'package:flutter_gram/screens/search/cubit/search_user_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key key, this.navigatorKey, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();

    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context))
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return BlocProvider<SearchUserCubit>(
          create: (context) => SearchUserCubit(
            userRepository: context.read<UserRepository>()
          ),
          child: SearchScreen(),
        );
      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
              authBloc: context.read<AuthBloc>(),
              postRepository: context.read<PostRepository>(),
              storageRepository: context.read<StorageRepository>()),
          child: CreatePostScreen(),
        );
      case BottomNavItem.notifications:
        return NotificationsScreen();
      case BottomNavItem.profile:
        return BlocProvider(
          create: (_) => ProfileBloc(
              userRepository: context.read<UserRepository>(),
              postRepository: context.read<PostRepository>(),
              authBloc: context.read<AuthBloc>())
            ..add(ProfileLoadUser(
                userId: context.read<AuthBloc>().state.user.uid)),
          child: ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  }
}
