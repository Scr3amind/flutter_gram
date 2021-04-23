import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:flutter_gram/screens/HomeScreen.dart';
import 'package:flutter_gram/screens/login/cubit/login_cubit.dart';
import 'package:flutter_gram/screens/nav/cubit/bottom_nav_bar_cubit.dart';
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
    return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Error Page'),),));
  }

}