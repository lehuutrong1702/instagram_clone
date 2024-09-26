import 'package:intl/intl.dart';


class Post {
  Post(
      {required this.description,
      required this.imageUrl,
      required this.uid,
      required this.postId,
      required this.username,
      required this.datePublished,
      required this.profImage,
      required this.likes});

  final String description;
  final String imageUrl;
  final String uid;
  final String postId;
  final String username;
  final DateTime datePublished;
  final String profImage;
  final likes;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'uid': uid,
      'postId': postId,
      'username': username,
      'datePublished': datePublished,
      'profImage': profImage,
      'likes': likes
    };
  }

  static Post fromJson(Map<String,dynamic> data) {
    return Post(
        description: data['description'],
        imageUrl: data['imageUrl'],
        uid: data['uid'],
        postId: data['postId'],
        username: data['username'],
        datePublished: data['datePublished'].toDate(),
        profImage: data['profImage'],
        likes: data['likes']);
  }
}
