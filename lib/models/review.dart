import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String uid;
  final String reviewById;
  final String reviewForId;
  final String description;
  final String listingId;
  final String feedback;

  // final Color bgColor;

  Review({
    required this.description,
    required this.reviewById,
    required this.reviewForId,
    required this.listingId,
    required this.feedback,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'reviewById': reviewById,
      'reviewForId': reviewForId,
      'description': description,
      'listingId': listingId,
      'feedback': feedback,
    };
  }
}
