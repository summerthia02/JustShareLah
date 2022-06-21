// ignore_for_file: deprecated_member_use

import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:justsharelah_v1/components/auth_state.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:justsharelah_v1/firebase/firebase_auth_service.dart';
import 'package:justsharelah_v1/main.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/utils/constants.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // form key
  final _formkey = GlobalKey<FormState>();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  // login function
  void signIn(String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      AuthenticationHelper()
          .signIn(email: email, password: password)
          .then((result) {
        if (result == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const FeedPage()));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              result,
              style: TextStyle(fontSize: 16),
            ),
          ));
        }
      });
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
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  // Future<void> _signIn() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final response = await supabase.auth.signIn(
  //     email: _emailController.text,
  //     password: _passwordController.text,
  //   );

  //   final error = response.error;
  //   if (error != null) {
  //     context.showErrorSnackBar(message: error.message);
  //   } else {
  //     Navigator.of(context).pushNamedAndRemoveUntil('/feed', (route) => false);
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // void initState() {
  //   super.initState();
  //   _emailController = TextEditingController();
  //   _passwordController = TextEditingController();
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // email field
    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }

        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        _emailController.text = value!;
      },
      textAlign: TextAlign.center,
      controller: _emailController,
      decoration: kTextFormFieldDecoration.copyWith(
          prefixIcon: Icon(Icons.mail),
          hintText: 'Enter your email',
          labelText: 'Email',
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );

    // password field
    final passwordField = TextFormField(
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      textAlign: TextAlign.center,
      controller: _passwordController,
      decoration: kTextFormFieldDecoration.copyWith(
          prefixIcon: Icon(Icons.vpn_key),
          hintText: 'Enter your password',
          labelText: 'Password',
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );

    // login button
    final loginButton = Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.lock_open),
            label: Text('Log In'),
            onPressed: () {
              signIn(_emailController.text, _passwordController.text);
            },
          ),
        ),
      ],
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 60.0,
                      child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.zero,
                            child: Image.asset('images/logo.png',
                                width: 130, height: 140),
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: Text('JustShareLah!', style: kJustShareLahStyle)),
              SizedBox(
                height: 20.0,
              ),
              const SizedBox(height: 18),
              emailField,
              const SizedBox(height: 18),
              passwordField,
              SizedBox(
                height: 20,
              ),
              loginButton,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.ltr,
                children: [
                  const Text(
                    "Forgot Password? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/forget_password');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textDirection: TextDirection.ltr,
                children: [
                  const Text(
                    "New User? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pushNamed('/signup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
