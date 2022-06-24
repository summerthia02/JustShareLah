import 'package:flutter/material.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar().buildAppBar(const Text("Leave Review"), context, '/feed'),
      body: Container(
        // ignore: prefer_const_constructors
        child: Center(child: Text("Reviews")),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
