import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'dart:async';

import 'package:justsharelah_v1/utils/profile_image.dart';
import 'package:justsharelah_v1/utils/time_helper.dart';

class EnlargedScreen extends StatefulWidget {
  const EnlargedScreen({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<EnlargedScreen> createState() => _EnlargedScreenState();
}

class _EnlargedScreenState extends State<EnlargedScreen> {
  bool showHeart = false;
  bool isLiked = false;
  // late int? likeCount = snap["ikeCount"];
  int doubleTapCounter = 0;
  bool hasClickedHeart = false;

  // doubleTap() {
  //   setState(() {
  //     showHeart = true;
  //     isLiked = true;
  //     doubleTapCounter++;

  //     if (showHeart) {
  //       Timer(const Duration(milliseconds: 400), () {
  //         setState(() {
  //           showHeart = false;
  //           if (likeCount != null &&
  //               doubleTapCounter == 1 &&
  //               !hasClickedHeart) {
  //             likeCount = likeCount! + 1;
  //           } else {
  //             likeCount = 1;
  //           }
  //         });
  //       });
  //     }
  //   });
  // }

  // clickHeart() {
  //   setState(() {
  //     hasClickedHeart = true;
  //     isLiked = !isLiked;
  //     if (!isLiked && likeCount != null) {
  //       likeCount = likeCount! - 1;
  //     } else if (isLiked && likeCount != null) {
  //       likeCount = likeCount! + 1;
  //     } else {
  //       likeCount = 1;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF2),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(10)),
          PostedBy(snap: widget.snap),
          GestureDetector(
              onDoubleTap: () {},
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ListingImage(
                    snap: widget.snap,
                  ),
                  AnimatedCrossFade(
                    firstChild:
                        Icon(Icons.favorite, color: Colors.red, size: 100.0),
                    secondChild:
                        Icon(Icons.favorite_border, color: Colors.transparent),
                    crossFadeState: showHeart
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 200),
                  )
                ],
              )),
          const SizedBox(height: defaultPadding * 1.5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(defaultPadding,
                  defaultPadding * 2, defaultPadding, defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius * 3),
                  topRight: Radius.circular(defaultBorderRadius * 3),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // listing title, price, description
                    IconButton(
                      alignment: Alignment.topLeft,
                      icon: isLiked
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: isLiked ? Colors.red : Colors.grey,
                      onPressed: () {},
                    ),
                    // LikeCounts(likeCount: likeCount == null ? 0 : likeCount),
                    ListingCardDetails(snap: widget.snap),
                    Text(
                      "Listed on " + convertedTime(widget.snap["dateListed"]),
                    ),
                    const SizedBox(height: (defaultPadding)),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                              shape: const StadiumBorder()),
                          child: const Text("Chat"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PostedBy extends StatefulWidget {
  const PostedBy({Key? key, required this.snap}) : super(key: key);

  final snap;
  @override
  State<PostedBy> createState() => _PostedByState();
}

class _PostedByState extends State<PostedBy> {
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

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          ProfileWidget(
            imageUrl: widget.snap["profImageUrl"],
            onClicked: () => {},
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            name,
          ),
        ]));
  }
}

// show the number of likes

class LikeCounts extends StatefulWidget {
  const LikeCounts({Key? key, required this.likeCount}) : super(key: key);
  final int? likeCount;

  @override
  State<LikeCounts> createState() => _LikeCountsState();
}

class _LikeCountsState extends State<LikeCounts> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.likeCount.toString() + " likes",
      style: kBodyTextSmall.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class ListingImage extends StatelessWidget {
  const ListingImage({Key? key, required this.snap}) : super(key: key);

  final snap;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      snap["imageUrl"],
      height: MediaQuery.of(context).size.height * 0.5,
      scale: 0.5,
      fit: BoxFit.cover,
    );
  }
}

class ListingCardDetails extends StatelessWidget {
  const ListingCardDetails({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                snap["title"],
                style: kHeadingText,
              ),
            ),
            const SizedBox(width: defaultPadding),
            Text(
              "\$" + snap["price"].toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(snap["description"].toString(), style: kBodyTextSmall,),
      ],
    );
  }
}
