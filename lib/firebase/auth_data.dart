import 'package:cloud_firestore/cloud_firestore.dart';

// user data under the 'Users' table
class AuthData {
  final String uid;
  AuthData({required this.uid});

  // get the Users table
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future createUser(
      String email, String userName, String firstName, String lastName) async {
    return await users.doc(uid).set({
      'email': email,
      'user_name': userName,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': "",
      'about': "Click Edit Profile to add a bio!",
      'imageUrl': "",
      'listings': [],
      'reviews': [],
      'share_credits': "",
    });
  }
}
