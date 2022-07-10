import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/AllBorrowing.dart';
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

  // get the borrowing listing data put into future of the build context UI
  // Future<Iterable<Listing>> getBorrowListingData() async {
  //   // listingsCollection = listing table from firebase
  //   final listingsCollection =
  //       FirebaseFirestore.instance.collection('listings');

  //   Iterable<Map<String, dynamic>> listingsData = [];
  //   // if constructor does not take in email -> fetch all items -> to be displayed on feed page
  //   // if take in email -> only fetch items that are created by user -> to be displayed on profile page
  //   Query<Map<String, dynamic>> whereQuery =
  //       userEmailToDisplay!.isEmpty || userEmailToDisplay == null
  //           ? listingsCollection
  //               .where('createdByEmail')
  //               .where('forRent', isEqualTo: true)
  //           : listingsCollection
  //               .where('createdByEmail', isEqualTo: userEmailToDisplay)
  //               .where('forRent', isEqualTo: true);
  //   await whereQuery.get().then(
  //     (res) {
  //       print("listingData query successful");
  //       listingsData = res.docs.map((snapshot) => snapshot.data());
  //       print(listingsData);
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );

  //   Iterable<Listing> parseListingData = listingsData.map((listingMap) {
  //     return Listing(
  //       uid: listingMap["uid"] = listingMap["uid"] ?? "1",
  //       imageUrl: listingMap["imageUrl"] = listingMap["imageUrl"] ??
  //           "https://www.computerhope.com/jargon/g/guest-user.jpg",
  //       title: listingMap["title"],
  //       price: listingMap["price"],
  //       forRent: listingMap["forRent"],
  //       description: listingMap["description"],
  //       available: listingMap["available"],
  //       createdByEmail: listingMap["createdByEmail"],
  //       usersLiked: listingMap["usersLiked"],
  //       dateListed: listingMap["dateListed"] =
  //           listingMap["dateListed"] ?? DateTime(2000, 1, 1, 10, 0, 0),
  //       profImageUrl: listingMap["profImageUrl"] = listingMap["profImageUrl"] ??
  //           "https://www.computerhope.com/jargon/g/guest-user.jpg",
  //       likeCount: listingMap['likeCount'],
  //     );
  //   });

  //   return parseListingData;
  // }

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
                  builder: (context) => AllBorrowing(),
                ));
          },
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('listings')
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
              height: 400,
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
