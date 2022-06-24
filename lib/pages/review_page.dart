import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class MakeReviewPage extends StatelessWidget {
  const MakeReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar()
          .buildAppBar(const Text("Leave A Review"), context, '/feed'),
      body: ListView(
        children: [
          Text(
            "How was the experience?",
            style: kBodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "Give John a rating out of 10",
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 14.0,
                fontWeight: FontWeight.w300),
          ),
          MySlider(),
          Text(
            "Write a review for the buyer",
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 14.0,
                fontWeight: FontWeight.w300),
          ),
          TextFormField(
            obscureText: false,
            textAlign: TextAlign.center,
            decoration: kTextFormFieldDecoration.copyWith(
                hintText: 'Describe the experience',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ],
        // ignore: prefer_const_constructors
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
