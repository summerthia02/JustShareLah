import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/apptheme.dart';
import 'package:justsharelah_v1/pages/addListing.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/forget_password.dart';
import 'package:justsharelah_v1/pages/signup_page.dart';
import 'package:justsharelah_v1/profile_page.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:justsharelah_v1/pages/splash_page.dart';
import 'package:justsharelah_v1/pages/chat_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustShareLah',
      theme: AppTheme().buildThemeData(),
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/forget_password': (_) => const ForgetPassword(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/feed': (_) => const FeedPage(),
        '/chat': (_) => const ChatPage(),
        '/addlisting': (_) => const AddListingPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}
