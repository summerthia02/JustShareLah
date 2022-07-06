import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'dart:async';

import 'package:justsharelah_v1/utils/profile_image.dart';

class EnlargedScreen extends StatefulWidget {
  const EnlargedScreen({Key? key, required this.listing}) : super(key: key);
  final Listing listing;

  @override
  State<EnlargedScreen> createState() => _EnlargedScreenState();
}

class _EnlargedScreenState extends State<EnlargedScreen> {
  bool showHeart = false;
  bool isLiked = false;
  late int? likeCount = widget.listing.likeCount;
  int doubleTapCounter = 0;
  bool hasClickedHeart = false;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;
  late UserData userData = UserData.defaultUserData();
  Uint8List? _image;

  // access the usertable, then get the data where email field == current email
  Future<Map<String, dynamic>> _getUserData() async {
    Map<String, dynamic> userData = <String, dynamic>{};
    await usersCollection.where('email', isEqualTo: userEmail).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userData;
  }

  @override
  void initState() {
    // get the email of the current user
    userEmail = currentUser?.email;
    // initialize state by calling _getUserData which has curr user email
    _getUserData().then((data) {
      UserData parseUserData = UserData(
        uid: currentUser?.uid,
        userName: data["username"],
        firstName: data["first_name"],
        lastName: data["last_name"],
        email: userEmail,
        phoneNumber: data["phone_number"],
        about: data["about"],
        imageUrl: data["image_url"],
        listings: data["listings"],
        reviews: data["reviews"],
        shareCredits: data["share_credits"],
      );
      setState(() {
        userData = parseUserData;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  doubleTap() {
    setState(() {
      showHeart = true;
      isLiked = true;
      doubleTapCounter++;

      if (showHeart) {
        Timer(const Duration(milliseconds: 400), () {
          setState(() {
            showHeart = false;
            if (likeCount != null &&
                doubleTapCounter == 1 &&
                !hasClickedHeart) {
              likeCount = likeCount! + 1;
            } else {
              likeCount = 1;
            }
          });
        });
      }
    });
  }

  clickHeart() {
    setState(() {
      hasClickedHeart = true;
      isLiked = !isLiked;
      if (!isLiked && likeCount != null) {
        likeCount = likeCount! - 1;
      } else if (isLiked && likeCount != null) {
        likeCount = likeCount! + 1;
      } else {
        likeCount = 1;
      }
    });
  }

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
          PostedBy(
            username: userData.userName,
            imageUrl: userData.imageUrl,
          ),
          GestureDetector(
              onDoubleTap: () => doubleTap(),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ListingImage(listing: widget.listing),
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
                      onPressed: () => clickHeart(),
                    ),
                    LikeCounts(likeCount: likeCount == null ? 0 : likeCount),
                    ListingCardDetails(listing: widget.listing),
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

class PostedBy extends StatelessWidget {
  const PostedBy({Key? key, required this.username, required this.imageUrl})
      : super(key: key);

  final String? username;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          CircleAvatar(backgroundImage: NetworkImage(imageUrl!), radius: 30),
          SizedBox(
            width: 10.0,
          ),
          Text(
            username!,
            style: kBodyTextSmall,
          ),
          SizedBox(
            width: 140.0,
          ),
          IconButton(
            alignment: Alignment.topRight,
            iconSize: 20,
            onPressed: () {
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) {
                  return Dialog(
                    child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: ['Edit', 'Delete']
                            .map(
                              (e) => InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                  onTap: () {
                                    // deletePost(
                                    //   widget.snap['postId'].toString(),
                                    // );
                                    // // remove the dialog box
                                    // Navigator.of(context).pop();
                                  }),
                            )
                            .toList()),
                  );
                },
              );
            },
            icon: const Icon(Icons.more_vert),
          )
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
  const ListingImage({Key? key, required this.listing}) : super(key: key);

  final Listing listing;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      listing.imageUrl,
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.cover,
    );
  }
}

class ListingCardDetails extends StatelessWidget {
  const ListingCardDetails({Key? key, required this.listing}) : super(key: key);
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                listing.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(width: defaultPadding),
            Text(
              "\$" + listing.price.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(listing.description.toString()),
      ],
    );
  }
}
