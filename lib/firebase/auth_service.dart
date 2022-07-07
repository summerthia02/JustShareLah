import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justsharelah_v1/firebase/auth_data.dart';
import 'package:justsharelah_v1/models/jslUser.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // createing jsluser
  // JslUser? _firebaseUser(User? user) {
  //   return user != null ? JslUser(uid: user.uid) : null;
  // }

  // sign in function
  static Future<bool> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  // register function

  static Future<String> signUp(String email, String password, String userName,
      String firstName, String lastName) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // get the user
      User? newUser = response.user;
      await AuthData(uid: newUser!.uid)
          .createUser(email, userName, firstName, lastName);
      return "Success!";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // sign out function
  static Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
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

  // edit profile function

  // GET UID
  Future<String?> getCurrentUID() async {
    return _firebaseAuth.currentUser?.uid;
  }
}
