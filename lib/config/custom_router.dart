import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/blocs/auth/auth_bloc.dart';
import 'package:flutter_gram/repositories/post/post_repository.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:flutter_gram/screens/HomeScreen.dart';
import 'package:flutter_gram/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:flutter_gram/screens/login/cubit/login_cubit.dart';
import 'package:flutter_gram/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:flutter_gram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_gram/screens/screens.dart';
import 'package:flutter_gram/screens/signup/cubit/signup_cubit.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {

    print('Route: ${settings.name}');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => 
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(authRepository: context.read<AuthRepository>()),
            child: LoginScreen()
          )
        );

      case '/signup':
        return MaterialPageRoute(builder: (_) => 
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(authRepository: context.read<AuthRepository>()),
            child: SignupScreen()
          )
        );

      case '/nav':
        return MaterialPageRoute(builder: (_) => 
          BlocProvider<BottomNavBarCubit>(
            create: (_) => BottomNavBarCubit(),
            child: NavScreen()
          )
        );

      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    
    switch (settings.name) {
      
      case '/editProfile':
        final EditProfileScreenArgs args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => 
            BlocProvider<EditProfileCubit>(
              create: (context) => EditProfileCubit(
                userRepository: context.read<UserRepository>(),
                storageRepository: context.read<StorageRepository>(),
                profileBloc: args.context.read<ProfileBloc>()
              ),
              child: EditProfileScreen(user: args.context.read<ProfileBloc>().state.user)
            )
        );

      case '/profile':
        final ProfileScreenArgs args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              postRepository: context.read<PostRepository>(),
              userRepository: context.read<UserRepository>()
            )..add(ProfileLoadUser(userId: args.userId)),
            child: ProfileScreen(),
          )
        );
        
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Error Page'),),));
    }

  }

}