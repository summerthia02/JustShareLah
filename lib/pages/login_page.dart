// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:justsharelah_v1/components/auth_state.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:justsharelah_v1/utils/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/feed', (route) => false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      // TODO: Do we need an appbar?
      // appBar: AppBar(title: const Text('Welcome')),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                          backgroundColor: Colors.cyan,
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
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                controller: _emailController,
                decoration: kTextFormFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                controller: _passwordController,
                decoration: kTextFormFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      child: Text(_isLoading ? 'Loading' : 'Log In'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  const Text(
                    "Forgot Password? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      //TODO FORGOT PASSWORD SCREEN GOES HERE
                    },
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  const Text(
                    "New User? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    child: Text(
                      'Sign up.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
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
