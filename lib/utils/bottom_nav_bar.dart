import 'package:flutter/material.dart';

class MyBottomNavBar {
  List<String> widgetPages = <String>[
    "/chat",
    "/addlisting",
    "/profile",
  ];

  BottomNavigationBar buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face_outlined),
          label: 'User Profile',
        ),
      ],
      onTap: (index) {
        String selectedRoute = widgetPages.elementAt(index);
        Navigator.of(context).pushNamed(selectedRoute);
      },
    );
  }
}
