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
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = true;
  int remainingTime = 60; // Initial remaining time in seconds

  @override
  void initState() {
    super.initState();

    // Check if the user's email is already verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      // If not verified, send a verification email and set up a timer
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => updateRemainingTime(),
      );
    }
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      // Disable the button for one minute
      setState(() => canResendEmail = false);

      // Send a verification email
      await user.sendEmailVerification();

      // Wait for one minute before enabling the button again
      await Future.delayed(const Duration(minutes: 1));
      setState(() {
        canResendEmail = true;
        remainingTime = 60; // Reset the remaining time
      });
    } catch (e) {
      // Show an error message if sending verification email fails
      Utils.showSnackBar('Error: $e');
    }
  }

  void updateRemainingTime() {
    // Update the remaining time every second
    setState(() {
      remainingTime -= 1;

      // If the countdown reaches 0, cancel the timer
      if (remainingTime == 0) {
        timer?.cancel();
      }
    });
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Please verify your email address by clicking on the link sent to your email.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  child: Text(
                    canResendEmail
                        ? 'Resend Verification Email'
                        : 'Resend Email in: $remainingTime seconds',
                  ),
                ),
              ],
            ),
          ),
        );

  Future<void> checkEmailVerified() async {
    // Reload user data to get the latest email verification status
    await FirebaseAuth.instance.currentUser!.reload();

    // Update the UI based on the latest email verification status
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // If email is verified, cancel the timer
    if (isEmailVerified) timer?.cancel();
  }
}
