// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:justsharelah_v1/apptheme.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/components/auth_required_state.dart';
import 'package:justsharelah_v1/utils/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends AuthRequiredState<FeedPage> {
  final _searchController = TextEditingController();
  var _loading = false;
  // Index for bottom nav bar
  int _selectedIndex = 0;

  // Routing for bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _loading = true;
    });
    switch (index) {
      case 0:
        // _navigatorKey.currentState!.pushNamed("/chat");
        break;
      case 1:
        // _navigatorKey.currentState!.pushNamed("/addlisting");
        break;
      case 2:
        Navigator.of(context).pushNamed("/account");
        break;
    }
    setState(() {
      _selectedIndex = index;
      _loading = false;
    });
  }

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile(String userId) async {
    // setState(() {
    //   _loading = true;
    // });
    // final response = await supabase
    //     .from('profiles')
    //     .select()
    //     .eq('id', userId)
    //     .single()
    //     .execute();
    // final error = response.error;
    // if (error != null && response.status != 406) {
    //   context.showErrorSnackBar(message: error.message);
    // }
    // final data = response.data;
    // if (data != null) {
    //   _usernameController.text = (data['username'] ?? '') as String;
    //   _websiteController.text = (data['website'] ?? '') as String;
    // }
    // setState(() {
    //   _loading = false;
    // });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JustShareLah!"),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
              Navigator.pop(context);
            }),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text("Items will be displayed here."),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _loading ? null : _onItemTapped,
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
      ),
    );
  }
}
