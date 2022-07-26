import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';

import '../pages/profile_page.dart';
import '../utils/const_templates.dart';

class LikeCard extends StatefulWidget {
  LikeCard({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  State<LikeCard> createState() => _LikeCardState();
}

class _LikeCardState extends State<LikeCard> {
  // each uid ->grab the username and profile picture

  String name = "";
  String profPicUrl = "";
  String email = "";

  // for each listing, access the field "usersLiked"
  // in this array, there are UIDs of users who have liked

  // get email

  Future<String> getEmail() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    DocumentReference username = users.doc("userName");
    // get username
    Query userDoc = users.where("uid", isEqualTo: widget.uid);
    // String userName = userDoc.print("hi");
    await userDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        email = res.docs[0]["email"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return email;
  }

  Future<String> getUserName() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    // get username
    Query userDoc = users.where("uid", isEqualTo: widget.uid);
    // String userName = userDoc.print("hi");
    await userDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        name = res.docs[0]["username"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return name;
  }

  Future<String> getProfilePicture() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    // get username
    Query userDoc = users.where("uid", isEqualTo: widget.uid);
    // String userName = userDoc.print("hi");
    await userDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        setState(() {
          profPicUrl = res.docs[0]["imageUrl"];
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
    return profPicUrl;
  }

  // String name;
  @override
  void initState() {
    super.initState();
    getUserName();
    getProfilePicture();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 30, left: 60),
              child: ProfileWidget(
                imageUrl: profPicUrl,
                onClicked: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          email: email,
                        ),
                      ))
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 20,
              width: 200,
              child: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                      color: Colors.cyan)),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Colors.black,
          thickness: 0.5,
          indent: 30.0,
          endIndent: 30,
        )
      ],
    );
  }
}
