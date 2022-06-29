import 'package:flutter/material.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'dart:async';

class EnlargedScreen extends StatefulWidget {
  const EnlargedScreen({Key? key, required this.listing}) : super(key: key);
  final Listing listing;

  @override
  State<EnlargedScreen> createState() => _EnlargedScreenState();
}

class _EnlargedScreenState extends State<EnlargedScreen> {
  bool showHeart = false;
  bool isLiked = false;

  doubleTap() {
    setState(() {
      showHeart = true;
      isLiked = true;
      if (showHeart) {
        Timer(const Duration(milliseconds: 400), () {
          setState(() {
            showHeart = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF2),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          GestureDetector(
              onDoubleTap: () => doubleTap(),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ListingImage(listing: widget.listing),
                  AnimatedCrossFade(
                    firstChild:
                        Icon(Icons.favorite, color: Colors.red, size: 100.0),
                    secondChild:
                        Icon(Icons.favorite_border, color: Colors.transparent),
                    crossFadeState: showHeart
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 200),
                  )
                ],
              )),
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
                  IconButton(
                    icon: isLiked
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color: isLiked ? Colors.red : Colors.grey,
                    onPressed: () => setState(() {
                      isLiked = !isLiked;
                    }),
                  ),
                  ListingCardDetails(listing: widget.listing),
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
