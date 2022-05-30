import 'package:flutter/material.dart';
import 'package:justsharelah_v1/apptheme.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/components/auth_required_state.dart';
import 'package:justsharelah_v1/utils/constants.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends AuthRequiredState<FeedPage> {
  final _searchController = TextEditingController();
  var _loading = false;

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Page"),
        centerTitle: true,  
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: const [
          SizedBox.expand(),
          Text("Items will be displayed here."),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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