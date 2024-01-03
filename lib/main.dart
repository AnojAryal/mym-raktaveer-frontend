import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/auth_state_provider.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_donation_related_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/blood_type_question.dart';
import 'package:mym_raktaveer_frontend/screens/donor/donor_available_request.dart';
import 'package:mym_raktaveer_frontend/screens/donor/final_question_screen.dart';
import 'package:mym_raktaveer_frontend/screens/donor/health_condition_question.dart';
import 'package:mym_raktaveer_frontend/screens/admin/admin_request_list.dart';
import 'package:mym_raktaveer_frontend/screens/receiver/blood_request_form.dart';
import 'package:mym_raktaveer_frontend/screens/admin/admin_dashboard.dart';
import 'package:mym_raktaveer_frontend/screens/receiver/approval_request.dart';
import 'package:mym_raktaveer_frontend/widgets/homepage.dart';
import 'package:mym_raktaveer_frontend/widgets/map.dart';
import 'package:mym_raktaveer_frontend/widgets/profile.dart';
import 'widgets/firebase/firebase_options.dart';
import 'widgets/firebase/auth_page.dart';
import 'widgets/firebase/verify_email.dart';
import 'widgets/firebase/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
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
        '/blood-request-list': (context) => const AdminRequestList(),
        '/approval-request': (context) => const ApprovalRequest(),
        '/donor_available_request': (context) => const DonorAvailableRequest(),
       
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
