// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/form_validation.dart';
import 'package:justsharelah_v1/utils/dropdown.dart';

import '../utils/appbar.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({Key? key}) : super(key: key);

  @override
  State<AddListingPage> createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  File? _image;

  final ImagePicker _picker = ImagePicker();

  // pick image from gallery
  // Implementing the image picker
  Future<void> _galleryImage() async {
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 1700, maxHeight: 1700);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _cameraImage() async {
    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera, maxWidth: 1700, maxHeight: 1700);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // from camera

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          MyAppBar().buildAppBar(const Text("Add Listing"), context, '/feed'),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              child: Text(
                'Add Image',
                style: TextStyle(fontSize: 15, fontFamily: 'Lato'),
              ),
              onPressed: () {
                _cameraImage();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ),
          Row(children: <Widget>[
            buildFormTitle("Listing Title"),
            const SizedBox(
              width: 10.0,
            ),
            buildFormField(
              "Enter Listing Details",
            ),
          ]),
          const SizedBox(height: 10.0),
          Row(
            children: <Widget>[
              buildFormTitle("Listing Type"),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(child: MyDropDownButton()),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(children: <Widget>[
            buildFormTitle("Price"),
            const SizedBox(
              width: 10.0,
            ),
            buildFormField(
              "Enter Price of Listing ",
            ),
          ]),
          const SizedBox(height: 10.0),
          Row(children: <Widget>[
            buildFormTitle("Brand"),
            const SizedBox(
              width: 10.0,
            ),
            buildFormField(
              "Enter Brand of Listing ",
            ),
          ]),
          const SizedBox(height: 10.0),
          Row(children: <Widget>[
            buildFormTitle("Description"),
            const SizedBox(
              width: 10.0,
            ),
            buildFormField(
              "Give us a brief description of your listing ",
            ),
          ]),
          const SizedBox(height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            buildButtonField("CANCEL", Colors.red, 20.0, context, FeedPage()),
            const SizedBox(width: 60),
            buildButtonField(
                "ADD LISTING", Colors.green, 30.0, context, ProfilePage()),
          ]),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }

  Expanded buildFormField(String hintText) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: SizedBox(
            width: 100,
            height: 40.0,
            child: TextField(
                decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(30))),
              hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
            )),
          )),
    );
  }

  // create class for dropdown menu items

  Container buildFormTitle(String text) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
