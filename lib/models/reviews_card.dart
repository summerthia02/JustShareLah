import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';

class ReviewCard extends StatefulWidget {
  ReviewCard({
    Key? key,
    this.snap,
    required this.profileUid,
    // required this.reviewId,
    // required this.reviewForUid,
    // required this.reviewByUid,
  }) : super(key: key);

  // profileUid -> profile page uid
  // reviewFor -> review For who uid
  // reviewBy -> review by who uid
  // reviewid -> Id for the review
  final snap;
  String profileUid;
  // String reviewId;
  // String reviewForUid;
  // String reviewByUid;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  // for each transactions, there are two reviews
  // get the review whereby reviewFor == profileUid
  // don't use the review where profildUid == reviewBy (should be shown in the other's profile)

  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userId;
  // to choose which reviewId is shown

  String name = "";
  String profPicUrl = "";
  String listingTitle = "";
  String listingUrl = "";
  // get listing details from the listing Id
  // listing title
  Future<String> getListingTitle() async {
    CollectionReference listings =
        FirebaseFirestore.instance.collection("listings");
    // get username for particular reviewer
    Query listingsDoc =
        listings.where("uid", isEqualTo: widget.snap["listingId"]);

    // String userName = userDoc.print("hi");
    await listingsDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        listingTitle = res.docs[0]["title"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return listingTitle;
  }

  // listing image

  Future<String> getListingImage() async {
    CollectionReference listings =
        FirebaseFirestore.instance.collection("listings");
    // get username for particular reviewer
    Query listingsDoc =
        listings.where("uid", isEqualTo: widget.snap["listingId"]);

    // String userName = userDoc.print("hi");
    await listingsDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        listingUrl = res.docs[0]["imageUrl"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return listingUrl;
  }

  // get username of reviewBy
  Future<String> getUserName() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    // get username for particular reviewer
    Query reviewerDoc =
        users.where("uid", isEqualTo: widget.snap["reviewById"]);

    // String userName = userDoc.print("hi");
    await reviewerDoc.get().then(
      (res) {
        print("listingData query successful");
        // userData = res.docs.map((snapshot) => snapshot.data());

        name = res.docs[0]["username"];
      },
      onError: (e) => print("Error completing: $e"),
    );

    return name;
  }

  // get profile picture of reviewBy
  Future<String> getProfilePicture() async {
    CollectionReference reviews =
        FirebaseFirestore.instance.collection("Users");
    // get username
    Query reviewerDoc =
        reviews.where("uid", isEqualTo: widget.snap["reviewById"]);
    // String userName = userDoc.print("hi");
    await reviewerDoc.get().then(
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
    getListingTitle();
    getListingImage();
    userId = currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileWidget(
            imageUrl: profPicUrl,
            onClicked: () => {},
          ),
          const SizedBox(
            width: 10,
          ),
          Text(name,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),

      // Negative / Neutral / Positve
      Container(
        child: widget.snap["feedback"],
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        child: widget.snap["description"],
      ),
      SizedBox(
        height: 15,
      ),
      // listing title and photo
      Column(
        children: [
          Text(listingTitle),
          ClipRRect(
            child: Image(image: NetworkImage(listingUrl)),
          )
        ],
      ),
    ]);
  }
}
