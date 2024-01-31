import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/Providers/auth_state_provider.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';
import 'package:mym_raktaveer_frontend/widgets/homepage.dart';
import 'package:mym_raktaveer_frontend/widgets/user_choice.dart';
import 'package:mym_raktaveer_frontend/widgets/firebase/utils.dart';
import 'package:mym_raktaveer_frontend/services/api_service.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  Timer? resendTimer;
  Timer? verificationCheckTimer;
  int countdown = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => checkAndSendEmailVerification());
  }

  // Combined logic for initial email verification check and sending email
  void checkAndSendEmailVerification() async {
    final user = ref.read(authStateProvider).asData?.value;
    if (user != null) {
      if (user.emailVerified) {
        ref.read(emailVerifiedProvider.notifier).state = true;
      }
    }
  }

  void startTimers() {
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        timer.cancel();
      }
    });

    verificationCheckTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      await checkEmailVerified();
    });
  }

  Future<void> sendVerificationEmail(User? user) async {
    try {
      resendTimer?.cancel();
      setState(() => countdown = 60);
      startTimers();
      await user?.sendEmailVerification();
      Utils.showSnackBar("Email Successfully Sent");
    } catch (e) {
      Utils.showSnackBar("Failed to Send Email: ${e.toString()}");
    }
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    bool isVerified = user?.emailVerified ?? false;
    if (isVerified) {
      setState(() {
        resendTimer?.cancel();
        verificationCheckTimer?.cancel();
      });
      ref.read(emailVerifiedProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmailVerified = ref.watch(emailVerifiedProvider);
    return isEmailVerified
        ? buildVerifiedUser(context)
        : buildUnverifiedUser(context);
  }

  Widget buildVerifiedUser(BuildContext context) {
    final user = ref.read(authStateProvider).asData?.value;
    if (user == null) return const SizedBox.shrink();

    return FutureBuilder(
      future: fetchData('api/personal-details/${user.uid}', ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data?['data']['health_condition'] != null &&
                  snapshot.data?['data']['blood_detail'] != null
              ? const HomePage()
              : const UserChoice();
        }
      },
    );
  }

  Widget buildUnverifiedUser(BuildContext context) {
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
      onPressed: countdown > 0
          ? null
          : () =>
              sendVerificationEmail(ref.read(authStateProvider).asData!.value),
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

  Future<Map<String, dynamic>?> fetchData(String apiUrl, WidgetRef ref) async {
    try {
      final response = await ApiService().getData(apiUrl, ref);
      if (response == null) {
        throw Exception('Failed to fetch data from the API');
      }
      return response;
    } catch (error) {
      throw Exception('Error loading data: $error');
    }
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    verificationCheckTimer?.cancel();
    super.dispose();
  }
}
