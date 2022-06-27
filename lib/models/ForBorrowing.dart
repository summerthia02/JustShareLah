import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

// class ForBorrowing extends StatefulWidget {
//   const ForBorrowing({Key? key, String? userEmail}) : super(key: key);

//   @override
//   _ForBorrowingState createState() => _ForBorrowingState();
// }

// class _ForBorrowingState extends State<ForBorrowing> {
class ForBorrowing extends StatelessWidget {
  ForBorrowing({
    Key? key,
    this.userEmailToDisplay = "",
  }) : super(key: key);

  late String? userEmailToDisplay;

  Future<Iterable<Listing>> _getBorrowListingData() async {
    final listingsCollection =
        FirebaseFirestore.instance.collection('listings');
    Iterable<Map<String, dynamic>> listingsData = [];
    // if constructor does not take in email -> fetch all items -> to be displayed on feed page
    // if take in email -> only fetch items that are created by user -> to be displayed on profile page
    Query<Map<String, dynamic>> whereQuery =
        userEmailToDisplay!.isEmpty || userEmailToDisplay == null
            ? listingsCollection
                .where('created_by_email')
                .where('for_rent', isEqualTo: false)
            : listingsCollection
                .where('created_by_email', isEqualTo: userEmailToDisplay)
                .where('for_rent', isEqualTo: false);
    await whereQuery.get().then(
      (res) {
        print("listingData query successful");
        listingsData = res.docs.map((snapshot) => snapshot.data());
      },
      onError: (e) => print("Error completing: $e"),
    );

    Iterable<Listing> parseListingData = listingsData.map((listingMap) {
      return Listing(
          imageUrl: listingMap["image_url"],
          title: listingMap["title"],
          price: listingMap["price"],
          forRent: listingMap["for_rent"],
          description: listingMap["description"],
          available: listingMap["available"],
          createdByEmail: listingMap["created_by_email"]);
    });

    return parseListingData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeedTitle(
          title: "For Borrowing",
          pressSeeAll: () {},
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder<Iterable<Listing>>(
              future: _getBorrowListingData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("Error loading borrowing items");
                } else if (!snapshot.hasData) {
                  return const Text("Awaiting result...");
                }

                print("going to cast listing data");
                Iterable<Listing>? listingDataIterable = snapshot.data;
                if (listingDataIterable == null ||
                    listingDataIterable.isEmpty) {
                  return const Text("No such listings :(");
                }
                List<Listing> listingData = listingDataIterable.toList();

                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      listingData.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: defaultPadding),
                        child: ListingCard(
                          image: listingData[index].imageUrl,
                          title: listingData[index].title,
                          price: listingData[index].price,
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnlargedScreen(
                                      listing: listingData[index]),
                                ));
                          },
                        ),
                      ),
                    ));
              },
            ))
      ],
    );
  }
}
