import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/homepage.dart';
import 'package:mym_raktaveer_frontend/widgets/user_choice.dart';
import 'package:mym_raktaveer_frontend/models/firebase_auth/utils.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? resendTimer;
  Timer? verificationCheckTimer;
  int countdown = 60;
  final user = FirebaseAuth.instance.currentUser!;
  bool didFetchData = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = user.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      resendTimer =
          Timer.periodic(const Duration(seconds: 1), resendTimerCallback);
      verificationCheckTimer =
          Timer.periodic(const Duration(seconds: 5), verificationCheckCallback);
    }
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    verificationCheckTimer?.cancel();
    super.dispose();
  }

  void resendTimerCallback(Timer timer) {
    if (countdown > 0) {
      setState(() => countdown--);
    } else {
      timer.cancel();
    }
  }

  void verificationCheckCallback(Timer timer) async {
    await checkEmailVerified();
  }

  Future<void> sendVerificationEmail() async {
    try {
      setState(() => countdown = 60);
      await user.sendEmailVerification();
      Utils.showSnackBar("Email Successfully Sent");
    } catch (e) {
      Utils.showSnackBar("Failed to Send Email: ${e.toString()}");
    }
  }

  Future<void> checkEmailVerified() async {
    await user.reload();
    bool isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (isVerified) {
      setState(() {
        isEmailVerified = true;
      });
      resendTimer?.cancel();
      verificationCheckTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified ? buildVerifiedUser() : buildUnverifiedUser();
  }

  Widget buildVerifiedUser() {
    return didFetchData ? const SizedBox.shrink() : buildUserDataLoader();
  }

  Widget buildUserDataLoader() {
    return FutureBuilder(
      future: fetchData('api/personal-details/${user.uid}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          didFetchData = true;
          return snapshot.data?['data']['health_condition'] != null &&
                  snapshot.data?['data']['blood_detail'] != null
              ? const HomePage()
              : const UserChoice();
        }
      },
    );
  }

  Widget buildUnverifiedUser() {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please verify your email address...',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            buildResendEmailButton(),
            const SizedBox(height: 8.0),
            buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget buildResendEmailButton() {
    return ElevatedButton(
      onPressed: countdown > 0 ? null : sendVerificationEmail,
      child: Text(
        countdown > 0
            ? 'Resend Verification Email in: $countdown seconds'
            : 'Resend Verification Email',
      ),
    );
  }

  Widget buildCancelButton() {
    return TextButton(
      onPressed: () => FirebaseAuth.instance.signOut(),
      child: const Text('Cancel'),
    );
  }

  Future<Map<String, dynamic>?> fetchData(String apiUrl) async {
    try {
      final response = await ApiService().getData(apiUrl);
      if (response == null) {
        throw Exception('Failed to fetch data from the API');
      }
      return response;
    } catch (error) {
      throw Exception('Error loading data: $error');
    }
  }
}
