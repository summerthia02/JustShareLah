import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:justsharelah_v1/firebase/firestore_methods.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/image_picker.dart';
import 'package:justsharelah_v1/provider/user_provider.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _listingTypeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _shareCreditsController = TextEditingController();

  //listing image
  Uint8List? _image;
  final listingsCollection = FirebaseFirestore.instance.collection('listings');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  late UserData userData;
  // for rent or borrow dropdown
  String dropdownValue = 'Lending';
  List<String> listingTypes = ['Lending', 'Renting'];
  late Position _currentPosition;
  double latitude = 1.0;
  double longitude = 1.0;
  String _currentAddress = "My Address";
  String? currUserId = FirebaseAuth.instance.currentUser?.uid;

  // ================ User Information =============================

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
      if (mounted) {
        setState(() {
          userData = parseUserData;
        });
      }
    });
    _determinePosition();

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

  // ================ ImagePickers =============================
  void selectImageGallery() async {
    final Uint8List? pickedImage = await pickImage(ImageSource.gallery);
    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  void selectImageCamera() async {
    final Uint8List? pickedImage = await pickImage(ImageSource.camera);
    if (mounted) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  // ================ Image Diaglogue ====================

  // pick image from gallery
  // Implementing the image picker

  // make call the pickImage from the image_picker.dart utils
  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List imagePicked = await pickImage(ImageSource.camera);
                  if (mounted) {
                    setState(() {
                      _image = imagePicked;
                    });
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List imagePicked = await pickImage(ImageSource.gallery);
                  if (mounted) {
                    setState(() {
                      _image = imagePicked;
                    });
                  }
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  // ================ Firebase interface =============

  bool addListingChecks(bool forRent) {
    if (userEmail == null) {
      showSnackBar(context, "Error fetching user, unable to add listing");
      return false;
    }
    if (dropdownValue != 'Lending' && dropdownValue != 'Renting') {
      showSnackBar(
          context, 'Choose a proper listing type, unable to add listing');
      return false;
    }

    if (_titleController.text == '') {
      showSnackBar(context, 'Please add a title');
      return false;
    }

    if (_image == null) {
      showSnackBar(context, 'Please add image!');
      return false;
    }

    if (forRent && _priceController.text == '') {
      showSnackBar(context, 'Please add your price for renting');
      return false;
    }

    if (!forRent && _priceController.text != '0') {
      showSnackBar(context, 'As you are lending item, please input 0 as price');
      return false;
    }

    return true;
  }

  Future<bool> addListing() async {
    bool forRent = dropdownValue == 'Renting' ? true : false;
    bool validListing = addListingChecks(forRent);
    if (!validListing) return false;

    try {
      // upload to both storage and 'listing' collection
      String res = await FireStoreMethods().uploadlisting(
        _titleController.text,
        _descriptionController.text,
        _image!,
        userData.uid!,
        userData.email!,
        userData.imageUrl!,
        forRent,
        _priceController.text,
        _shareCreditsController.text,
        longitude,
        latitude,
        _currentAddress,
      );
      print(res);
      if (res == "success") {
        showSnackBar(context, 'Added Listing!');
        clearImage();
      }
    } catch (err) {
      print(err);
      return false;
    }

    return true;
  }

  void clearImage() {
    if (mounted) {
      setState(() {
        _image = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _listingTypeController.dispose();
  }

  // ================ Widgets =============================

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

  Container buildFormField(String hintText, TextEditingController controller,
      {double height = 40.0, int numLines = 1}) {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20),
      child: SizedBox(
        width: 230,
        height: height,
        child: TextField(
          minLines: numLines,
          maxLines: numLines,
          onChanged: (value) => print(value),
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            hintText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            hintStyle: const TextStyle(fontSize: 17, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // Container locationField(String initialValue,
  //     {double height = 80.0, int numLines = 2}) {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 20, right: 20),
  //     child: SizedBox(
  //       width: 230,
  //       height: height,
  //       child: TextFormField(
  //         initialValue: initialValue,
  //         minLines: numLines,
  //         maxLines: numLines,
  //         onChanged: (value) => print(value),
  //         decoration: InputDecoration(
  //           contentPadding:
  //               const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //           border: const OutlineInputBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(30))),
  //           hintStyle: const TextStyle(fontSize: 17, color: Colors.grey),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // create class for dropdown menu items
  Container buildRentOrBorrowDropdown() {
    return Container(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: SizedBox(
            width: 230,
            height: 40,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ))),
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward_rounded),
              style: const TextStyle(color: Colors.grey, fontSize: 17),
              onChanged: (String? newValue) {
                if (mounted) {
                  setState(() {
                    dropdownValue = newValue!;
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

  Container buildFormTitle(String text) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Text(
        text,
        style: TextStyle(fontSize: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // to add the search split into the listing fields (title)

    return Scaffold(
      appBar:
          MyAppBar().buildAppBar(const Text("Add Listing"), context, '/feed'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              // circular widget to accept and show selected image
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 70, backgroundImage: MemoryImage(_image!))
                    : CircleAvatar(
                        radius: 70,
                        backgroundColor:
                            const Color.fromARGB(255, 226, 224, 224),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset('images/gallery.png',
                              width: 100, height: 120),
                        ),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      _selectImage(context);
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Row(children: <Widget>[
              buildFormTitle("Listing Title"),
              const Expanded(
                  child: SizedBox(
                width: 5,
              )),
              buildFormField("Enter Listing Details", _titleController),
            ]),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildFormTitle("Listing Type"),
                const Expanded(
                    child: SizedBox(
                  width: 5,
                )),
                buildRentOrBorrowDropdown(),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("Price"),
              const Expanded(
                  child: SizedBox(
                width: 5,
              )),
              buildFormField("Price (renting) ", _priceController),
            ]),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("ShareCredits"),
              const Expanded(
                  child: SizedBox(
                width: 5,
              )),
              Container(
                child: buildFormField(
                    "ShareCredits (lending) ", _shareCreditsController),
              ),
            ]),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("Description "),
              const Expanded(
                  child: SizedBox(
                width: 5,
              )),
              buildFormField("Give us a brief description of your listing",
                  _descriptionController,
                  height: 100, numLines: 5),
            ]),
            const SizedBox(height: 10.0),
            Row(children: [
              buildFormTitle("Location"),
              const Expanded(child: SizedBox()),
              // locationField(
              //     "Location",)
              Stack(children: [
                Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(
                        bottom: 30, left: 250, right: 20, top: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(30)))),
                Positioned(top: 17, left: 30, child: Text(_currentAddress)),
              ]),
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
            Text(
              "Click to Get current Location",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildButtonField("CANCEL", Colors.red, 20.0, () {
                Navigator.pop(context);
              }),
              const SizedBox(width: 60),
              buildButtonField("ADD LISTING", Colors.green, 30.0, () async {
                bool success = await addListing();
                if (success) Navigator.pop(context);
              }),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
