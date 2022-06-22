import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:justsharelah_v1/main.dart';
import 'package:justsharelah_v1/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user == null) {
        context.showErrorSnackBar(message: "Error Signing In");
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/feed', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
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
      body: Padding(
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
                    onPressed: _isLoading
                        ? null
                        : () {
                            _signIn();
                            Navigator.of(context).pushReplacementNamed("/feed");
                          },
                    child: Text(_isLoading ? 'Loading' : 'Log In'),
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
    );
  }
}
