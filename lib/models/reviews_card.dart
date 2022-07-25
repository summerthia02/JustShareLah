import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';

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

  // get face pic
  String getFacePic() {
    if (widget.snap["feedback"] == "Positive") {
      return "images/happy_face.png";
    } else if (widget.snap["feedback"] == "Negative") {
      return "images/sad.png";
    } else {
      return "images/neutral_face.png";
    }
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
    getFacePic();
    userId = currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileWidget(
              imageUrl: profPicUrl,
              onClicked: () => {},
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 100),
              child: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
            ),
          ],
        ),

        // Negative / Neutral / Positve
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      listingTitle,
                      style: kBodyText,
                    ),
                    ClipRRect(
                      child: Image(
                        image: NetworkImage(listingUrl),
                        width: 125,
                        height: 125,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(
                            widget.snap["feedback"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan),
                          ),
                        ),
                        Image.asset(
                          getFacePic(),
                          scale: 12,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(widget.snap["description"]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            ),
            // listing title and photo
          ],
        ),
        const Divider(
          thickness: 1.0,
          color: Colors.black,
        ),
      ],
    );
  }
}
