import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justsharelah_v1/models/listings.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseUser extends Mock implements User {
  @override
  String uid;

  MockFirebaseUser({required this.uid});
}

void main() {
  // adding to mock users 
  MockFirebaseUser testuser = MockFirebaseUser(uid: "testUser");
  MockFirebaseUser testuser2 = MockFirebaseUser(uid: "testUser2");

  group('test forRent value', () {
    test('testing listing for rent', () {
      Listing mockListingForRent = Listing.
        
        Listing(true);
      expect(mockListingForRent.forRent, true);
    });
    test('testing listing for lending', () {
      Listing mockListingForLending = Listing.defaultListing(false);
      expect(mockListingForLending.forRent, false);
    });
  });

  group('test usersLiked and likePost', () {
    Listing mockListing = Listing.defaultListing(true);
    test('usersLiked should be empty list', () {
      expect(mockListing.usersLiked, []);
    });
    test('add one user id and usersLiked should contain that user', () {
      mockListing.likePost(testuser);
      expect(mockListing.usersLiked, [testuser.uid]);
    });
    test('add one more user id and usersLiked should contain both users', () {
      mockListing.likePost(testuser2);
      expect(mockListing.usersLiked, [testuser.uid, testuser2.uid]);
    });
    test('when user likes post again, usersLiked should remove that user', () {
      mockListing.likePost(testuser);
      expect(mockListing.usersLiked, [testuser2.uid]);
    });
  });

  group('test setId', () {
    Listing mockListing = Listing.defaultListing(true);
    test('testing if setID sets ID', () {
      String testId = "test";
      mockListing.setId(testId);
      expect(mockListing.uid, testId);
    });
  });

  group('test createListing and toJson', () {
    String imageUrl, title, price, description, createdByEmail;
    bool forRent, available;
    int likeCount;
    List<dynamic> usersLiked;

    imageUrl = 'https://static.thenounproject.com/png/1913842-200.png';
    title = "testTitle";
    price = "NA";
    description = "test record!";
    createdByEmail = "test@gmail.com";
    forRent = false;
    available = true;
    likeCount = 5;
    usersLiked = ["testuser", "anotheruid"];

    Map<String, dynamic> testRecord = {
      'uid':uid,
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

    Listing listing = Listing.createListing(testRecord);

    test('created listing values and record values must be same', () {
      expect(listing.imageUrl, testRecord["imageUrl"]);
      expect(listing.title, testRecord["title"]);
      expect(listing.price, testRecord["price"]);
      expect(listing.forRent, testRecord["forRent"]);
      expect(listing.description, testRecord["description"]);
      expect(listing.available, testRecord["available"]);
      expect(listing.createdByEmail, testRecord["createdByEmail"]);
      expect(listing.likeCount, testRecord["likeCount"]);
      expect(listing.usersLiked, testRecord["usersLiked"]);
    });

    test('testing toJson method', () {
      expect(listing.toJson(), testRecord);
    });
  });
}
