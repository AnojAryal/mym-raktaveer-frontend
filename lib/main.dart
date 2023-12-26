import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/auth_state_provider.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_donation_related_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_type_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/final_question_screen.dart';
import 'package:mym_raktaveer_frontend/screens/donor/health_condition_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/request_list.dart';
import 'package:mym_raktaveer_frontend/screens/receiver/blood_request_form.dart';
import 'package:mym_raktaveer_frontend/widgets/admin_dashboard.dart';
import 'package:mym_raktaveer_frontend/widgets/homepage.dart';
import 'package:mym_raktaveer_frontend/widgets/map.dart';
import 'package:mym_raktaveer_frontend/widgets/profile.dart';

import 'Providers/firebase_auth_provider/firebase_options.dart';
import 'Providers/firebase_auth_provider/auth_page.dart';
import 'Providers/firebase_auth_provider/verify_email.dart';
import 'Providers/firebase_auth_provider/utils.dart';
import 'screens/admin/request_details_screen.dart';

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
        '/home-page': (context) => const HomePage(),
        '/blood-type': (context) => const BloodTypeQuestion(),
        '/donation-details': (context) => const BloodDonationRelatedQuestion(),
        '/health-condition': (context) => const HealthConditionQuestion(),
        '/final-question': (context) => const FinalQuestion(),
        '/blood-request-form': (context) => const BloodRequestForm(),
        '/map-page': (context) => const MapChoice(),
        '/profile-page': (context) => const Profile(),
        '/admin-dashboard': (context) => const AdminDashboard(),
<<<<<<< HEAD
        '/blood-request-list': (context) => const RequestList(),
=======
        '/request-list': (context) => const RequestList(),
>>>>>>> feat/admin_panal
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const MainPage());
  }
}

class MainPage extends ConsumerWidget {
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
