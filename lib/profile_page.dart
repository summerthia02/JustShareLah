import 'package:flutter/material.dart';
import 'package:justsharelah_v1/apptheme.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/components/auth_required_state.dart';
import 'package:justsharelah_v1/utils/constants.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'const_templates.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatFeedCore(
      feedBuilder: 'user',
      loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error) => const Center(child: Text('Error Loading Profile'),
      ),
      emptyBuilder: (context) => const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileAppBar(
              numListings: 0,
            ),
          ),
          SliverToBoxAdapter(
            child: _EditProfile(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
          SliverFillRemaining(child: _NoListingsText())

        ],
      ),
      feedBuilder: (context, activities) {
        return Text('TODO'); // TODO Show Activtieis 
   },
    );

}
}

class _EditProfile extends StatelessWidget {
  const _EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: OutlinedButton(onPressed: () {

    },
    child: const Text('Edit Profile'),
    ),
    );
    

  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({Key? key, required this.numListings,}) : super(key: key);

  // numListings as an attribute that is required 
  final int numListings;

  static const _statsPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<AppState>();
    final jslUser = feedState.jslUser;
    if (jslUser == null) {
      return const SizedBox.shrink();
    }
    return Column(children: [
      Padding(padding: const EdgeInsets.all(9.0),
      child: Avatar.big(
        jslUser: jslUser,
      ),
    ),
    const Spacer(),
    Row(mainAxisSize: MainAxisSize.min,
    children: [
      Padding(padding: _statsPadding,
      child: Column(children: [
        Text(
          '$numListings',
          style: kBodyText, 
        ),
        const Text(
          'Listings',
          style: kBodyText,
        ),
      ],
      ),
      ),
      Align(alignment: Alignment.centerLeft,
      child: Padding(padding: const EdgeInsets.all(9.0),
      child: 
        Text(
          jslUser.fullName,
          style: kBodyText),
      ),
      ),
    ],
    );
  
  }
}

class _NoListingsText extends StatelessWidget {
  const _NoListingsText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('User has not posted'),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () {
          // TOOD 
        }, child: const Text('Add a Listing'),
      
    )
      ],
    );
  }
}


// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends AuthRequiredState<ProfilePage> {
//   var _loading = false;
//   // Index for bottom nav bar
//   int _selectedIndex = 0;

//   // Routing for bottom nav bar
//   void _onItemTapped(int index) {
//     setState(() {
//       _loading = true;
//     });
//     switch (index) {
//       case 0:
//         // _navigatorKey.currentState!.pushNamed("/Profile");
//         break;
//       case 1:
//         // _navigatorKey.currentState!.pushNamed("/addlisting");
//         break;
//       case 2:
//         Navigator.of(context).pushNamed("/chat");
//         break;
//     }
//     setState(() {
//       _selectedIndex = index;
//       _loading = false;
//     });
//   }

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     // if add appbar -> two layers of appbar will appear.
  //     body: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           const SizedBox(height: 64),
  //           const Icon(Icons.face_rounded),
  //           const SizedBox(height: 12),
  //           Center(
  //             child: Text("Your Username",
  //                 style: TextStyle(
  //                     fontSize:
  //                         Theme.of(context).textTheme.headline6?.fontSize ??
  //                             32)),
  //           ),
  //           const Expanded(child: SizedBox(height: 18)),
  //           ElevatedButton(onPressed: _signOut, child: const Text('Sign Out')),
  //           const SizedBox(height: 8),
  //           const Center(
  //             child: Text("*Button to be removed subsequently"),
  //           ),
  //           const SizedBox(height: 64),
  //         ],
  //       ),
  //     ),
  //     bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
  //   );
  // }

