import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar {
  AppBar buildAppBar(Text title, BuildContext context, Function signOut) {
    return AppBar(
      title: title,
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            signOut();
            Navigator.pop(context);
          }),
    );
  }
}
