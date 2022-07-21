// share credits rewards page
// only for lending / borrowing listings

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';

class ShareCreditsScreen extends StatefulWidget {
  const ShareCreditsScreen({Key? key}) : super(key: key);

  @override
  State<ShareCreditsScreen> createState() => ShareCreditsScreenState();
}

class ShareCreditsScreenState extends State<ShareCreditsScreen> {
  ElevatedButton buildButtonField(
      String text, Color color, double length, void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: length),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15, letterSpacing: 2.5, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("images/sharecredits.png"),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 15, right: 20, top: 15),
          child: Text(
            "Congratulations! You have earned 20 ShareCredits !",
            style: kHeadingText.copyWith(backgroundColor: Colors.greenAccent),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        buildButtonField("Yay, Thanks!", Colors.green, 20, () {
          Navigator.pushReplacementNamed(context, "/profile");
        })
      ],
    ));
  }
}
