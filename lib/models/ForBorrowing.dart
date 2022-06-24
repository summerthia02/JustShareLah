import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/models/ListingCard.dart';
import 'package:justsharelah_v1/models/enlarged_listing.dart';
import 'package:justsharelah_v1/models/feedTitle.dart';
import 'package:justsharelah_v1/models/listings.dart';

class ForBorrowing extends StatelessWidget {
  const ForBorrowing({
    Key? key,
    this.userEmail,
  }) : super(key: key);

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    print("UserEmail: $userEmail");
    return Column(
      children: [
        FeedTitle(
          title: "For Borrowing",
          pressSeeAll: () {},
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                listOfListings.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: defaultPadding),
                  child: ListingCard(
                    image: listOfListings[index].imageUrl,
                    title: listOfListings[index].title,
                    price: listOfListings[index].price,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EnlargedScreen(listing: listOfListings[index]),
                          ));
                    },
                  ),
                ),
              )),
        )
      ],
    );
  }
}
