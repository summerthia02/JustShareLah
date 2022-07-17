import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:justsharelah_v1/models/user_data.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  static Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    print(currentUser.uid);

    return UserData.fromSnap(documentSnapshot);
  }
}
