import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/repositories/implementations/storage_repository.dart';
import 'package:uuid/uuid.dart';

import '../models/comment.dart';

final postServiceProvider = Provider((ref) {
  final storageRepository = ref.watch(firebaseStorageRepositoryProvider);
  return PostService(ref: ref, storageRepository: storageRepository);
});

final postProvider = StreamProvider((ref) {
  final snapshot = FirebaseFirestore.instance.collection('post').snapshots();

  return snapshot;
});

final commentProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, postId) {
  return ref.watch(firebaseStorageRepositoryProvider).getComment(postId);
});

class PostService {
  final FirebaseStorageRepository storageRepository;
  final ProviderRef ref;
  PostService({required this.storageRepository, required this.ref});

  Future<String> createPost(String uid, String description, Uint8List image,
      String username, String profImage) async {
    try {
      var id = const Uuid().v1();
      String imageUrl = await storageRepository.savePostImage(image, id);

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

  void toggleLikePost(Post post, String uid) {
    if (post.likes.contains(uid)) {
      storageRepository.unlikePost(post.postId, uid);
    } else {
      storageRepository.likePost(post.postId, uid);
    }
    // ref.refresh(postProvider);
  }

  void commentPost(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) {
    if (text.isEmpty) {
      return;
    }
    Comment comment = Comment(
        name: name,
        text: text,
        uid: uid,
        profilePic: profilePic,
        postId: postId,
        date: DateTime.now());

    storageRepository.saveComment(comment);
  }
}
