// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/apptheme.dart';
import 'package:justsharelah_v1/firebase/firebase_auth_service.dart';
import 'package:justsharelah_v1/pages/activity.dart';
import 'package:justsharelah_v1/pages/addListing.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/forget_password.dart';
import 'package:justsharelah_v1/pages/signup_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/pages/account_page.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:justsharelah_v1/pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justsharelah_v1/pages/chat_page.dart';
import 'package:provider/provider.dart';

// initialize firebase app in main()
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 2
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        // 3
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth',
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Colors.indigoAccent),
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/auth': (context) => AuthenticationWrapper(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/feed': (context) => const FeedPage(),
          '/chat': (_) => const ChatPage(),
          '/addlisting': (_) => const AddListingPage(),
          '/profile': (_) => const ProfilePage(),
          '/activity': (_) => const ActivityPage(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      return const FeedPage();
    }
    return const LoginPage();
  }
}



//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       title: 'JustShareLah',
//       theme: AppTheme().buildThemeData(),
//       initialRoute: '/',
//       routes: <String, WidgetBuilder>{
//         // '/': (_) => const SplashPage(),
//         '/': (_) => const LoginPage(),
//         '/forget_password': (_) => const ForgetPassword(),
//         '/signup': (_) => const SignupPage(),
//         '/feed': (_) => const FeedPage(),
//         '/chat': (_) => const ChatPage(),
//         '/addlisting': (_) => const AddListingPage(),
//         '/profile': (_) => const ProfilePage(),
//         '/activity': (_) => const ActivityPage(),
//       },
//     );
//   }
// }
