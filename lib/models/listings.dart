import 'package:flutter/material.dart';

class Listing {
  final String image, title;
  final String price;
  // final bool forRent;
  final Color bgColor;

  Listing({
    required this.image,
    required this.title,
    required this.price,
    // required this.forRent,
    this.bgColor = const Color(0xFFEFEFF2),
  });
}

List<Listing> demoListing = [
  Listing(
    image: "images/iphone_charger.png",
    title: "iPhone 12 Charger",
    price: "0",
    bgColor: const Color(0xFFFEFBF9),
  ),
  Listing(
    image: "images/camera_stand.png",
    title: "Tripod Stand",
    price: "20 / day",
  ),
  Listing(
    image: "images/microphone.png",
    title: "Microphone",
    price: "15 / day",
    bgColor: const Color(0xFFF8FEFB),
  ),
];
