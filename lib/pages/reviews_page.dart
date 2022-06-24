import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar().buildAppBar(const Text("Leave Review "), context, '/feed'),
      body: ListView(
          // ignore: prefer_const_constructors
          children: [
            Text("Reviews"),
            MySlider(),
          ]),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
