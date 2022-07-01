import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/image_picker.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  late TextEditingController _titleController;
  late TextEditingController _listingTypeController;
  late TextEditingController _priceController;
  late TextEditingController _brandController;
  late TextEditingController _descriptionController;

  Uint8List? _image;

  final listingsCollection = FirebaseFirestore.instance.collection('listings');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;

  // for rent or borrow dropdown
  String dropdownValue = 'Lending';
  List<String> listingTypes = ['Lending', 'Renting'];

  // ================ Image functionalities ====================

  // pick image from gallery
  // Implementing the image picker

  //make call the pickImage from the image_picker.dart utils
  void selectImage() async {
    final Uint8List? pickedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  // Future<void> _galleryImage() async {
  //   final XFile? pickedImage = await _picker.pickImage(
  //       source: ImageSource.gallery, maxWidth: 1700, maxHeight: 1700);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //     });
  //   }
  // }

  // Future<void> _cameraImage() async {
  //   final XFile? pickedImage = await _picker.pickImage(
  //       source: ImageSource.camera, maxWidth: 1700, maxHeight: 1700);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //     });
  //   }
  // }

  // from camera

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

  Expanded buildFormField(String hintText, TextEditingController controller) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: SizedBox(
            width: 100,
            height: 40.0,
            child: TextField(
              onChanged: (value) => print(value),
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
              ),
            ),
          )),
    );
  }

  // create class for dropdown menu items
  DropdownButtonFormField<String> buildRentOrBorrowDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
        Radius.circular(30.0),
      ))),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward_rounded),
      elevation: 2,
      style: const TextStyle(color: Colors.grey, fontSize: 17),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: listingTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Container buildFormTitle(String text) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  // ================ Firebase interface =============

  void _addListing() {
    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching user, unable to add listing"),
        ),
      );
      return;
    }
    if (dropdownValue != 'Lending' && dropdownValue != 'Renting') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Choose a proper listing type, unable to add listing"),
        ),
      );
      return;
    }

    bool forRent = dropdownValue == 'Renting' ? true : false;

    var addedListing = {
      'image_url': _image!,
      'title': _titleController.text,
      'price': _priceController.text,
      'for_rent': forRent,
      'description': _descriptionController.text,
      'available': true,
      'created_by_email': userEmail,
      'likeCount': 0,
    };
    listingsCollection
        .add(addedListing)
        .then((value) => print('Listing Added'))
        .catchError((err) => print('Failed to add listing: $err'));
  }

  @override
  void initState() {
    userEmail = currentUser?.email;
    _titleController = TextEditingController();
    _listingTypeController = TextEditingController();
    _priceController = TextEditingController();
    _brandController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar().buildAppBar(const Text("Add Listing"), context, '/feed'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Stack(
              // circular widget to accept and show selected image
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 70,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 170, 160, 160),
                        radius: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: Image.asset('images/gallery.png',
                              width: 100, height: 120),
                        ),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      selectImage();
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
              const SizedBox(
                width: 10.0,
              ),
              buildFormField("Enter Listing Details", _titleController),
            ]),
            const SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                buildFormTitle("Listing Type"),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(child: buildRentOrBorrowDropdown()),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("Price"),
              const SizedBox(
                width: 10.0,
              ),
              buildFormField("Enter Price of Listing ", _priceController),
            ]),
            // const SizedBox(height: 10.0),
            // Row(children: <Widget>[
            //   buildFormTitle("Brand"),
            //   const SizedBox(
            //     width: 10.0,
            //   ),
            //   buildFormField("Enter Brand of Listing ", _brandController),
            // ]),
            const SizedBox(height: 10.0),
            Row(children: <Widget>[
              buildFormTitle("Description"),
              const SizedBox(
                width: 10.0,
              ),
              buildFormField("Give us a brief description of your listing",
                  _descriptionController),
            ]),
            const SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildButtonField("CANCEL", Colors.red, 20.0, () {
                Navigator.pop(context);
              }),
              const SizedBox(width: 60),
              buildButtonField("ADD LISTING", Colors.green, 30.0, () {
                _addListing();
                Navigator.pop(context);
              }),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }
}
