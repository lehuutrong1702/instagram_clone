import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Comment {
  final String postId;
  final String text;
  final String uid;
  final String name;
  final String profilePic;
  final String id;
  final DateTime date;
  Comment(
      {required this.postId,
      required this.text,
      required this.uid,
      required this.name,
      required this.profilePic,
      required this.date})
      : id = uuid.v1();

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'text': text,
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'date': date
    };
  }

  static Comment fromJson(Map<String, dynamic> data) {
    return Comment(
        postId: data['postId'],
        text: data['text'],
        uid: data['uid'],
        date: data['date'].toDate(),
        profilePic: data['profilePic'],
        name: data['name']);
  }
}
