import 'package:flutter/material.dart';

class MyBottomNavBar {
  List<String> widgetPages = <String>[
    "/feed",
    "/chat",
    "/addlisting",
    "/profile",
  ];

  BottomNavigationBar buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          activeIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_outlined),
          activeIcon: Icon(Icons.add),
          label: 'Add Listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
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
