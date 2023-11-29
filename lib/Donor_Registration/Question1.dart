import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/background.dart';
import 'progress_bar.dart';

class UserChoicePage extends StatelessWidget {
  const UserChoicePage({super. key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: MyProgressBar(), 
    );
  }
}
