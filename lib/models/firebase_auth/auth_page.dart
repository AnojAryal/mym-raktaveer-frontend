import 'package:flutter/material.dart';
import '../../widgets/background.dart';
import '../../widgets/login_widget.dart';
import '../../widgets/signup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Background(child: _buildAuthenticationWidget());
  }

  Widget _buildAuthenticationWidget() {
    return isLogin
        ? LoginWidget(onClickedSignUp: toggleAuthenticationMode)
        : SignUpWidget(onClickedSignIn: toggleAuthenticationMode);
  }

  void toggleAuthenticationMode() {
    setState(() => isLogin = !isLogin);
  }
}
