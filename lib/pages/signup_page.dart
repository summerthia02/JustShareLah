import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/utils/form_validation.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;
  final _signupFormKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _cfmpasswordController;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> _signUp() async {
    if (!_signupFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    String email, userName, firstName, lastName, password;
    email = _emailController.text.trim();
    password = _passwordController.text.trim();
    userName = _usernameController.text.trim();
    firstName = _firstnameController.text.trim();
    lastName = _lastnameController.text.trim();

    String? newUserUid = await AuthService()
        .signUp(email, password, userName, firstName, lastName);

    if (newUserUid == null) {
      showSnackBar(context, 'Error signing up. Try Again.');
      return;
    }

    await UserDataService.createUser(
        newUserUid, email, userName, firstName, lastName);

    showSnackBar(context, 'SIgned up Successfully! ');

    Navigator.of(context).pop();

    setState(() {
      _isLoading = false;
    });
  }

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
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Register Your Details!',
                        style: kHeadingText,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      obscureText: false,
                      textAlign: TextAlign.center,
                      controller: _emailController,
                      validator: FormValidation.validEmail,
                      decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      obscureText: false,
                      textAlign: TextAlign.center,
                      controller: _usernameController,
                      validator: (text) =>
                          FormValidation.enforceNumOfChars(text, 6),
                      decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter your username',
                          labelText: 'Username',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      obscureText: false,
                      textAlign: TextAlign.center,
                      controller: _firstnameController,
                      validator: FormValidation.formFieldEmpty,
                      decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter your first name',
                          labelText: 'First Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      obscureText: false,
                      textAlign: TextAlign.center,
                      controller: _lastnameController,
                      validator: FormValidation.formFieldEmpty,
                      decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter your last name',
                          labelText: 'Last Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      controller: _passwordController,
                      validator: FormValidation.formFieldEmpty,
                      decoration: kTextFormFieldDecoration.copyWith(
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
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter the same password as above',
                          labelText: 'Confirm Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                // primary: Colors.redAccent,
                                side: const BorderSide(
                                    width: 4, color: Colors.black),
                                elevation: 15,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.all(15)),
                            onPressed: () async {
                              _signUp();
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
            ),
          ),
        ),
      )
    ]);
  }
}
