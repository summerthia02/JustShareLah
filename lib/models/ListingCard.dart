import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justsharelah_v1/firebase/auth_provider.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/pages/edit_listing.dart';
import 'package:justsharelah_v1/provider/user_provider.dart';
import 'package:justsharelah_v1/utils/time_helper.dart';
import 'package:justsharelah_v1/widget/like_helper.dart';

import '../utils/const_templates.dart';

class ListingCard extends StatefulWidget {
  const ListingCard({Key? key, this.snap, this.uid, required this.press})
      : super(key: key);

  final snap;
  final uid;

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
  String profPicUrl = "";

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

        name = res.docs[0]["username"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return name;
  }

  Future<String> getProfilePicture() async {
    String email = widget.snap["createdByEmail"].toString();
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    DocumentReference profilePic = users.doc("imageUrl");
    Iterable<Map<String, dynamic>> userData = [];
    // get username
    Query userDoc = users.where("email", isEqualTo: email);
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
    userId = currentUser?.uid;
  }

  // ================ Edit Listing Button + Pop Up  =============

  // ignore: non_constant_identifier_names
  EditListing(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Edit Listing'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Edit Listing Details'),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditListingPage(
                          snap: widget.snap,
                        ),
                      ));
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 11, backgroundImage: NetworkImage(profPicUrl)),
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
                          child: Image.network(
                              widget.snap["imageUrl"].toString(),
                              scale: 1.5,
                              fit: BoxFit.scaleDown)),
                    ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: widget.snap["createdByEmail"] ==
                                  currentUser!.email
                              ? IconButton(
                                  icon: const Icon(Icons.more_vert,
                                      color: Colors.black, size: 30),
                                  onPressed: () {
                                    EditListing(context);
                                  },
                                )
                              : Container()),
                    ),
                    Positioned(
                      top: 15,
                      left: 3,
                      child: Container(
                        height: 30,
                        width: 30,
                        child: widget.snap["usersLiked"].contains(userId)
                            ? const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),

                // ignore: prefer_const_literals_to_create_immutables
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.snap["usersLiked"].length != 1
                        ? "${widget.snap["usersLiked"].length} likes"
                        : "1 like",
                  ),
                ),
                Row(children: [
                  Expanded(
                      child: Text(
                    widget.snap['title'],
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.snap['location'],
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
