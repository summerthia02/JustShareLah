import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/AllRenting.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

class ForRenting extends StatelessWidget {
  ForRenting({
    Key? key,
    this.userEmailToDisplay = "",
  }) : super(key: key);

  late String? userEmailToDisplay;

  Future<Iterable<Listing>> getRentListingData() async {
    final listingsCollection =
        FirebaseFirestore.instance.collection('listings');
    Iterable<Map<String, dynamic>> listingsData = [];
    Query<Map<String, dynamic>> whereQuery =
        userEmailToDisplay!.isEmpty || userEmailToDisplay == null
            ? listingsCollection
                .where('createdByEmail')
                .where('forRent', isEqualTo: true)
            : listingsCollection
                .where('createdByEmail', isEqualTo: userEmailToDisplay)
                .where('forRent', isEqualTo: true);
    await whereQuery.get().then(
      (res) {
        print("listingData query successful");
        listingsData = res.docs.map((snapshot) => snapshot.data());
      },
      onError: (e) => print("Error completing: $e"),
    );

    Iterable<Listing> parseListingData = listingsData.map((listingMap) {
      return Listing(
        uid: listingMap["uid"] = listingMap["uid"] ?? "1",
        available: listingMap["available"],
        createdByEmail: listingMap["createdByEmail"],
        dateListed: listingMap["dateListed"] =
            listingMap["dateListed"] ?? DateTime(2000, 1, 1, 10, 0, 0),
        description: listingMap["description"],
        forRent: listingMap["forRent"],
        imageUrl: listingMap["imageUrl"] = listingMap["imageUrl"] ??
            "https://www.computerhope.com/jargon/g/guest-user.jpg",
        likeCount: listingMap['likeCount'],
        price: listingMap["price"],
        profImageUrl: listingMap["profImageUrl"] = listingMap["profImageUrl"] ??
            "https://www.computerhope.com/jargon/g/guest-user.jpg",
        title: listingMap["title"],
        usersLiked: listingMap["usersLiked"],
      );
    });

    return parseListingData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeedTitle(
          title: "For Renting",
          pressSeeAll: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllRenting(),
                ));
          },
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder<Iterable<Listing>>(
              future: getRentListingData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("Error loading renting items");
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
