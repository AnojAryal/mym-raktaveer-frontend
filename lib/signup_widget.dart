import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/main.dart';
import 'package:mym_raktaveer_frontend/utils.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    super.key,
    required this.onclickedSignIn,
  });

  final VoidCallback? onclickedSignIn;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Input
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter valid email"
                        : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),

              // Password Input
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? "Password is too short"
                    : null,
                obscureText: true,
              ),
              const SizedBox(height: 24.0),

              // Sign-In Button
              ElevatedButton(
                onPressed: signUp,
                child: const Text('Sign Up'),
              ),

              const SizedBox(
                height: 24,
              ),

              RichText(
                text: TextSpan(
                  style:
                      const TextStyle(color: Color.fromARGB(255, 56, 55, 55)),
                  text: 'Already have an account? ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Check if the callback is not null before invoking it
                          if (widget.onclickedSignIn != null) {
                            // Pass the current context to the callback
                            widget.onclickedSignIn!();
                          }
                        },
                      text: "Sign In",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 235, 34, 34),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      Utils.showSnackBar(e.message);
    } finally {
      navigatorKey.currentState!
          .popUntil((route) => route.isFirst); // Close the loading indicator
    }
  }
}
