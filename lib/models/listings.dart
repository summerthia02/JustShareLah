import 'package:flutter/material.dart';

class Listing {
  final String imageUrl;
  final String title;
  final String price;
  final bool forRent;
  final String description;
  final bool available;
  final String createdByEmail;
  // final Color bgColor;

  Listing({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.forRent,
    required this.description,
    required this.available,
    required this.createdByEmail,
    // this.bgColor = const Color(0xFFEFEFF2),
  });
}

List<Listing> listOfListings = [
  Listing(
    imageUrl: "images/iphone_charger.png",
    title: "iPhone 12 Charger",
    price: "0",
    forRent: false,
    description: "",
    available: true,
    createdByEmail: "pravedino@gmail.com"
    // bgColor: const Color(0xFFFEFBF9),
  ),
  Listing(
    imageUrl: "images/camera_stand.png",
    title: "Tripod Stand",
    price: "20 / day",
    forRent: true,
    description: "",
    available: true,
    createdByEmail: "pravedino@gmail.com"
  ),
  Listing(
    imageUrl: "images/microphone.png",
    title: "Microphone",
    price: "15 / day",
    forRent: true,
    description: "",
    available: true,
    createdByEmail: "pravedino@gmail.com"
    // bgColor: const Color(0xFFF8FEFB),
  ),
];
