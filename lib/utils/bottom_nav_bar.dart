import 'package:flutter/material.dart';

class MyBottomNavBar {
  List<String> widgetPages = <String>[
    "/feed",
    "/chat",
    "/addlisting",
    "/favourites",
    "/profile",
  ];

  BottomNavigationBar buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.pink,
          ),
          activeIcon: Icon(Icons.home),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            color: Colors.purple,
          ),
          activeIcon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo, color: Colors.grey),
          activeIcon: Icon(Icons.add_a_photo_rounded),
          label: 'Add Listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.red),
          activeIcon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Colors.orange,
          ),
          activeIcon: Icon(Icons.person),
          label: 'User Profile',
        ),
      ],
      onTap: (index) {
        String selectedRoute = widgetPages.elementAt(index);
        Navigator.of(context).pushNamed(selectedRoute).then((_) => null);
      },
    );
  }
}
