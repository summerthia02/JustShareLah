import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/firebase/auth_provider.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/main.dart';

class EmailFieldValidation {
  static String? validate(String value) {
    return value.isEmpty ? "Email cannot be empty" : null;
  }
}

class PasswordFieldValidation {
  static String? validate(String value) {
    return value.isEmpty ? "Password cannot be empty" : null;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // local signin function
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await AuthService()
        .signIn(_emailController.text.trim(), _passwordController.text.trim());
    successFailSnackBar(
        success, "Log In Successful", "Error signing in", context);

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
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/564x/81/68/77/8168774f8b714d65417e7615aac3f361.jpg'),
                  fit: BoxFit.fitWidth)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    height: 170.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset('images/logo.png',
                          width: 130, height: 120),
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
                key: Key("Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => EmailFieldValidation.validate(value!),
                textAlign: TextAlign.center,
                controller: _emailController,
                decoration: kTextFormFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              const SizedBox(height: 18),
              TextFormField(
                key: Key("Password"),
                obscureText: true,
                validator: (value) => PasswordFieldValidation.validate(value!),
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
                      key: Key("LogIn"),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              _signIn();
                            },
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text('Log In'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
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
      ]),
    );
  }
}
