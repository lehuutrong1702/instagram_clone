import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/repositories/implementations/storage_repository.dart';
import 'package:uuid/uuid.dart';

final postServiceProvider = Provider((ref) {
  final storageRepository = ref.watch(firebaseStorageRepositoryProvider);
  return PostService(storageRepository: storageRepository);
});


final postProvider = StreamProvider((ref) {
  final snapshot =  FirebaseFirestore.instance.collection('post').snapshots();

  return snapshot;
}) ;


class PostService {
  final FirebaseStorageRepository storageRepository;

  PostService({required this.storageRepository});

  Future<String> createPost(String uid, String description, Uint8List image,
      String username, String profImage) async {
    try {
      var id =  const Uuid().v1();
      String imageUrl = await storageRepository.savePostImage(image,id);

      final newPost = Post(
          description: description,
          imageUrl: imageUrl,
          uid: uid,
          postId: id,
          username: username,
          datePublished: DateTime.now(),
          profImage: profImage,
          likes: []);

      storageRepository.savePost(newPost);
      return 'success';
    } catch (err) {
      return err.toString();
    }
  }
}
