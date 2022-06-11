import 'package:flutter/material.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Chat"), context, '/feed'),
      body: Container(
        // ignore: prefer_const_constructors
        child: Center(child: Text("Chat")),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
