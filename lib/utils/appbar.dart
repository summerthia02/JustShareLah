import 'package:flutter/material.dart';

// deleted the function as not all pages sign out from there
class MyAppBar {
  AppBar buildAppBar(Text title, BuildContext context, dynamic newRoute) {
    return AppBar(
      title: title,
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pushReplacementNamed(context, newRoute);
          }),
    );
  }
}
