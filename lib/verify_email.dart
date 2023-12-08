import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mym_raktaveer_frontend/background.dart';
import 'package:mym_raktaveer_frontend/homepage.dart';
import 'package:mym_raktaveer_frontend/user_choice.dart';
import 'package:mym_raktaveer_frontend/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  int countdown = 60;
  final user = FirebaseAuth.instance.currentUser!;
  bool didFetchData =
      false; // Track whether data has been fetched to avoid unnecessary calls

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      // Use Timer instead of Timer.periodic to avoid multiple instances
      timer = Timer(Duration(seconds: 3), checkEmailVerified);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerificationEmail() async {
    try {
      setState(() {
        countdown = 60;
      });

      timer?.cancel(); // Cancel existing timer, if any

      timer = Timer.periodic(
        Duration(seconds: 1),
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
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      if (!didFetchData) {
        // Only fetch data if it hasn't been fetched before
        return FutureBuilder(
          future: fetchData(
              'https://613f-2400-1a00-b030-d590-dedf-3b84-2bdc-7c0e.ngrok-free.app/api/personal-details/${user.uid}'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final responseData = snapshot.data;

              if (responseData?['data']?['health_condition'] != null &&
                  responseData?['data']?['blood_detail'] != null) {
                // Set didFetchData to true after successful data fetch
                didFetchData = true;
                return const HomePage();
              } else {
                // Set didFetchData to true even if conditions are not met
                didFetchData = true;
                return const UserChoice();
              }
            }
          },
        );
      } else {
        // Return placeholder widget if data has already been fetched
        return const SizedBox.shrink();
      }
    } else {
      return Background(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildVerificationForm(),
            ),
          ],
        ),
      );
    }
  }

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

  Future<Map<String, dynamic>> fetchData(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
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
      // Handle exceptions
    }
  }
}
