import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBar(
      {super.key,
        required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "${title[0].toUpperCase()}${title.substring(1).toLowerCase()}",
        style: TextStyle(
          fontSize: 18
        ),
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius:  BorderRadius.vertical(
          bottom:  Radius.circular(30.0),
        ),
      ),
    );
  }
}
