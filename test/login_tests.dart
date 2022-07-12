import 'dart:math';
import 'dart:typed_data';
// import 'package:test/test.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:justsharelah_v1/firebase/auth_provider.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/main.dart' as app;
import 'package:justsharelah_v1/models/jslUser.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(app.MyApp());

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {});
  // tests for email and password field validation
  test('empty email returns error', () {
    var result = EmailFieldValidation.validate('');
    expect(result, "Email cannot be empty");
  });

  test('Sign In', () async {
    String email = "test@gmail.com";
    String password = "testpassword";
    AuthService firebaseUser = AuthService();

    bool response = await firebaseUser.signIn(email, password);
    expect(response, true);
    expect(AuthService().currentUser, isNot(null));
    expect(firebaseUser.status, Status.Authenticated);
  });
  // // Sign Up / Create Account tests
  // group('Signing Up', () {
  //   AuthService testUser = AuthService();
  //   // Test Sign Up Function -- email and password
  //   // test signUp function in AuthService
  //   test('Signing Up', () async {
  //     String? response = await AuthService().signUp(
  //       'test@gmail.com',
  //       'testpassword',
  //       'testUser',
  //       'test',
  //       'User',
  //     );
  //     expect(response, isNot(null));
  //   });

  //   // sign up - add to datastore
  //   // test createUser Function in user_data_service
  //   test('User Creation to Database', () async {
  //     await UserDataService.createUser(
  //       '1',
  //       'testuser@gmail.com',
  //       'test_user',
  //       'testing',
  //       'user',
  //     );

  //     DocumentSnapshot users = await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(AuthService().currentUser!.uid)
  //         .get();
  //     expect(users.get('email'), 'test@gmail.com');
  //     expect(users.get('user_name'), 'test_user');
  //   });

  //   // failed signUp test as unique email isn't used

  //   test('Failed Sign Up', () async {
  //     String? response = await AuthService().signUp(
  //       'test@gmail.com',
  //       'testpassword2',
  //       'testUser2',
  //       'test2',
  //       'User2',
  //     );
  //     expect(response, null);
  //   });
  // });

  // group('Sign In tests', () {

  //   // when(_auth.signInWithEmailAndPassword(email: email, password: password))
  //   //     .thenAnswer((_) async {
  //   //   _user.add(MockFirebaseUser());
  //   //   return MockAuthResult();
  //   // });
  //   // User sign in

  // });

  // // updating profile details
  // group('Editing Profile', () {
  //   AuthService firebaseUser = AuthService();
  //   UserDataService userData = UserDataService();
  //   test('Edit Profile', () async {
  //     bool response = await userData.editProfile(
  //       '1',
  //       'testuser@gmail.com',
  //       Uint8List(2),
  //       'test23',
  //       'user23',
  //       'testUser23',
  //       'adding my bio',
  //     );

  //     expect(response, true);
  //   });

  //   test('Edit Profile Database Changes', () async {
  //     DocumentSnapshot users = await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(firebaseUser.currentUser!.uid)
  //         .get();
  //     expect(users.get('bio'), 'adding my bio');
  //     expect(users.get('user_name'), 'testUser23');
  //   });
  // });
}
