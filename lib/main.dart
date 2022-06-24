import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/utils/apptheme.dart';
import 'package:justsharelah_v1/pages/activity.dart';
import 'package:justsharelah_v1/pages/addListing.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/forget_password.dart';
import 'package:justsharelah_v1/home_controller.dart';
import 'package:justsharelah_v1/pages/signup_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:justsharelah_v1/pages/splash_page.dart';
import 'package:justsharelah_v1/pages/chat_page.dart';

import 'firebase/auth_provider.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'JustShareLah',
        theme: AppTheme().buildThemeData(),
        navigatorKey: navigatorKey,
        home: const HomeController(),
        routes: <String, WidgetBuilder>{
          '/forget_password': (_) => const ForgetPasswordPage(),
          '/login': (_) => const LoginPage(),
          '/signup': (_) => const SignupPage(),
          '/feed': (_) => const FeedPage(),
          '/chat': (_) => const ChatPage(),
          '/addlisting': (_) => const AddListingPage(),
          '/profile': (_) => const ProfilePage(),
          '/activity': (_) => const ActivityPage(),
          '/reviews': (_) => const MakeReviewPage(),

        },
      ),
    );
  }
}
