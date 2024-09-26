import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/post_service.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          )
        ],
      ),
      body: ref.watch(postProvider).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  return PostCard(
                    post: Post.fromJson(
                      data.docs[index].data(),
                    ),
                  );
                },
              );
            },
            error: (err, object) => Text(
              err.toString(),
            ),
            loading: () => const CircularProgressIndicator(),
          ),
    );
  }
}
