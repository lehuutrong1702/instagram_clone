import 'dart:io';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/repositories/auth_repository.dart';
import 'package:instagram_clone/repositories/implementations/firebase_auth_repository.dart';
import 'package:instagram_clone/repositories/implementations/storage_repository.dart';

final userServiceProvider = Provider((ref) {
  final authRepository = ref.watch(firebaseAuthRepositoryProvider);
  final firebaseStorageRepository =
      ref.watch(firebaseStorageRepositoryProvider);

  return UserService(
      authRepository: authRepository,
      firebaseStorageRepository: firebaseStorageRepository,
      ref: ref);
      
});

class UserService {
  final AuthRepository authRepository;
  final FirebaseStorageRepository firebaseStorageRepository;
  final ProviderRef ref;

  UserService(
      {required this.authRepository,
      required this.firebaseStorageRepository,
      required this.ref});

  Future<String> createUser(String username, String email, String password, String bio,
      File image) async {


        print("create user ");


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
      return 'success';
    } catch (error) {
      return error.toString();
    }
  }
}
