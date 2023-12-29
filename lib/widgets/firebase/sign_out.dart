// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print("Error signing out: $e");
  }
}
