import 'dart:async';
import 'package:mym_raktaveer_frontend/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/homepage.dart';
import 'package:mym_raktaveer_frontend/utils.dart';


class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  int countdown = 60;

  @override
  void initState() {
    super.initState();
    isEmailVerified =
        FirebaseAuth.instance.currentUser?.emailVerified ?? false;

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

      setState(() {
        countdown = 60;
      });

      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          setState(() {
            if (countdown > 0) {
              countdown--;
            } else {
              timer.cancel();
            }
          });
        },
      );

      await user.sendEmailVerification();
      Utils.showSnackBar("Email Successfully Sent");
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Background(
          // Use the Background widget here
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildVerificationForm(),
            ),
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
          onPressed: countdown > 0 ? null : sendVerificationEmail,
          child: Text(
            countdown > 0
                ? 'Resend Verification Email in: $countdown seconds'
                : 'Resend Verification Email',
          ),
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
      //
    }
  }
}
