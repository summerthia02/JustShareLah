import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String imageUrl;
  final String title;
  final String price;
  final bool forRent;
  final String description;
  final bool available;
  final String createdByEmail;
  final int? likeCount;

  // see who liked the post, put into a set
  Set usersLiked = {};
  String? uid;
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

  void likePost(User? user) {
    if (usersLiked.contains(user?.uid)) {
      usersLiked.remove(user?.uid);
    } else {
      usersLiked.add(user?.uid);
    }
  }

  void setId(String id) {
    uid = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'forRent': forRent,
      'description': description,
      'available': available,
      'createdByEmail': createdByEmail,
      'likeCount': likeCount,
      'usersLiked': usersLiked.toList(),
    };
  }

  Listing createListing(record) {
    Map<String, dynamic> attributes = {
      'imageUrl': 'images/logo.png',
      'title': '',
      'price': '',
      'forRent': '',
      'description': '',
      'available': true,
      'createdByEmail': '',
      'likeCount': 0,
      'usersLiked': []
    };

    record.forEach((key, value) => attributes[key] = value);

    Listing listing = Listing(
        available: attributes['available'],
        imageUrl: attributes['imageUrl'],
        title: attributes['title'],
        price: attributes['price'],
        forRent: attributes['forRent'],
        description: attributes['description'],
        createdByEmail: attributes['createdByEmail'],
        likeCount: attributes['likeCount']);

    listing.usersLiked = Set.from(attributes['usersLiked']);
    return listing;
  }
}
