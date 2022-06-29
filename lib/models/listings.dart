import 'package:flutter/material.dart';

class Listing {
  final String imageUrl;
  final String title;
  final String price;
  final bool forRent;
  final String description;
  final bool available;
  final String createdByEmail;
  final int? likeCount;
  // final Color bgColor;

  Listing({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.forRent,
    required this.description,
    required this.available,
    required this.createdByEmail,
    required this.likeCount,
    // this.bgColor = const Color(0xFFEFEFF2),
  });
}
