import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String uid;
  final String imageUrl;
  final String title;
  final String price;
  final String shareCredits;
  final bool forRent;
  final String description;
  final bool available;
  final String createdByEmail;
  final int? likeCount;
  final dynamic dateListed;
  late final List<dynamic> usersLiked;
  final List<String> searchIndex;
  GeoPoint GeoLocation;
  String location;

  // final Color bgColor;

  Listing({
    required this.uid,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.shareCredits,
    required this.forRent,
    required this.description,
    required this.available,
    required this.createdByEmail,
    required this.usersLiked,
    required this.dateListed,
    required this.likeCount,
    required this.searchIndex,
    required this.GeoLocation,
    required this.location,
    // this.bgColor = const Color(0xFFEFEFF2),
  });

  void likePost(User? user) {
    if (usersLiked.contains(user?.uid)) {
      usersLiked.remove(user?.uid);
    } else {
      usersLiked.add(user?.uid);
    }
  }

  // void setId(String id) {
  //   uid = id;
  // }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'shareCredits': shareCredits,
      'forRent': forRent,
      'description': description,
      'available': available,
      'createdByEmail': createdByEmail,
      'likeCount': likeCount,
      'usersLiked': usersLiked,
      'dateListed': Timestamp.fromDate(dateListed),
      'searchIndex': searchIndex,
      'GeoLocation': GeoLocation,
      'location': location,
    };
  }

  static Listing defaultListing(bool forRent) {
    return Listing(
      uid: "1",
      dateListed: Timestamp.fromDate(DateTime.parse('1969-07-20 20:18:04Z')),
      imageUrl: 'https://static.thenounproject.com/png/1913842-200.png',
      title: "testTitle",
      price: "NA",
      description: "test record!",
      createdByEmail: "test@gmail.com",
      forRent: forRent,
      available: true,
      likeCount: 5,
      usersLiked: [],
      GeoLocation: const GeoPoint(1, 1),
      location: 'Test Location',
      shareCredits: '500',
      searchIndex: [],
    );
  }

  static Listing createListing(record) {
    Map<String, dynamic> attributes = {
      'uid': '',
      'imageUrl': "",
      'dateListed': Timestamp.fromDate(DateTime.parse('1969-07-20 20:18:04Z')),
      'title': '',
      'price': '',
      'shareCredits': '',
      'forRent': '',
      'description': '',
      'available': true,
      'createdByEmail': '',
      'likeCount': 0,
      'usersLiked': [],
      'GeoLocation': GeoPoint(1, 1),
      'location': '',
      'searchIndex': []
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
      uid: attributes['uid'],
      dateListed: attributes['dateListed'],
      likeCount: attributes['likeCount'],
      searchIndex: attributes['searchIndex'],
      usersLiked: attributes['usersLiked'],
      GeoLocation: attributes['GeoLocation'],
      location: attributes['location'],
      shareCredits: attributes['shareCredits'],
    );

    return listing;
  }
}
