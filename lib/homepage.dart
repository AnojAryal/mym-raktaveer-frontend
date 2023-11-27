import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // You can navigate to the sign-in page or any other page after signing out.
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text("Sign Out"),
          ),
        ],
      ),
      body: Text(user?.email ?? "No email available"),
    );
  }
}
