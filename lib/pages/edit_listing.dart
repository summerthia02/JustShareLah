import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/firebase/storage_methods.dart';
import 'package:justsharelah_v1/firebase/user_data_service.dart';
import 'package:justsharelah_v1/models/share_creds.dart';

import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/appbar.dart';

class EditListingPage extends StatefulWidget {
  const EditListingPage({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  bool showPassword = true;

  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _shareCreditsController;

  late TextEditingController _descriptionController;

  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;
  late UserData userData = UserData.defaultUserData();
  String rentDropdownValue = 'Lending';
  String availDropDownValue = "yes";
  List<String> listingTypes = ['Lending', 'Renting'];
  List<String> availTypes = ['yes', 'no'];

  late Position _currentPosition;
  double latitude = 1.0;
  double longitude = 1.0;
  String _currentAddress = "My Address";

  Uint8List? _image;
  // ================ Image functionalities ====================

  // pick image from gallery
  // Implementing the image picker

  @override
  void initState() {
    userEmail = currentUser?.email;
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _shareCreditsController = TextEditingController();
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

  Future<Map<String, dynamic>> _getUserData() async {
    Map<String, dynamic> userData = <String, dynamic>{};
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar()
            .buildAppBar(const Text("Edit Listing"), context, '/feed'),
        body: Container(
          padding: EdgeInsets.only(top: 24, left: 20),
          child: ListView(children: [
            const Text(
              "Edit Listing",
              style: kHeadingText,
            ),
            Stack(
              alignment: Alignment.center,
              // circular widget to accept and show selected image
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(widget.snap["imageUrl"]),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            buildTextTitle("Title"),
            buildFormField(widget.snap["title"], false, _titleController),
            const SizedBox(
              height: 20,
            ),
            buildTextTitle("Price"),
            buildFormField(widget.snap["price"], false, _priceController),
            const SizedBox(
              height: 20,
            ),
            buildTextTitle("ShareCredits"),
            buildFormField(
                widget.snap["price"], false, _shareCreditsController),
            buildTextTitle("Description"),
            buildFormField(
                widget.snap["description"], false, _descriptionController),
            const SizedBox(
              height: 20,
            ),
            buildTextTitle("Rent / Borrow"),
            buildRentOrBorrowDropdown(),
            const SizedBox(
              height: 10,
            ),
            buildTextTitle("Available?"),
            buildAvailDropDown(),
            buildTextTitle("Location"),
            Stack(children: [
              Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                      bottom: 30, left: 250, right: 20, top: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
              Positioned(top: 17, left: 30, child: Text(_currentAddress)),
            ]),
            Container(
              padding:
                  EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
              child: FloatingActionButton(
                onPressed: _determinePosition,
                tooltip: "Get Current Location",
                child: const Icon(
                  Icons.change_circle_outlined,
                  size: 30,
                ),
              ),
            ),
            Center(
              child: Text(
                "Click to Get current Location",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildButtonField("CANCEL", Colors.red, 20.0, () {
                Navigator.pop(context);
              }),
              const SizedBox(width: 60),
              buildButtonField("SAVE", Colors.green, 20.0, () {
                _editListing(widget.snap["uid"]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(email: userEmail),
                    ));
              }),
            ]),
          ]),
        ));
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
  }

  // =================== Firestore interface =============
  void _editListing(String uid) async {
    String title, price, description, location, shareCredits;
    bool forRent, avail;
    GeoPoint geoLocation;

    title = _titleController.text.trim();
    price = _priceController.text.trim();
    shareCredits = _shareCreditsController.text.trim();
    description = _descriptionController.text.trim();
    forRent = rentDropdownValue == 'Renting' ? true : false;
    avail = availDropDownValue == "yes" ? true : false;
    location = _currentAddress;
    geoLocation = GeoPoint(latitude, longitude);

    bool editedListing = await FireStoreMethods().editListing(uid, title, price,
        shareCredits, description, forRent, avail, location, geoLocation);

    successFailSnackBar(editedListing, "Edit Listing Successful",
        "Error Editing Listing, Please try again.", context);
  }

  // ================ Widgets =============================

  Center buildTextTitle(String title) {
    return Center(
        child: Text(
      title,
      style: TextStyle(
          fontSize: 20,
          fontFamily: "Satisfy",
          fontWeight: FontWeight.w500,
          color: Colors.black),
    ));
  }

  TextFormField buildFormField(
      String hintText, bool isPassword, TextEditingController controller) {
    return TextFormField(
      obscureText: isPassword ? showPassword : false,
      textAlign: TextAlign.center,
      controller: controller,
      decoration: kTextFormFieldDecoration.copyWith(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          hintText: hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  ElevatedButton buildButtonField(
      String text, Color color, double length, void Function()? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: length),
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 15, letterSpacing: 2.5, color: Colors.black),
      ),
    );
  }

  // =================== Rent / Borrow DropDown Button   =============

  Container buildRentOrBorrowDropdown() {
    return Container(
        padding: const EdgeInsets.only(top: 10, right: 5),
        child: SizedBox(
            width: 230,
            height: 70,
            child: DropdownButtonFormField<String>(
              hint: Text("Borrowing or Renting"),
              decoration: kTextFormFieldDecoration,
              value: rentDropdownValue,
              icon: const Icon(Icons.arrow_downward_rounded),
              style: const TextStyle(color: Colors.grey, fontSize: 17),
              onChanged: (String? newValue) {
                if (mounted) {
                  setState(() {
                    rentDropdownValue = newValue!;
                  });
                }
              },
              items: listingTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )));
  }

  // =================== Available  / Unavailable DropDown Button   =============

  Container buildAvailDropDown() {
    return Container(
        padding: const EdgeInsets.only(top: 10, right: 5),
        child: SizedBox(
            width: 230,
            height: 70,
            child: DropdownButtonFormField<String>(
              hint: Text("Available or Unavailable"),
              decoration: kTextFormFieldDecoration,
              value: availDropDownValue,
              icon: const Icon(Icons.arrow_downward_rounded),
              style: const TextStyle(color: Colors.grey, fontSize: 17),
              onChanged: (String? newValue) {
                if (mounted) {
                  setState(() {
                    availDropDownValue = newValue!;
                  });
                }
              },
              items: availTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )));
  }
}
