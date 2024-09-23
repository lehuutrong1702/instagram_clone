import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/repositories/user_repository.dart';

final firebaseUserRepositoryProvider =
    Provider((ref) => FirebaseUserRepository());

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<InstagramUser> getUser() async {
    print("get user");
    if (_auth.currentUser == null) {
      print("current user is null");
      return Future.error('no user found');
    }

    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(currentUser.uid).get();

    await Future.delayed(const Duration(milliseconds: 2000));

    return InstagramUser.fromJson(snap.data() as Map<String, dynamic>);
  }
}
