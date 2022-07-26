import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/addListing.dart';
import 'package:justsharelah_v1/pages/chat_page.dart';
import 'package:justsharelah_v1/pages/favourites.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';

class MyBottomNavBar {
  List widgetPages = [
    const FeedPage(),
    const ChatPage(),
    const AddListingPage(),
    Favourites(),
    ProfilePage(email: FirebaseAuth.instance.currentUser!.email),
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
        dynamic selectedRoute = widgetPages.elementAt(index);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => selectedRoute,
            ));
      },
    );
  }
}
