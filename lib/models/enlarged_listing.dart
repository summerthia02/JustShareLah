import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';

class EnlargedScreen extends StatelessWidget {
  const EnlargedScreen({Key? key, required this.listing}) : super(key: key);

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF2),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "images/heart.png",
                height: 22,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ListingImage(listing: this.listing),
          const SizedBox(height: defaultPadding * 1.5),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(defaultPadding,
                  defaultPadding * 2, defaultPadding, defaultPadding),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius * 3),
                  topRight: Radius.circular(defaultBorderRadius * 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // listing title, price, description
                  ListingCardDetails(listing: this.listing),
                  const SizedBox(height: (defaultPadding * 2.5)),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            shape: const StadiumBorder()),
                        child: const Text("Chat"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListingImage extends StatelessWidget {
  const ListingImage({Key? key, required this.listing}) : super(key: key);

  final Listing listing;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      listing.imageUrl,
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.cover,
    );
  }
}

class ListingCardDetails extends StatelessWidget {
  const ListingCardDetails({Key? key, required this.listing}) : super(key: key);
  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                listing.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(width: defaultPadding),
            Text(
              "\$" + listing.price.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(listing.description.toString()),
      ],
    );
  }
}
