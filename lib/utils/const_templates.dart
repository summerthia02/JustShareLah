// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double defaultPadding = 16.0;
const double defaultBorderRadius = 12.0;

const kJustShareLahStyle = TextStyle(
  fontFamily: 'Lato',
  fontSize: 45.0,
  fontWeight: FontWeight.w200,
);

const kBodyText = TextStyle(
  fontFamily: 'Lato',
  fontSize: 22.0,
  color: Colors.black,
  height: 1.5,
);

const kHeadingText = TextStyle(
  fontFamily: 'Lato',
  fontSize: 25.0,
  color: Colors.black,
  height: 1.5,
);




const kTextFormFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 22.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
);

// List<PersistentBottomNavBarItem> navBarsItems = [
//   PersistentBottomNavBarItem(
//     icon: Icon(CupertinoIcons.home),
//     title: ("Home"),
//     activeColorPrimary: CupertinoColors.activeBlue,
//     inactiveColorPrimary: CupertinoColors.systemGrey,
//   ),
//   PersistentBottomNavBarItem(
//     icon: Icon(CupertinoIcons.settings),
//     title: ("Settings"),
//     activeColorPrimary: CupertinoColors.activeBlue,
//     inactiveColorPrimary: CupertinoColors.systemGrey,
//   ),
// ];
