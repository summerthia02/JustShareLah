// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justsharelah_v1/pages/feed_page.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/utils/dropdown.dart';
import 'package:justsharelah_v1/utils/form_validation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: SizedBox(
          height: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Expanded(
                  flex: 4,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: buildFormTitle("Listing Title"),
                          ),
                          Container(
                            child: buildFormField("Enter Listing Title"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Container(
                            child: buildFormTitle("Listing Type"),
                          ),
                          Container(
                            child: Expanded(child: MyDropDownButton()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Container(
                            child: buildFormTitle("Price"),
                          ),
                          Container(
                            child: Expanded(
                              child: buildFormField("Enter Price of Listing"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Container(
                            child: buildFormTitle("Description"),
                          ),
                          Container(
                            child: Expanded(
                              child: buildFormField("Enter Brand of Listing"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Container(
                            child: buildFormTitle("Brand"),
                          ),
                          Container(
                            child: Expanded(
                                child: buildFormField(
                                    "Give us a brief description of your listing ")),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(
                            flex: 4,
                          )
                        ],
                      ),
                    ],
                  ))),
              const SizedBox(height: 10.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                buildButtonField("CANCEL", Colors.red, 20.0),
                const SizedBox(width: 60),
                buildButtonField("ADD LISTING", Colors.green, 30.0),
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar().buildBottomNavBar(context),
    );
  }

  ElevatedButton buildButtonField(String text, Color color, double length) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedPage()));
      },
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
              ),
            ),
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
