import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';

import '../../models/comment.dart';

final firebaseStorageRepositoryProvider =
    Provider((ref) => FirebaseStorageRepository());

class FirebaseStorageRepository {
  void saveUser(InstagramUser user) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .set(user.toJson());
  }

  void savePost(Post post) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(post.postId)
        .set(post.toJson());
  }

  Future<String> saveImage(File image, String uid) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('user_images').child('$uid.jpg');

    await storageRef.putFile(image);

    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  Future<String> savePostImage(Uint8List image, String postId) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('postImage').child('$postId.jpg');
    ;

    await storageRef.putData(image);

    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  Future<void> unlikePost(String postId, String uid) async {
    FirebaseFirestore.instance.collection('post').doc(postId).update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  }

  Future<void> likePost(String postId, String uid) async {
    FirebaseFirestore.instance.collection('post').doc(postId).update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> saveComment(Comment comment) async {
    FirebaseFirestore.instance
        .collection('post')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getComment(String postId) {
    return FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comments')
        .snapshots();
  }
}
