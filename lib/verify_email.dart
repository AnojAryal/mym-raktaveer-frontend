import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/homepage.dart';
import 'package:mym_raktaveer_frontend/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late bool isEmailVerified;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      // Disable the button for one minute

      // Send a verification email
      await user.sendEmailVerification();

      // Wait for one minute before enabling the button again
    } catch (e) {
      print('Error sending verification email: $e');
      if (e is FirebaseAuthException && e.code == 'too-many-requests') {
        // Handle rate-limiting: Display a user-friendly message and provide guidance on when to retry
        Utils.showSnackBar('Too many requests. Please try again later.');
      } else {
        // Show a generic error message for other types of errors
        Utils.showSnackBar(
            'Error sending verification email. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verify Email'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildVerificationForm(),
          ),
        );

  Widget _buildVerificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Please verify your email address by clicking on the link sent to your email.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: sendVerificationEmail,
          child: const Text('Resend Verification Email'),
        ),
        const SizedBox(height: 8.0),
        TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        isEmailVerified =
            FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      });

      if (isEmailVerified) {
        timer?.cancel();
      }
    } catch (e) {
      print('Error checking email verification: $e');
    }
  }
}
