import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/AllBorrowing.dart';
import 'package:justsharelah_v1/models/reviews_card.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

// class _AllReviewsState extends State<AllReviews> {
class AllReviews extends StatelessWidget {
  AllReviews({
    Key? key,
    required this.profileUid,
  }) : super(key: key);

  late String? userEmailToDisplay;
  String profileUid;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    CollectionReference reviews =
        FirebaseFirestore.instance.collection("Reviews");
    return Column(
      children: [
        Text("ALL REVIEWS"),

        // SHOW ALL REVIEWS for a particular profile
        // for each transactions, there are two reviews
        // don't use the review where profildUid == reviewBy (should be shown in the other's profile)
        // get the review whereby reviewFor == profileUid

        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Reviews")
              .where('reviewFor', isEqualTo: profileUid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null) {
              return const Text("No Reviews Yet :( ");
            } else if (!snapshot.hasData) {
              return const Text("Awaiting result...");
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text("Error Loading Reviews ");
            }

            return Container(
              height: 450,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  // docs method gives us list of document id of the listings
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: SafeArea(
                          child: ReviewCard(
                              // collect the data for each indiviudal document at the index
                              snap: snapshot.data!.docs[index].data(),
                              profileUid: profileUid),
                        ),
                      )),
            );
          },
        )
      ],
    );
  }
}
