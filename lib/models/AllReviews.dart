import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/reviews_card.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';

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
    List<QueryDocumentSnapshot> reviewsData = [];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:
            ListView(padding: const EdgeInsets.all(defaultPadding), children: [
          Text(
            "All Reviews",
            textAlign: TextAlign.start,
            style: kJustShareLahStyle.copyWith(
                fontSize: 50, fontWeight: FontWeight.w200),
          ),
          const SizedBox(
            height: 10,
          ),
          // SHOW ALL REVIEWS for a particular profile
          // for each transactions, there are two reviews
          // don't use the review where profildUid == reviewBy (should be shown in the other's profile)
          // get the review whereby reviewFor == profileUid

          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Reviews")
                .where('reviewForId', isEqualTo: profileUid)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                reviewsData = snapshot.data!.docs;
                if (reviewsData.isEmpty) {
                  return Container(
                      padding: const EdgeInsets.only(
                          bottom: 180, top: 180, right: 25, left: 25),
                      child: const Text(
                        "No Reviews Yet :(",
                        style: kJustShareLahStyle,
                      ));
                }
              }
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
              return SizedBox(
                height: 450,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    // docs method gives us list of document id of the listings
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
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
        ]));
  }
}
