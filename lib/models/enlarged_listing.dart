import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justsharelah_v1/firebase/auth_methods.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/models/chats/chat_item.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';
import 'package:justsharelah_v1/pages/chat_item_page.dart';
import 'package:justsharelah_v1/pages/like_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/provider/chat_provider.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'dart:async';

import 'package:justsharelah_v1/utils/profile_image.dart';
import 'package:justsharelah_v1/utils/time_helper.dart';

import 'package:justsharelah_v1/widget/like_helper.dart';

class EnlargedScreen extends StatefulWidget {
  const EnlargedScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);
  final snap;

  @override
  State<EnlargedScreen> createState() => _EnlargedScreenState();
}

class _EnlargedScreenState extends State<EnlargedScreen> {
  bool isLiking = false;
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userId;

  @override
  void initState() {
    super.initState();
    userId = currentUser?.uid;
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
          PostedBy(snap: widget.snap),
          GestureDetector(
              onDoubleTap: () async {
                await FireStoreMethods().likelisting(
                    widget.snap["uid"].toString(),
                    userId!,
                    widget.snap["usersLiked"]);

                setState(() {
                  isLiking = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    child: ListingImage(
                      snap: widget.snap,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: isLiking ? 1 : 0,
                    child: LikeHelper(
                      child: const Icon(Icons.favorite,
                          color: Colors.white, size: 100),
                      isLiking: isLiking,
                      duration: const Duration(
                        milliseconds: 350,
                      ),
                      onEnd: () {
                        setState(() {
                          isLiking = false;
                        });
                      },
                    ),
                  ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: LikeHelper(
                              smallHeart: true,
                              isLiking:
                                  widget.snap["usersLiked"].contains(userId),
                              child: IconButton(
                                  onPressed: () async {
                                    // print(
                                    //   widget.snap["uid"].toString(),
                                    // );
                                    print(widget.snap["uid"]);

                                    await FireStoreMethods().likelisting(
                                        widget.snap["uid"].toString(),
                                        userId!,
                                        widget.snap["usersLiked"]);
                                  },
                                  icon:
                                      widget.snap["usersLiked"].contains(userId)
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey,
                                            ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LikePage(
                                      usersLiked: widget.snap["usersLiked"],
                                    ),
                                  ));
                            },
                            child: Text(
                              widget.snap["usersLiked"].length != 1
                                  ? "${widget.snap["usersLiked"].length} likes"
                                  : "1 like",
                              style: kBodyTextSmall,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // listing title, price, description
                    // IconButton(
                    //   alignment: Alignment.topLeft,
                    //   icon: isLiked
                    //       ? Icon(Icons.favorite)
                    //       : Icon(Icons.favorite_border),
                    //   color: isLiked ? Colors.red : Colors.grey,
                    //   onPressed: () {},
                    // ),
                    // LikeCounts(likeCount: likeCount == null ? 0 : likeCount),
                    ListingCardDetails(snap: widget.snap),
                    Text(
                      "Listed on ${convertedTime(
                        widget.snap["dateListed"],
                      )}",
                      style: kBodyTextSmall,
                    ),
                    // LikeCounts(likeCount: likeCount == null ? 0 : likeCount),
                    Text(
                      widget.snap["location"],
                      style: TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: (defaultPadding)),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onChatPressed,
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

  void onChatPressed() async {
    Map<String, dynamic> sellerData =
        await UserDataService.getUserData(widget.snap["createdByEmail"]);
    Map<String, dynamic> userData =
        await UserDataService.getUserData(currentUser!.email!);

    String listingId = widget.snap["uid"];
    String sellerId = sellerData["uid"];
    String chattingWithId = userData["uid"];
    String groupChatId;
    if (chattingWithId.compareTo(sellerId) > 0) {
      groupChatId = '$listingId : $chattingWithId - $sellerId';
    } else {
      groupChatId = '$listingId : $sellerId - $chattingWithId';
    }

    ChatItem chatItem = ChatItem(
        groupChatId: groupChatId,
        sellerId: sellerId,
        chattingWithId: chattingWithId,
        listingId: listingId);
    ChatProvider.handleChatRequest(chatItem);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatItemPage(
              otherId: sellerData["uid"],
              otherAvatar: sellerData["imageUrl"],
              otherNickname: sellerData["username"],
              userProfPicUrl: userData["imageUrl"],
              otherPhoneNumber: sellerData["phone_number"],
              listingId: listingId,
              listingTitle: widget.snap["title"],
            )));
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
  String profPicUrl = "";
  // getting the username directly from the database
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

  @override
  void initState() {
    super.initState();
    getUserName();
    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          ProfileWidget(
            imageUrl: profPicUrl,
            onClicked: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      email: widget.snap["createdByEmail"],
                    ),
                  ))
            },
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
      "${widget.likeCount} likes",
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
                style: kHeadingText.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            snap["forRent"] == true ? Text("\$") : Container(),
            Text(
              snap["forRent"] == true
                  ? snap['price'].toString()
                  : snap["shareCredits"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            snap["forRent"] == false ? Text(" SC") : Container(),
          ],
        ),
        Text(
          snap["description"].toString(),
          style: kBodyTextSmall,
        ),
        Row(
          children: [
            Text("Availability: ",
                style: kBodyTextSmall.copyWith(fontWeight: FontWeight.w500)),
            snap["available"]
                ? Row(
                    children: const [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      Text(
                        "Currently Available",
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  )
                : Row(
                    children: const [
                      Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                      Text(
                        "Currently Unavailable. Chat for more info! ",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
          ],
        ),
      ],
    );
  }
}
