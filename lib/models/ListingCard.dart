import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/user_data.dart';

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
            SizedBox(
              width: 10,
            ),
            Text(name, style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        GestureDetector(
          onTap: widget.press,
          child: Container(
            padding: const EdgeInsets.all(6),
            height: 350,
            width: 250,
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadius))),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 90 / 100,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 162, 202, 197),
                        borderRadius: BorderRadius.all(
                            Radius.circular(defaultBorderRadius))),
                    child: Image.network(widget.snap["imageUrl"].toString(),
                        scale: 1.5, fit: BoxFit.scaleDown),
                  ),
                ),
                SizedBox(
                  height: 20,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
