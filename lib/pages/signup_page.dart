// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:justsharelah_v1/main.dart';
import 'package:justsharelah_v1/models/user_model.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/components/auth_state.dart';
import 'package:justsharelah_v1/utils/constants.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gotrue/src/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends AuthState<SignupPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _cfmpasswordController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  //formkey
  final _formKey = GlobalKey<FormState>();

  void signUp(String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //   .then((value) => {postDetailsToFirestore()})
        //   .catchError((e) {
        // Fluttertoast.showToast(msg: e!.message);

      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  // postDetailsToFirestore() async {
  //   // calling our firestore
  //   // calling our user model
  //   // sedning these values

  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _auth.currentUser;

  //   UserModel userModel = UserModel();

  //   // writing all the values
  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.userName = _usernameController.text;
  //   userModel.firstName = _firstnameController.text;
  //   userModel.lastName = _lastnameController.text;

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg: "Account created successfully :) ");

  //   Navigator.pushAndRemoveUntil((context),
  //       MaterialPageRoute(builder: (context) => FeedPage()), (route) => false);
  // }

  // Future<void> _signUp() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final response = await supabase.auth
  //       .signUp(_emailController.text, _passwordController.text);

  //   final error = response.error;
  //   if (error != null) {
  //     context.showErrorSnackBar(message: error.message);
  //   } else {
  //     context.showSnackBar(message: 'Sign Up Successful!');
  //     Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cfmpasswordController = TextEditingController();
    _usernameController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _lastnameController.dispose();
    _firstnameController.dispose();
    _cfmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text("JustShareLah!"),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(
                  'Register Your Details!',
                  style: kHeadingText,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                obscureText: false,
                textAlign: TextAlign.center,
                controller: _emailController,
                decoration: kTextFormFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.mail),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              TextFormField(
                obscureText: false,
                textAlign: TextAlign.center,
                controller: _usernameController,
                decoration: kTextFormFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: 'Enter your username',
                    labelText: 'Username',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              TextFormField(
                obscureText: false,
                textAlign: TextAlign.center,
                controller: _firstnameController,
                decoration: kTextFormFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: 'Enter your first name',
                    labelText: 'First Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              TextFormField(
                obscureText: false,
                textAlign: TextAlign.center,
                controller: _lastnameController,
                decoration: kTextFormFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: 'Enter your last name',
                    labelText: 'Last Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              //TODO: Make sure the passwords are the same
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                controller: _passwordController,
                decoration: kTextFormFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.vpn_key),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              // make sure that the password is same - idk why but doesn't work
              const SizedBox(height: 18),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                controller: _cfmpasswordController,
                validator: (value) {
                  if (_cfmpasswordController.text != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cfmpasswordController.text = value!;
                },
                decoration: kTextFormFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.vpn_key),
                    hintText: 'Enter the same password as above',
                    labelText: 'Confirm Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              Expanded(child: const SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          // primary: Colors.redAccent,
                          side: BorderSide(width: 4, color: Colors.black),
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.all(15)),
                      onPressed: () {
                        signUp(_emailController.text, _passwordController.text);
                      },
                      child: Text(_isLoading ? 'Loading' : 'Register'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      )
    ]);
  }
}

//   ,)]),)
// Container(
//   padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
//   child: ListView(
//     children: [
//       const SizedBox(height: 32),
//       Center(
//         child: Text(
//           'Registration',
//           style: TextStyle(
//               fontSize:
//                   Theme.of(context).textTheme.headline4?.fontSize ??
//                       32),
