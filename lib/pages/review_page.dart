// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/slider.dart';
import 'package:justsharelah_v1/widget/toggle_button.dart';
import '../utils/appbar.dart';
import '../utils/bottom_nav_bar.dart';

class MakeReviewPage extends StatefulWidget {
  final String reviewForId;
  const MakeReviewPage({Key? key, required this.reviewForId}) : super(key: key);

  @override
  State<MakeReviewPage> createState() => _MakeReviewPageState();
}

class _MakeReviewPageState extends State<MakeReviewPage> {
  final currUserEmail = FirebaseAuth.instance.currentUser?.email;
  // curruserId
  final currUserId = FirebaseAuth.instance.currentUser?.uid;

  List<bool> isSelected = [true, false, false];
  late int index;
  final TextEditingController _descriptionController = TextEditingController();
  // current user is the reviewBy
  // other user is reviewFor

  String name = '';
  Future<String> getUserName() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    Query userDoc = users.where("uid", isEqualTo: widget.reviewForId);
    // String userName = userDoc.print("hi");
    await userDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        setState(() {
          name = res.docs[0]["username"];
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
    return name;
  }
  // ================ Toggle Button  =============================

  Container toggleButton() => Container(
        color: Color.fromARGB(255, 228, 154, 179),
        child: ToggleButtons(
          isSelected: isSelected,
          selectedColor: Colors.black,
          color: Colors.black,
          fillColor: Colors.green,
          renderBorder: false,
          // splashColor: Colors.red,
          highlightColor: Colors.lightBlue,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Negative', style: TextStyle(fontSize: 18)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Neutral',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Positive', style: TextStyle(fontSize: 18)),
            ),
          ],
          onPressed: (newIndex) {
            setState(() {
              for (int index = 0; index < isSelected.length; index++) {
                if (index == newIndex) {
                  isSelected[index] = true;
                } else {
                  isSelected[index] = false;
                }
              }
              index = newIndex;
              // print(newIndex);
            });
          },
        ),
      );

  // get the feedback
  String getFeedback(int index) {
    if (index == 0) {
      return "Negative";
    } else if (index == 1) {
      return "Neutral";
    } else {
      return "Positive";
    }
  }

  @override
  void initState() {
    super.initState();
    index = 0;
    getUserName();
    toggleButton();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar()
          .buildAppBar(const Text("Leave A Review"), context, '/profile'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "How was the experience?",
                style: kBodyText.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "Give $name an over rating :)",
              style: TextStyle(
                  fontFamily: "Lato",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: 15,
            ),
            toggleButton(),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "Write a review for $name",
              style: TextStyle(
                  fontFamily: "Lobster",
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                obscureText: false,
                controller: _descriptionController,
                textAlign: TextAlign.center,
                minLines: 4,
                maxLines: 6,
                decoration: kTextFormFieldDecoration.copyWith(
                    hintText: 'Describe the experience',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButtonField(
                    "CANCEL", Colors.red, 20.0, context, FeedPage()),
                SizedBox(width: 10.0),
                buildButtonField(
                    "SUBMIT",
                    Colors.green,
                    20.0,
                    context,
                    ProfilePage(
                      email: currUserEmail,
                    )),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
