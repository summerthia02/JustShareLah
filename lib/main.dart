import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:justsharelah_v1/pages/account_page.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:justsharelah_v1/pages/splash_page.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Use .env
  await Supabase.initialize(
    url: 'https://etegbwhzssurytyojhtf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV0ZWdid2h6c3N1cnl0eW9qaHRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTMyMTIyMjEsImV4cCI6MTk2ODc4ODIyMX0.AbyAtt9P8DPc1MuvfAaPmZ03xI9LjA4L1jc3NZujPbU',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustShareLah',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal
        ),
        textTheme: GoogleFonts.nunitoSansTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // onPrimary: Colors.teal[100],
            primary: Colors.teal[400],
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/signup': (_) => const SignupPage(),
      },
    );
  }
}
