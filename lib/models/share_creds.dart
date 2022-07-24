import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShareCredits {
  final String uid;
  final String listingId;
  final String userId;

  // final Color bgColor;

  ShareCredits({
    required this.uid,
    required this.listingId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'listingId': listingId,
      'userId': userId,
    };
  }
}
