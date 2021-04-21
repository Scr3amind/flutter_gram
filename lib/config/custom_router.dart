import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gram/repositories/repositories.dart';
import 'package:flutter_gram/screens/HomeScreen.dart';
import 'package:flutter_gram/screens/login/cubit/login_cubit.dart';
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
        BlocProvider(
          create: (context) => LoginCubit(authRepository: context.read<AuthRepository>()),
          child: LoginScreen())
        );

      case '/signup':
        return MaterialPageRoute(builder: (_) => 
        BlocProvider(
          create: (context) => SignupCubit(authRepository: context.read<AuthRepository>()),
          child: SignupScreen())
        );

      case '/nav':
        return MaterialPageRoute(builder: (_) => NavScreen());

      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}