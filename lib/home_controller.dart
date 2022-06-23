import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/login_page.dart';

import 'firebase/auth_provider.dart';
import 'firebase/auth_service.dart';

class HomeController extends StatelessWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context)!.auth;

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        final bool signedIn = snapshot.hasData;
        return signedIn ? const FeedPage() : const LoginPage();
      },
    );
  }
}