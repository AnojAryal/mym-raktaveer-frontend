import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to create user: ${e.message}');
    }
  }
}
