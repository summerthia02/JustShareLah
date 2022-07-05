import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/BigListingCard.dart';
import 'package:justsharelah_v1/models/ForRenting.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

// class _AllRentingState extends State<AllRenting> {
class AllRenting extends StatelessWidget {
  AllRenting({
    Key? key,
    this.userEmailToDisplay = "",
  }) : super(key: key);

  late String? userEmailToDisplay;
  Future<Iterable<Listing>> rentingData = ForRenting().getRentListingData();

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
      body: ListView(padding: const EdgeInsets.all(defaultPadding), children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Explore",
            textAlign: TextAlign.start,
            style: kJustShareLahStyle.copyWith(
                fontSize: 35, fontWeight: FontWeight.w500),
          ),
          const Text(
            'Listings For Rent',
            style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
          ),
          const SizedBox(height: defaultPadding),
          Form(
              child: TextFormField(
            decoration: kTextFormFieldDecoration.copyWith(
                hintText: "Search for Listings to Rent",
                prefixIcon: Icon(Icons.search_rounded)),
          )),
        ]),
        Column(
          children: [
            FutureBuilder<Iterable<Listing>>(
              future: rentingData,
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

                return Column(
                    children: List.generate(
                  listingData.length,
                  (index) => Container(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                    child: BigListingCard(
                      image: listingData[index].imageUrl,
                      title: listingData[index].title,
                      price: listingData[index].price,
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EnlargedScreen(listing: listingData[index]),
                            ));
                      },
                    ),
                  ),
                ));
              },
            )
          ],
        )
      ]),

      //TODO: LISTINGS DONT AUTO UPDATE ON FEED PAGE AFTER LISTING IS ADDED
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}