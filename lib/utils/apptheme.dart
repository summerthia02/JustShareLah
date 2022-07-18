import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData buildThemeData() {
    return ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
        // textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        //     headline1: TextStyle().copyWith(
        //   fontSize: 72,
        // )),
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // onPrimary: Colors.teal[100],
            primary: Colors.teal[400],
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.teal,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          elevation: 10,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ));
  }

  // ThemeData(
  //     // Global Color Style
  //     primarySwatch: Colors.blueGrey,
  //     primaryColor: Colors.blueGrey[800],

  //     // Global Text Style
  //     textTheme: TextTheme(
  //       headline1: TextStyle(
  //         fontSize: 72.0,
  //         fontWeight: FontWeight.bold,
  //         fontFamily: 'Cutive',
  //       ),
  //       headline6: TextStyle(fontSize: 36.0),
  //       bodyText2: TextStyle(fontSize: 14.0),
  //     ));
}
