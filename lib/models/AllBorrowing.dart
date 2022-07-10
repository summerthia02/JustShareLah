import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/BigListingCard.dart';
import 'package:justsharelah_v1/models/ForBorrowing.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

// class _AllBorrowingState extends State<AllBorrowing> {
class AllBorrowing extends StatelessWidget {
  AllBorrowing({
    Key? key,
    this.userEmailToDisplay = "",
    snap,
  }) : super(key: key);

  late String? userEmailToDisplay;
  // Future<Iterable<Listing>> borrowingData =
  //     ForBorrowing().getBorrowListingData();

  // get the borrowing listing data put into future of the build context UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/location.png', width: 40, height: 30),
              const SizedBox(width: 10.0),
              Text(
                "NUS, Singapore",
              )
            ],
          ),
        ),
        body:
            ListView(padding: const EdgeInsets.all(defaultPadding), children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Explore",
              textAlign: TextAlign.start,
              style: kJustShareLahStyle.copyWith(
                  fontSize: 35, fontWeight: FontWeight.w500),
            ),
            const Text(
              'Listings For Borrowing',
              style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
            ),
            const SizedBox(height: defaultPadding),
            Form(
                child: TextFormField(
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: "Search for Listings to Borrow",
                  prefixIcon: Icon(Icons.search_rounded)),
            )),
          ]),
          StreamBuilder(
            stream: userEmailToDisplay!.isEmpty || userEmailToDisplay == null
                ? FirebaseFirestore.instance
                    .collection('listings')
                    .where('forRent', isEqualTo: false)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('listings')
                    .where('createdByEmail', isEqualTo: userEmailToDisplay)
                    .where('forRent', isEqualTo: false)
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
              } else if (snapshot.data == null) {
                return const Text("No such Listing");
              }

              // Iterable<Listing>? listingDataIterable = snapshot.data!;
              // if (listingDataIterable == null ||
              //     listingDataIterable.isEmpty) {
              //   return const Text("No such listings :(");
              // }
              // List<Listing> listingData = listingDataIterable.toList();
              return SizedBox(
                height: 500,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    // docs method gives us list of document id of the listings
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Container(
                          alignment: Alignment.center,
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
                                        snap:
                                            snapshot.data!.docs[index].data()),
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
        ]));
  }
}
