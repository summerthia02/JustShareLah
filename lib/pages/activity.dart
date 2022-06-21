import 'package:flutter/material.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar()
          .buildAppBar(const Text("Latest Activities"), context, '/feed'),
      body: Container(
        child: Center(child: Text("Activity")),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
