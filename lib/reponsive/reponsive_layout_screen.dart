import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class ReponsiveLayout extends StatelessWidget {
  final Widget webScreenlayout;
  final Widget mobileScreenlayout;

  const ReponsiveLayout(
      {super.key,
      required this.webScreenlayout,
      required this.mobileScreenlayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contraints) {
      if (contraints.maxWidth > webScreenSize) {
        return webScreenlayout;
      }
      return mobileScreenlayout;
    });
  }
}
