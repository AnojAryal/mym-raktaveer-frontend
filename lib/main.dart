import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mym_raktaveer_frontend/widgets/signup_widget.dart';

import 'models/firebase_auth/firebase_options.dart';
import 'models/firebase_auth/auth_page.dart';
import 'models/firebase_auth/verify_email.dart';
import 'models/firebase_auth/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      home: const MainPage(),
      navigatorKey: navigatorKey,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    // Define named routes and corresponding pages here
    return MaterialPageRoute(builder: (context) => const MainPage());
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) => _buildPageBasedOnSnapshot(snapshot),
      ),
    );
  }

  Widget _buildPageBasedOnSnapshot(AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return const Center(child: Text("Something went wrong"));
    } else if (snapshot.hasData && !isLocalDbOperationPending) {
      return const VerifyEmailPage();
    } else {
      return const AuthPage();
    }
  }
}
