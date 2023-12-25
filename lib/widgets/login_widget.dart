import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/models/firebase_auth/forgot_password.dart';
import 'package:mym_raktaveer_frontend/main.dart';
import 'package:mym_raktaveer_frontend/services/firebase_auth_service.dart';

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({
    super.key,
    required this.onClickedSignUp,
  });

  final VoidCallback? onClickedSignUp;

  @override
  ConsumerState<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends ConsumerState<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false; // Added to toggle password visibility

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
          // MYM Raktabeer Heading
          const Text(
            'MYM Raktaveer',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Set your desired color
            ),
          ),
          const SizedBox(height: 16.0),

          // Email Input
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),

          // Password Input with Show/Hide Icon
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !isPasswordVisible,
          ),
          const SizedBox(height: 24.0),

          // Red Sign-In Button
          ElevatedButton(
              onPressed: signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          const SizedBox(
            height: 24,
          ),

          GestureDetector(
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color.fromARGB(255, 99, 99, 210),
              ),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage())),
          ),

          const SizedBox(
            height: 14,
          ),

          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              text: 'Dont have account? ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Check if the callback is not null before invoking it
                      if (widget.onClickedSignUp != null) {
                        // Pass the current context to the callback
                        widget.onClickedSignUp!();
                      }
                    },
                  text: "Sign Up",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 99, 99, 210),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuthService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
        ref,
      );
    } catch (e) {
      // ignore: avoid_print
    } finally {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
