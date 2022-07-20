import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/AllBorrowing.dart';
import 'package:justsharelah_v1/models/like_card.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

// class _LikePageState extends State<LikePage> {
class LikePage extends StatefulWidget {
  LikePage({Key? key, required this.usersLiked}) : super(key: key);

  List<dynamic> usersLiked;

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  List<QueryDocumentSnapshot> listingData = [];
  @override
  Widget build(BuildContext context) {
    // print(widget.usersLiked);
    // take in listing id as the argument
    // from listing id, find this particular listing -> usersLiked field -> add to a list

    List<dynamic> likedBy = [];

    // copy the usersLIked array into a list to likedBy
    likedBy = List.from(widget.usersLiked);
    void initState() {
      super.initState();
      // getListingsLikes();
    }

    // print(likedBy);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Container(child: Text("LIKES"))),
        // check the list before creating list view
        body: likedBy.isEmpty
            ? Center(
                child: Text(
                    "No likes yet.. Be the first to like this listing! ",
                    textAlign: TextAlign.center,
                    style: kJustShareLahStyle.copyWith(color: Colors.black)))
            : ListView.builder(
                itemCount: likedBy.length,
                itemBuilder: (context, index) {
                  return LikeCard(uid: likedBy[index]);
                }));
  }
}
