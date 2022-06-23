import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/listings.dart';

import 'package:justsharelah_v1/utils/const_templates.dart';

class EnlargedScreen extends StatelessWidget {
  const EnlargedScreen({Key? key, required this.listing}) : super(key: key);

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: listing.bgColor,
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
          Image.asset(
            listing.image,
            height: MediaQuery.of(context).size.height * 0.4,
            fit: BoxFit.cover,
          ),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      "Always have an iPhone charger with me. Am willing to lend someone in need for free!",
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const SizedBox(height: defaultPadding * 2),
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
