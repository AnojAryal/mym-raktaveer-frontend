import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Email Input
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),

          // Password Input
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24.0),

          // Sign-In Button
          ElevatedButton(
            onPressed: signIn,
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    // If successful, you can navigate to the next screen or perform other actions
  }
}
