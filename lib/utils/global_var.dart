import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItem = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('favorite'),
  Text('profile'),
];
