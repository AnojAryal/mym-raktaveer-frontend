import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Background(
        child: Text("Waiting for approval from blood request owner"));
  }
}
