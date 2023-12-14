import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/models/firebase_auth/forgot_password.dart';
import 'package:mym_raktaveer_frontend/main.dart';
import 'package:mym_raktaveer_frontend/models/firebase_auth/utils.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    super.key,
    required this.onclickedSignUp,
  });

  final VoidCallback? onclickedSignUp;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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
                      if (widget.onclickedSignUp != null) {
                        // Pass the current context to the callback
                        widget.onclickedSignUp!();
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      Utils.showSnackBar(e.message);
    } finally {
      // ignore: use_build_context_synchronously
      navigatorKey.currentState!
          .popUntil((route) => route.isFirst); // Close the loading indicator
    }
  }
}
