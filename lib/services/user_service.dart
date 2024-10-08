import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/repositories/auth_repository.dart';
import 'package:instagram_clone/repositories/implementations/firebase_auth_repository.dart';
import 'package:instagram_clone/repositories/implementations/firebase_user_repository.dart';
import 'package:instagram_clone/repositories/implementations/storage_repository.dart';

final currentUserProvider = FutureProvider<InstagramUser>((ref) {
  final firebaseUserRepository = ref.watch(firebaseUserRepositoryProvider);
  return firebaseUserRepository.getUser();
});

final userByUsernameProvider =
    FutureProvider.family<List<InstagramUser>, String>((ref, username) {
  return ref.watch(firebaseUserRepositoryProvider).selectByUsername(username);
});

final userServiceProvider = Provider((ref) {
  final authRepository = ref.watch(firebaseAuthRepositoryProvider);

  final firebaseStorageRepository =
      ref.watch(firebaseStorageRepositoryProvider);

  final firebaseUserRepository = ref.watch(firebaseUserRepositoryProvider);

  return UserService(
      firebaseUserRepository: firebaseUserRepository,
      authRepository: authRepository,
      firebaseStorageRepository: firebaseStorageRepository,
      ref: ref);
});

class UserService {
  final FirebaseUserRepository firebaseUserRepository;
  final AuthRepository authRepository;
  final FirebaseStorageRepository firebaseStorageRepository;
  final ProviderRef ref;

  UserService(
      {required this.authRepository,
      required this.firebaseUserRepository,
      required this.firebaseStorageRepository,
      required this.ref});

  Future<String> createUser(String username, String email, String password,
      String bio, File image) async {
    try {
      UserCredential userCredential =
          await authRepository.signUpWithEmailPassword(email, password);

      String imageUrl = await firebaseStorageRepository.saveImage(
          image, userCredential.user!.uid);
      final user = InstagramUser(
          username: username,
          email: email,
          bio: bio,
          imageUrl: imageUrl,
          uid: userCredential.user!.uid,
          following: [],
          follower: []);

      firebaseStorageRepository.saveUser(user);
      ref.refresh(currentUserProvider);
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> signIn(String email, String password) async {
    String res = 'Something error';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential =
            await authRepository.signInWithEmailPassword(email, password);
        //  userCredential.
        res = 'success';
        ref.refresh(currentUserProvider);
      } else {
        res = 'please enter all the fields';
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }
}
