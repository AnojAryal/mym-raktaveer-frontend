import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/main.dart';
import 'package:mym_raktaveer_frontend/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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

            // Reset Password Button
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text('Reset Password'),
            ),

            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Remember password?"),
                const SizedBox(
                  width: 6,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate back to the login page
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
            // Link to Login Page
          ],
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      Utils.showSnackBar(e.message);
    } finally {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Utils.showSnackBar('Password Reset Email Sent');
// Close the loading indicator
    }
  }
}
