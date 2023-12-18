import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/auth_state_provider.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_donation_related_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_type_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/final_question_screen.dart';
import 'package:mym_raktaveer_frontend/screens/donor/health_condition_question.dart';

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
  runApp(const ProviderScope(child: MyApp()));
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
      routes: {
        '/bloodType': (context) => const BloodTypeQuestion(),
        '/donationDetails': (context) => const BloodDonationRelatedQuestion(),
        '/healthCondition': (context) => const HealthConditionQuestion(),
        '/finalQuestion': (context) => const FinalQuestion(),

        // Define other routes as needed
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    // Define named routes and corresponding pages here
    return MaterialPageRoute(builder: (context) => const MainPage());
  }
}

class MainPage extends ConsumerWidget {
  // Changed to ConsumerWidget
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isLocalDbOperationPending =
        ref.watch(isLocalDbOperationPendingProvider);

    return Scaffold(
      body: authState.when(
        data: (user) => user != null && !isLocalDbOperationPending
            ? const VerifyEmailPage()
            : const AuthPage(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: ${e.toString()}")),
      ),
    );
  }
}
