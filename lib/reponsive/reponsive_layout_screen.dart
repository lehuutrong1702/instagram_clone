import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/utils/global_var.dart';

class ReponsiveLayout extends ConsumerWidget {
  final Widget webScreenlayout;
  final Widget mobileScreenlayout;

  const ReponsiveLayout(
      {super.key,
      required this.webScreenlayout,
      required this.mobileScreenlayout});

  @override
  Widget build(BuildContext context,ref) {
    return LayoutBuilder(builder: (context, contraints) {
      if (contraints.maxWidth > webScreenSize) {
        return webScreenlayout;
      }
      return mobileScreenlayout;
    });
  }
}
