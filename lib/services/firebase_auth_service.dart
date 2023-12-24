import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // You might want to handle specific FirebaseAuthException cases differently
      rethrow; // Rethrow to allow calling code to handle the exception
    }
  }

  static Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // You might want to handle specific FirebaseAuthException cases differently
      rethrow; // Rethrow to allow calling code to handle the exception
    }
  }

  // Consider adding more methods here, like signIn, signOut, etc.
}
