import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:justsharelah_v1/firebase/storage_methods.dart';

// user data under the 'Users' table
class UserDataService {
  UserDataService();

  // get the Users table
  final users = FirebaseFirestore.instance.collection('Users');

  static Future<void> createUser(String uid, String email, String userName,
      String firstName, String lastName) async {
    final users = FirebaseFirestore.instance.collection('Users');
    return await users.doc(uid).set({
      'email': email,
      'user_name': userName,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': "",
      'about': "Click Edit Profile to add a bio!",
      'imageUrl': "https://i.stack.imgur.com/l60Hf.png",
      'listings': [],
      'reviews': [],
      'share_credits': "",
    });
  }

  // edit profile
  Future<bool> editProfile(String uid, String userEmail, Uint8List? image,
      String firstName, String lastName, String userName, String bio) async {
    Map<String, dynamic>? userData;
    String? docID;
    await users.where("email", isEqualTo: userEmail).get().then(
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

    users
        .doc(docID)
        .update(userData!)
        .then((value) => print('Edited Profile'))
        .catchError((err) => print('Failed to edit profile: $err'));
    return true;
  }
}
