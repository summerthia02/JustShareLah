import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/firebase/storage_methods.dart';
import 'package:justsharelah_v1/pages/edit_profile.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:justsharelah_v1/models/ForBorrowing.dart';
import 'package:justsharelah_v1/models/ForRenting.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/image_picker.dart';
import 'package:justsharelah_v1/utils/profile_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;
  late UserData userData = UserData.defaultUserData();

  var profileData = {};

  // access the usertable, then get the data where email field == current email
  Future<Map<String, dynamic>> _getUserData() async {
    Map<String, dynamic> userData = <String, dynamic>{};
    // get 
    await usersCollection.where('email', isEqualTo: userEmail).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
      },
      onError: (e) => print("Error completing: $e"),
    );

    return userData;
  }

  @override
  void initState() {
    userEmail = currentUser?.email;
    _getUserData().then((data) {
      UserData parseUserData = UserData(
        uid: currentUser?.uid,
        userName: data["username"],
        firstName: data["first_name"],
        lastName: data["last_name"],
        email: userEmail,
        phoneNumber: data["phone_number"],
        about: data["about"],
        imageUrl: data["imageUrl"],
        listings: data["listings"],
        reviews: data["reviews"],
        shareCredits: data["share_credits"],
      );
      setState(() {
        userData = parseUserData;
      });
    });
    super.initState();
  }

  getProfileData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.uid)
          .get();
      profileData = snap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().buildAppBar(const Text("Profile"), context, '/feed'),
      // if add appbar -> two layers of appbar will appear.
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 15),
            Stack(
              alignment: Alignment.center,
              // circular widget to accept and show selected image
              children: [
                userData.imageUrl != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(userData.imageUrl!),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.asset('images/def_dp.png',
                              width: 250, height: 200),
                        ),
                      ),
              ],
            ),
            buildName(userData),
            const SizedBox(height: 12),
            numReviews(userData.reviews.length),
            numShareCredits(
                userData.shareCredits.isEmpty ? "0" : userData.shareCredits),
            editProfileButton(),
            const SizedBox(height: 24),
            buildAbout(userData),
            const SizedBox(height: defaultPadding),
            ForBorrowing(userEmailToDisplay: userEmail),
            const SizedBox(height: defaultPadding),
            ForRenting(userEmailToDisplay: userEmail)
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }

  Row numReviews(int numReviews) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          numReviews.toString(),
          style: kBodyTextSmall.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline),
        ),
        Text(
          " Reviews",
          style: kBodyTextSmall.copyWith(decoration: TextDecoration.underline),
        ),
      ],
    );
  }

  Row numShareCredits(String numShareCreds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ShareCredits: ",
          style: kBodyTextSmall.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          numShareCreds.toString(),
          style: kBodyTextSmall,
        ),
      ],
    );
  }

  // ===================== Widgets =================================
  Align editProfileButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfilePage(),
              ));
        },
        child: const Text('Edit Profile'),
        style: ElevatedButton.styleFrom(
            primary: Colors.black,
            elevation: 2,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40))),
      ),
    );
  }

  Widget buildName(UserData userData) => Column(
        children: [
          Text(
            userData.userName ?? "Error loading username",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            userData.email ?? "Error loading email",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(UserData userData) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userData.about.toString(),
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

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
