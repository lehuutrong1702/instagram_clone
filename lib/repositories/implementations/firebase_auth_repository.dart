import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/repositories/auth_repository.dart';

final _firebase = FirebaseAuth.instance;

final firebaseAuthRepositoryProvider = Provider((ref) {
  return FirebaseAuthRepository();
});

class FirebaseAuthRepository implements AuthRepository {
  @override
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) {
    return _firebase.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) {
    return _firebase.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
