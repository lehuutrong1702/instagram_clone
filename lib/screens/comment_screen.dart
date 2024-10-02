import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/post_service.dart';
import 'package:instagram_clone/services/user_service.dart';

import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';

import '../models/comment.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final Post post;
  const CommentScreen(this.post, {super.key});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final controller = TextEditingController();

  Future<void> _saveComment() async {
    final postService = ref.watch(postServiceProvider);
    final currentUser = ref.watch(currentUserProvider);

    postService.commentPost(
        widget.post.postId,
        controller.text,
        currentUser.value!.uid,
        currentUser.value!.username,
        currentUser.value!.imageUrl);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentProvider(widget.post.postId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: comments.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  comment: Comment.fromJson(
                    data.docs[index].data(),
                  ),
                );
              },
            );
          },
          error: (a, b) => const Text('something went wrong'),
          loading: () => const CircularProgressIndicator()),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    ref.watch(currentUserProvider).value!.imageUrl),
                radius: 16,
              ),
              ref.watch(currentUserProvider).when(
                    data: (user) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                hintText: 'Comment as a usename',
                                border: InputBorder.none),
                          ),
                        ),
                      );
                    },
                    error: (a, b) {
                      return const Text('something went wrong!');
                    },
                    loading: () => const CircularProgressIndicator(),
                  ),
              InkWell(
                onTap: _saveComment,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'POST',
                    style: TextStyle(
                        color: blueColor, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
