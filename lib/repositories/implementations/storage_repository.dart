import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart';

final firebaseStorageRepositoryProvider =
    Provider((ref) => FirebaseStorageRepository());

class FirebaseStorageRepository {
  void saveUser(InstagramUser user) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<String> saveImage(File image, String uid) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('user_images').child('$uid.jpg');

    await storageRef.putFile(image);

    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }
}
