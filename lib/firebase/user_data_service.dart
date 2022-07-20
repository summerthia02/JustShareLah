import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:justsharelah_v1/firebase/firestore_keys.dart';
import 'package:justsharelah_v1/firebase/storage_methods.dart';
import 'package:justsharelah_v1/models/user_data.dart';

// user data under the 'Users' table
class UserDataService {
  UserDataService();

  // get the Users table
  static final usersCollection = FirebaseFirestore.instance.collection('Users');

  static Future<void> createUser(String uid, String email, String userName,
      String firstName, String lastName) async {
    return await usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'username': userName,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': "",
      'about': "Click Edit Profile to add a bio!",
      'imageUrl': "https://i.stack.imgur.com/l60Hf.png",
      'listings': [],
      'reviews': [],
      'share_credits': "0",
      'chatting_with': []
    });
  }

  static UserData fromDocument(DocumentSnapshot snapshot) {
    String email = "";
    String username = "";
    String firstName = "";
    String lastName = "";
    String phoneNumber = "";
    String about = "";
    String imageUrl = "";
    String shareCredits = "";
    List<dynamic> listings = [];
    List<dynamic> reviews = [];

    try {
      email = snapshot.get(FirestoreUserKeys.email);
      username = snapshot.get(FirestoreUserKeys.username);
      firstName = snapshot.get(FirestoreUserKeys.firstName);
      lastName = snapshot.get(FirestoreUserKeys.lastName);
      phoneNumber = snapshot.get(FirestoreUserKeys.phoneNumber);
      about = snapshot.get(FirestoreUserKeys.about);
      imageUrl = snapshot.get(FirestoreUserKeys.imageUrl);
      shareCredits = snapshot.get(FirestoreUserKeys.shareCredits);
      listings = snapshot.get(FirestoreUserKeys.listings);
      reviews = snapshot.get(FirestoreUserKeys.reviews);
    } catch (e) {
      print(e);
    }

    return UserData(
        uid: snapshot.id,
        userName: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        about: about,
        imageUrl: imageUrl,
        listings: listings,
        reviews: reviews,
        shareCredits: shareCredits);
  }

  // edit profile
  Future<bool> editProfile(String uid, String userEmail, Uint8List? image,
      String firstName, String lastName, String userName, String bio) async {
    Map<String, dynamic>? userData;
    String? docID;
    await usersCollection.where("email", isEqualTo: userEmail).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
        docID = res.docs.first.id;
      },
      onError: (e) => print("Error completing: $e"),
    );

    if (userEmail == null || userData == null) {
      return false;
    }

    String? photoUrl;
    if (image != null) {
      // profile image
      photoUrl = await StorageMethods()
          .uploadPicToStorage('profilePictures', image, false);
    }

    // if empty, remains the same, else take the controller variable
    userData!["imageUrl"] = image == null ? userData!["imageUrl"] : photoUrl;
    userData!["first_name"] =
        firstName.isEmpty ? userData!["first_name"] : firstName;
    userData!["last_name"] =
        lastName.isEmpty ? userData!["last_name"] : lastName;
    userData!["username"] = userName.isEmpty ? userData!["username"] : userName;
    userData!["about"] = bio.isEmpty ? userData!["about"] : bio;

    usersCollection
        .doc(docID)
        .update(userData!)
        .then((value) => print('Edited Profile'))
        .catchError((err) => print('Failed to edit profile: $err'));
    return true;
  }

  static Future<Map<String, dynamic>> getUserData(String email) async {
    Map<String, dynamic> userData = <String, dynamic>{};
    // get data where 'email' field is = email argument field
    await usersCollection.where('email', isEqualTo: email).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
        userData["uid"] = res.docs.first.id;
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userData;
  }
}
