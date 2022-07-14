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
  final DateTime dateListed;
  final List<dynamic> usersLiked;

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
    // this.bgColor = const Color(0xFFEFEFF2),
  });
  
  static Listing defaultListing(bool forRent) {
    return Listing(
      uid: "1",
      dateListed: DateTime(2022),
      profImageUrl: 'https://static.thenounproject.com/png/1913842-200.png',
      imageUrl: 'https://static.thenounproject.com/png/1913842-200.png',
      title: "testTitle",
      price: "NA",
      description: "test record!",
      createdByEmail: "test@gmail.com",
      forRent: forRent,
      available: true,
      likeCount: 5,
      usersLiked: [],
    );
  }



  void likePost(User? user) {
    if (usersLiked.contains(user?.uid)) {
      usersLiked.remove(user?.uid);
    } else {
      usersLiked.add(user?.uid);
    }
  }



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
      'dateListed': dateListed,
    };
  }

  static Listing createListing(record) {
    Map<String, dynamic> attributes = {
      'imageUrl':'https://static.thenounproject.com/png/1913842-200.png',
      'profImageUrl':'https://static.thenounproject.com/png/1913842-200.png',
      'uid': '',
      'title': '',
      'price': '',
      'forRent': '',
      'description': '',
      'available': true,
      'createdByEmail': '',
      'dateListed': DateTime(2022),
      'likeCount': 0,
      'usersLiked': []
    };

    record.forEach((key, value) => attributes[key] = value);

    Listing listing = Listing(
        uid: attributes['uid'],
        available: attributes['available'],
        imageUrl: attributes['imageUrl'],
        title: attributes['title'],
        price: attributes['price'],
        forRent: attributes['forRent'],
        description: attributes['description'],
        createdByEmail: attributes['createdByEmail'],
        dateListed: attributes['dateListed'],
        likeCount: attributes['likeCount'],
        profImageUrl: attributes['profImageUrl'],
        usersLiked: attributes['usersLiked']);
    return listing;
  }
}
