import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mym_raktaveer_frontend/auth_page.dart';
import 'package:mym_raktaveer_frontend/utils.dart';
import 'package:mym_raktaveer_frontend/verify_email.dart';


void main() {
  runApp(const MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      home: const MainPage(),
    );
  }
}



class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData) {
            return const VerifyEmailPage();
          } else {
            return const AuthPage();
          }
        },
      ));
}





// import 'package:flutter/material.dart';
// import 'package:mym_raktaveer_frontend/Donor_Registration/Question1.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Your App Title',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: UserChoicePage(),
//     );
//   }
// }
