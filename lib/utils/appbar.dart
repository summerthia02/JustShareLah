// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar {
  AppBar buildAppBar(Text title, BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
        // label: const Text('Back'),
      ),
    );
  }
}
