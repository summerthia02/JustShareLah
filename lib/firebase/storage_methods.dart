// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? imageUrl;

  //store both profile pictures and listing images
  Future<String> uploadPicToStorage(
      String childName, Uint8List file, bool isListing) async {
    // upload file to the respective locadtion in the folders
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(file);

    // await the upload task
    TaskSnapshot snap = await uploadTask;
    String pictureUrl = await snap.ref.getDownloadURL();
    return pictureUrl;
  }

  String? getImageUrl() {
    return imageUrl;
  }
}
