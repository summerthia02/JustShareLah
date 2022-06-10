import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Chats"), context),
      body: Container(
        child: Center(child: Text("Chat")),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
