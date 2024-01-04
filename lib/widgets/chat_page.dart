import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/widgets/background.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Hello, This is Chat!',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}