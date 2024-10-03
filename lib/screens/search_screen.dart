import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/user_service.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  var isShowUsers = false;
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userByUsernameProvider(searchController.text));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(hintText: "Search for a user"),
          onFieldSubmitted: (String _) {
            print(_);
            setState(() {
              isShowUsers = true;
            });
          },
        ),
      ),
      body: isShowUsers
          ? users.when(
              data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(data[index].imageUrl),
                        ),
                        title: Text(data[index].username),
                      );
                    });
              },
              error: (a, b) {
                return const Text('some thing went wrong');
              },
              loading: () => const CircularProgressIndicator())
          : const Text('post'),
    );
  }
}
