import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';

class AddListingPage extends StatelessWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Add Listing")),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
