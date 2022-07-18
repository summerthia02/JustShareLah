import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String uid;
  final String imageUrl;
  final String profImageUrl;
  final String title;
  final String price;
  final bool forRent;
  final String description;
  final bool available;
  final String createdByEmail;
  final int? likeCount;
  final dynamic dateListed;
  final List<dynamic> usersLiked;
  final List<String> searchIndex;
  GeoPoint GeoLocation;
  String location;

  // final Color bgColor;

  Listing({
    required this.uid,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.forRent,
    required this.description,
    required this.available,
    required this.createdByEmail,
    required this.usersLiked,
    required this.dateListed,
    required this.profImageUrl,
    required this.likeCount,
    required this.searchIndex,
    required this.GeoLocation,
    required this.location,
    // this.bgColor = const Color(0xFFEFEFF2),
  });

  // void likePost(User? user) {
  //   if (usersLiked.contains(user?.uid)) {
  //     usersLiked.remove(user?.uid);
  //   } else {
  //     usersLiked.add(user?.uid);
  //   }
  // }

  // void setId(String id) {
  //   uid = id;
  // }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'title': title,
      'price': price,
      'forRent': forRent,
      'description': description,
      'available': available,
      'createdByEmail': createdByEmail,
      'likeCount': likeCount,
      'usersLiked': usersLiked,
      'profImageUrl': profImageUrl,
      'dateListed': Timestamp.fromDate(dateListed),
      'searchIndex': searchIndex,
      'GeoLocation': GeoLocation,
      'location': location,
    };
  }

  // Listing createListing(record) {
  //   Map<String, dynamic> attributes = {
  //     'imageUrl': "",
  //     'title': '',
  //     'price': '',
  //     'forRent': '',
  //     'description': '',
  //     'available': true,
  //     'createdByEmail': '',
  //     'likeCount': 0,
  //     'usersLiked': []
  //   };

  //   record.forEach((key, value) => attributes[key] = value);

  //   Listing listing = Listing(
  //       available: attributes['available'],
  //       imageUrl: attributes['imageUrl'],
  //       title: attributes['title'],
  //       price: attributes['price'],
  //       forRent: attributes['forRent'],
  //       description: attributes['description'],
  //       createdByEmail: attributes['createdByEmail'],
  //       uid: attributes['uid'],
  //       dateListed: attributes['dateListed'],
  //       likeCount: attributes['likeCount'],
  //       profImageUrl: attributes['profImageUrl']);

  //   listing.usersLiked = Set.from(attributes['usersLiked']);
  //   return listing;
  // }
}
