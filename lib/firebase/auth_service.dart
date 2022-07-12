// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/models/jslUser.dart';
import 'auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get onAuthStateChanged => auth.authStateChanges();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Status _status = Status.Uninitialized;
  late User _user;

  // AuthService.instance({required this.auth}) {
  //   auth.authStateChanges().listen(onAuthStateChanged);
  // }

  Status get status => _status;
  User get user => _user;

  // createing jsluser
  JslUser? _firebaseUser(User? user) {
    return user != null ? JslUser(uid: user.uid) : null;
  }

  // getting the current user - use firebase's currentUser method
  JslUser? get currentUser {
    return _firebaseUser(auth.currentUser);
  }

  // sign in function
  Future<bool> signIn(
    String email,
    String password,
  ) async {
    try {
      _status = Status.Authenticating;
      final response = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return false;
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      print(e);
      return false;
    }
    return true;
  }

  // register function

  Future<String?> signUp(String email, String password, String userName,
      String firstName, String lastName) async {
    String? uid;
    try {
      final response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // get the user
      User? newUser = response.user;
      if (newUser == null) {
        return null;
      }
      uid = newUser.uid;
    } catch (e) {
      print(e);
      return null;
    }

    return uid;
  }

  // sign out function
  Future signOut() async {
    try {
      auth.signOut();
      _status = Status.Unauthenticated;
      return Future.delayed(Duration.zero);
    } catch (e) {
      return false;
    }
  }

  // forget password function
  static Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Email Sent";
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.toString();
    }
  }

//   // GET UID
  Future<String?> getCurrentUID() async {
    return auth.currentUser?.uid;
  }
}
