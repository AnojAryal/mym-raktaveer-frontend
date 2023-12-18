import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final isLocalDbOperationPendingProvider = StateProvider<bool>((ref) => false);

final emailVerifiedProvider = StateProvider<bool>((ref) => false);
final fetchDataProvider = StateProvider<bool>((ref) => false);
