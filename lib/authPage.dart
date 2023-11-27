import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/login_widget.dart';
import 'package:mym_raktaveer_frontend/signup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginWidget(
            onclickedSignUp: toggle,
          )
        : SignUpWidget(
            onclickedSignIn: toggle,
          );
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
