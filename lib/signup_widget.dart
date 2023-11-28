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
  final fullnameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final mobileNumberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullnameController.dispose();
    genderController.dispose();
    ageController.dispose();
    mobileNumberController.dispose();
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
            // Fullname Input
            TextFormField(
              controller: fullnameController,
              decoration: const InputDecoration(
                labelText: 'Fullname',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (fullname) => fullname != null && fullname.isEmpty
                  ? "Enter your fullname"
                  : null,
            ),
            const SizedBox(height: 16.0),

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

            // Gender Input
            TextFormField(
              controller: genderController,
              decoration: const InputDecoration(
                labelText: 'Gender',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (gender) =>
                  gender != null && gender.isEmpty ? "Enter your gender" : null,
            ),
            const SizedBox(height: 16.0),

            // Age Input
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (age) =>
                  age != null && age.isEmpty ? "Enter your age" : null,
            ),
            const SizedBox(height: 16.0),

            // Mobile Number Input
            TextFormField(
              controller: mobileNumberController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (mobileNumber) =>
                  mobileNumber != null && mobileNumber.isEmpty
                      ? "Enter your mobile number"
                      : null,
              keyboardType: TextInputType.phone,
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

            // Sign-Up Button
            ElevatedButton(
              onPressed: signUp,
              child: const Text('Sign Up'),
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
      // ignore: avoid_print
      Utils.showSnackBar(e.message);
    } finally {
      navigatorKey.currentState!
          .popUntil((route) => route.isFirst); // Close the loading indicator
    }
  }
}
