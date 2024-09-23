import 'dart:io';

import 'package:flutter/widgets.dart';

class InstagramUser {
  final String username;
  final String email;

  final String bio;
  final String imageUrl;
  final String uid;
  final List following;
  final List follower;

  InstagramUser(
      {required this.username,
      required this.email,
      required this.bio,
      required this.imageUrl,
      required this.uid,
      required this.following,
      required this.follower});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'bio': bio,
      'imageUrl': imageUrl,
      'uid': uid,
      'following': following,
      'follower': follower
    };
  }

  static InstagramUser fromJson(Map<String, dynamic> snapshot) {
    return InstagramUser(
        username: snapshot['username'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        imageUrl: snapshot['imageUrl'],
        uid: snapshot['uid'],
        following: snapshot['following'],
        follower: snapshot['follower']);
  }
}
