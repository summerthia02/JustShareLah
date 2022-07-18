// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:justsharelah_v1/firebase/auth_service.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/models/ForRenting.dart';
import 'package:justsharelah_v1/pages/login_page.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/models/ForBorrowing.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _searchController = TextEditingController();
  // Index for bottom nav bar
  late Position _currentPosition;
  var latitude = 1.0;
  var longitude = 1.0;
  late String _currentAddress;
  String? currUserId = FirebaseAuth.instance.currentUser?.uid;

  // get the user's current collection of users

  // get user current postion
  Position getCurrPosition() {
    return _currentPosition;
  }

  // ================ Determine Position + Permissions  =============

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentPosition = position;
        longitude = position.longitude;
        latitude = position.latitude;
        _currentAddress = "${place.street!}, ${place.locality!}";
      });
    } catch (e) {
      print(e);
    }

    // update user
    FireStoreMethods().updateLocation(longitude, latitude, currUserId);
  }

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
  void initState() {
    _currentPosition = Position(
        longitude: 140,
        latitude: 1.29,
        timestamp: DateTime(2022, 9, 4, 12, 20),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1);
    _determinePosition();
    super.initState();
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
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                AuthService().signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 35),
              child: Text("Logout"),
            ),
          ]),
        ],
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('images/location.png', width: 40, height: 30),
          const SizedBox(width: 10.0),
          (_currentAddress != null)
              ? Text(
                  _currentAddress,
                  style: TextStyle(fontSize: 14),
                )
              : Text('My Address'),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _determinePosition,
        tooltip: "Get Current Location",
        child: const Icon(
          Icons.change_circle_outlined,
          size: 30,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore",
                  style: kJustShareLahStyle.copyWith(
                      fontSize: 35, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Listings For You',
                  style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
                ),
                const SizedBox(height: defaultPadding),
                ForBorrowing(),
                const SizedBox(height: defaultPadding),
                ForRenting()
              ],
            ),
          ],
        ),
      ),
      //TODO: LISTINGS DONT AUTO UPDATE ON FEED PAGE AFTER LISTING IS ADDED
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
