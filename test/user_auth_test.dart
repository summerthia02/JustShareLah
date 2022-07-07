import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AuthService firebaseUser = AuthService();

  setUp(() {});

  // Test Sign Up Function -- email and password
  // test signUp function in AuthService
  test('Signing Up', () async {
    String? response = await AuthService.signUp(
      'test@gmail.com',
      'testpassword',
      'testUser',
      'test',
      'User',
    );
    expect(response, isNot(null));
  });

  // sign up - add to datastore
  // test createUser Function in user_data_service
  test('Creating User Upon Signing Up', () async {
    await UserDataService.createUser(
      '1',
      'testuser@gmail.com',
      'test_user',
      'testing',
      'user',
    );

    DocumentSnapshot users = await FirebaseFirestore.instance
        .collection('Users')
        .doc(firebaseUser.currentUser!.uid)
        .get();
    expect(users.get('email'), 'test@gmail.com');
    expect(users.get('user_name'), 'test_user');
  });
}
