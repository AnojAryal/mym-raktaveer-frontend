import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    // Navigate to the main page or login page after signing out
  } catch (e) {
    print("Error signing out: $e");
    // Handle sign-out error if needed
  }
}
