import 'package:flutter/material.dart';
import 'package:getx_starter/src/modules/grades/views/home_page.dart';
import '/src/modules/auth/views/splash.dart';
import '/src/modules/menu/menu.dart';
import 'auth_handler.dart';
import 'login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthHandler(onAuthenticated: const MenuPage(), onNotAuthenticated: HomePage(), onChecking: const SplashPage(),);
  }

}
