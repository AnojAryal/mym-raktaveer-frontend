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
  bool isPasswordVisible = false;

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

            // Password Input with Show/Hide Icon
            TextFormField(
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? "Password is too short"
                  : null,
              obscureText: !isPasswordVisible,
            ),
            const SizedBox(height: 24.0),

            // Red Sign-Up Button with White Text
            ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set your desired red color
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            RichText(
              text: TextSpan(
                style: const TextStyle(color: Color.fromARGB(255, 56, 55, 55)),
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (widget.onclickedSignIn != null) {
                          widget.onclickedSignIn!();
                        }
                      },
                    text: "Login",
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
      ),
    );
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
      Utils.showSnackBar(e.message);
    } finally {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }
}
