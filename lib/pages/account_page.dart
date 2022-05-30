import 'package:flutter/material.dart';
import 'package:justsharelah_v1/apptheme.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/components/auth_required_state.dart';
import 'package:justsharelah_v1/utils/constants.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends AuthRequiredState<AccountPage> {
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

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    // setState(() {
    //   _loading = true;
    // });
    // final userName = _usernameController.text;
    // final website = _websiteController.text;
    // final user = supabase.auth.currentUser;
    // final updates = {
    //   'id': user!.id,
    //   'username': userName,
    //   'website': website,
    //   'updated_at': DateTime.now().toIso8601String(),
    // };
    // final response = await supabase.from('profiles').upsert(updates).execute();
    // final error = response.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // } else {
    //   context.showSnackBar(message: 'Successfully updated profile!');
    // }
    // setState(() {
    //   _loading = false;
    // });
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 64),
              const Icon(Icons.face_rounded),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "Your Username",
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headline6?.fontSize ?? 32)
                ),
              ),
              const Expanded(child: SizedBox(height: 18)),
              ElevatedButton(
                onPressed: _signOut,
                child: const Text('Sign Out')
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text("*Button to be removed subsequently"),
              ),
              const SizedBox(height: 64),
            ],
          ),
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