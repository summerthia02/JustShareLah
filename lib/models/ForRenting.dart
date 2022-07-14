import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/AllBorrowing.dart';
import 'package:justsharelah_v1/models/AllRenting.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

// class _ForBorrowingState extends State<ForBorrowing> {
class ForRenting extends StatelessWidget {
  ForRenting({
    Key? key,
    this.userEmailToDisplay = "",
  }) : super(key: key);

  late String? userEmailToDisplay;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        FeedTitle(
          title: "For Renting",
          pressSeeAll: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllRenting(
                    userEmailToDisplay: userEmailToDisplay,
                  ),
                ));
          },
        ),
        StreamBuilder(
          stream: userEmailToDisplay!.isEmpty || userEmailToDisplay == null
              ? FirebaseFirestore.instance
                  .collection('listings')
                  .where('forRent', isEqualTo: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('listings')
                  .where('createdByEmail', isEqualTo: userEmailToDisplay)
                  .where('forRent', isEqualTo: true)
                  .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Text("Awaiting result...");
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Text("Error Loading Borrowing Items");
            }

            // Iterable<Listing>? listingDataIterable = snapshot.data!;
            // if (listingDataIterable == null ||
            //     listingDataIterable.isEmpty) {
            //   return const Text("No such listings :(");
            // }
            // List<Listing> listingData = listingDataIterable.toList();
            return SizedBox(
              height: 450,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // docs method gives us list of document id of the listings
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: ListingCard(
                          // collect the data for each indiviudal document at the index
                          snap: snapshot.data!.docs[index].data(),
                          // image: listingData[index].imageUrl,
                          // title: listingData[index].title,
                          // price: listingData[index].price,
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnlargedScreen(
                                      snap: snapshot.data!.docs[index].data()),
                                ));
                          },
                        ),
                      )),
            );

            // // print("going to cast listing data");

            // // return Row(
            // //     crossAxisAlignment: CrossAxisAlignment.start,
            // //     children: List.generate(
            // //       listingData.length,
            // //       (index) => Padding(
            // //         padding: const EdgeInsets.only(right: defaultPadding),
            // //         child: ListingCard(
            // //           image: listingData[index].imageUrl,
            // //           title: listingData[index].title,
            // //           price: listingData[index].price,
            // //           press: () {
            // //             Navigator.push(
            // //                 context,
            // //                 MaterialPageRoute(
            // //                   builder: (context) => EnlargedScreen(
            // //                       listing: listingData[index]),
            // //                 ));
            // //           },
            //         ),
            //       ),
            //     ));
          },
        )
      ],
    );
  }
}
