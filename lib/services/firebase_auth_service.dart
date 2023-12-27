import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mym_raktaveer_frontend/Providers/user_data_provider.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential?> signUp(
      String email, String password, WidgetRef ref) async {
    try {
      final userDataNotifier = ref.read(userDataProvider.notifier);

      final response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String? idToken = await response.user?.getIdToken();

      userDataNotifier.setUserData(response.user?.uid, idToken);

      return response;
    } catch (e) {
      // You might want to handle specific FirebaseAuthException cases differently
      rethrow; // Rethrow to allow calling code to handle the exception
    }
  }

  static Future<UserCredential?> signIn(
      String email, String password, WidgetRef ref) async {
    try {
      final userDataNotifier = ref.read(userDataProvider.notifier);

      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String? idToken = await response.user?.getIdToken();

      userDataNotifier.setUserData(response.user?.uid, idToken);

      return response;
    } catch (e) {
      // You might want to handle specific FirebaseAuthException cases differently
      rethrow; // Rethrow to allow calling code to handle the exception
    }
  }

  // Consider adding more methods here, like signIn, signOut, etc.
}
