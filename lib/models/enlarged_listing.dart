import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'dart:async';

import 'package:justsharelah_v1/utils/profile_image.dart';

class EnlargedScreen extends StatefulWidget {
  const EnlargedScreen({Key? key, required this.listing}) : super(key: key);
  final Listing listing;

  @override
  State<EnlargedScreen> createState() => _EnlargedScreenState();
}

class _EnlargedScreenState extends State<EnlargedScreen> {
  bool showHeart = false;
  bool isLiked = false;
  late int? likeCount = widget.listing.likeCount;
  int doubleTapCounter = 0;
  bool hasClickedHeart = false;

  doubleTap() {
    setState(() {
      showHeart = true;
      isLiked = true;
      doubleTapCounter++;

      if (showHeart) {
        Timer(const Duration(milliseconds: 400), () {
          setState(() {
            showHeart = false;
            if (likeCount != null &&
                doubleTapCounter == 1 &&
                !hasClickedHeart) {
              likeCount = likeCount! + 1;
            } else {
              likeCount = 1;
            }
          });
        });
      }
    });
  }

  clickHeart() {
    setState(() {
      hasClickedHeart = true;
      isLiked = !isLiked;
      if (!isLiked && likeCount != null) {
        likeCount = likeCount! - 1;
      } else if (isLiked && likeCount != null) {
        likeCount = likeCount! + 1;
      } else {
        likeCount = 1;
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(10)),
          PostedBy(),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // listing title, price, description
                    IconButton(
                      alignment: Alignment.topLeft,
                      icon: isLiked
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: isLiked ? Colors.red : Colors.grey,
                      onPressed: () => clickHeart(),
                    ),
                    LikeCounts(likeCount: likeCount == null ? 0 : likeCount),
                    ListingCardDetails(listing: widget.listing),
                    const SizedBox(height: (defaultPadding)),
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
            ),
          )
        ],
      ),
    );
  }
}

class PostedBy extends StatelessWidget {
  const PostedBy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          ProfileWidget(
            imageUrl:
                "https://images.unsplash.com/photo-1525673812761-4e0d45adc0cc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8bmljZSUyMHBob3RvfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
            onClicked: () => {},
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            'Summer Thia',
            style: kBodyTextSmall,
          ),
        ]));
  }
}

// show the number of likes

class LikeCounts extends StatefulWidget {
  const LikeCounts({Key? key, required this.likeCount}) : super(key: key);
  final int? likeCount;

  @override
  State<LikeCounts> createState() => _LikeCountsState();
}

class _LikeCountsState extends State<LikeCounts> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.likeCount.toString() + " likes",
      style: kBodyTextSmall.copyWith(fontWeight: FontWeight.bold),
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
