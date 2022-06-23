import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/apptheme.dart';
import 'package:justsharelah_v1/models/profile_widget.dart';
import 'package:justsharelah_v1/pages/edit_profile.dart';
import 'package:justsharelah_v1/test%20data/user_info.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _loading = false;
  // Index for bottom nav bar
  int _selectedIndex = 0;
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
    // final response = await supabase.auth.signOut();
    // final error = response.error;
    // if (error != null) {
    //   context.showErrorSnackBar(message: error.message);
    // }
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
    // get the current usr
    // new instance of userfactory
    final userFactory = UserInfo();
    final fakeUser = userFactory.generateFake();

    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Profile"), context, '/feed'),
      // if add appbar -> two layers of appbar will appear.
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // ProfileWidget(
          //   imageUrl: fakeUser.imageUrl,
          //   onClicked: () async {},
          // ),

          const SizedBox(height: 30),
          buildName(fakeUser),
          const SizedBox(height: 12),
          editProfileButton(),

          const SizedBox(height: 24),
          buildAbout(fakeUser),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }

  Align editProfileButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(),
              ));
        },
        child: Text('Edit Profile'),
        style: ElevatedButton.styleFrom(
            primary: Colors.black,
            elevation: 2,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40))),
      ),
    );
  }

  Widget buildName(var fakeUser) => Column(
        children: [
          Text(
            fakeUser.userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            fakeUser.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(fakeUser) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "i like to sell clothes",
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  EditProfile() {}

  // build user's username, first and last name

  // Routing for bottom nav bar
}

/// Called once a user id is received within `onAuthenticated()`

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       // if add appbar -> two layers of appbar will appear.
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 64),
//             const Icon(Icons.face_rounded),
//             const SizedBox(height: 12),
//             Center(
//               child: Text("Your Username",
//                   style: TextStyle(
//                       fontSize:
//                           Theme.of(context).textTheme.headline6?.fontSize ??
//                               32)),
//             ),
//             const Expanded(child: SizedBox(height: 18)),
//             ElevatedButton(onPressed: _signOut, child: const Text('Sign Out')),
//             const SizedBox(height: 8),
//             const Center(
//               child: Text("*Button to be removed subsequently"),
//             ),
//             const SizedBox(height: 64),
//           ],
//         ),
//       ),
//     );
//   }
// }
