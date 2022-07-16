import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/firebase/auth_provider.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/provider/user_provider.dart';
import 'package:justsharelah_v1/utils/time_helper.dart';
import 'package:justsharelah_v1/widget/like_helper.dart';

import '../utils/const_templates.dart';

class ListingCard extends StatefulWidget {
  const ListingCard({Key? key, this.snap, required this.press})
      : super(key: key);

  final snap;
  // final String image, title, price;
  final VoidCallback press;

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userId;
  bool isLiking = false;

  String name = "";

  Future<String> getUserName() async {
    String email = widget.snap["createdByEmail"].toString();
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    DocumentReference username = users.doc("userName");
    Iterable<Map<String, dynamic>> userData = [];
    // get username
    Query userDoc = users.where("email", isEqualTo: email);
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

  // String name;
  @override
  void initState() {
    super.initState();
    getUserName();
    userId = currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 11,
              backgroundImage:
                  NetworkImage(widget.snap['profImageUrl'].toString()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        GestureDetector(
          onTap: widget.press,
          child: Container(
            padding: const EdgeInsets.all(6),
            height: 400,
            width: 250,
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadius))),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 90 / 100,
                      child: Container(
                        width: 500,
                        height: 500,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 162, 202, 197),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultBorderRadius))),
                        child: Image.network(widget.snap["imageUrl"].toString(),
                              scale: 1.5, fit: BoxFit.scaleDown)
                      ),
                    ),
                  ],
                ),

                // ignore: prefer_const_literals_to_create_immutables

                Row(children: [
                  Expanded(
                      child: Text(
                    widget.snap['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '\$' + widget.snap['price'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Text(snap['usersLiked'] == null
                  //     ? '${snap['usersLiked'].length!} likes'
                  //     : "0 Likes"),
                ]),
                Row(
                  children: [
                    Text(
                      "Listed " + timeDisplayed(widget.snap['dateListed']),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
