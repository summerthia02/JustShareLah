import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justsharelah_v1/firebase/storage_methods.dart';
import 'package:justsharelah_v1/models/user_data.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:justsharelah_v1/utils/image_picker.dart';
import 'package:justsharelah_v1/utils/profile_image.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = true;

  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser;
  late String? userEmail;
  late UserData userData = UserData.defaultUserData();

  Uint8List? _image;
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

  @override
  void initState() {
    userEmail = currentUser?.email;
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
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
            .buildAppBar(const Text("Edit Profile"), context, '/feed'),
        body: Container(
          padding: EdgeInsets.only(top: 24, left: 20),
          child: ListView(
            children: [
              const Text(
                "Edit Profile",
                style: kHeadingText,
              ),
              Stack(
                alignment: Alignment.center,
                // circular widget to accept and show selected image
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: MemoryImage(_image!),
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
                  Positioned(
                    bottom: -10,
                    right: 135,
                    child: IconButton(
                      color: Colors.red,
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              buildFormField("First Name", userData.firstName, false,
                  _firstnameController),
              const SizedBox(
                height: 20,
              ),
              buildFormField(
                  "Last Name", userData.lastName, false, _lastnameController),
              const SizedBox(
                height: 20,
              ),
              buildFormField(
                  "User Name", userData.userName, false, _usernameController),
              const SizedBox(
                height: 20,
              ),
              buildFormField("Bio ", userData.about, false, _bioController),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                buildButtonField("CANCEL", Colors.red, 20.0, () {
                  Navigator.of(context).pop();
                }),
                const SizedBox(width: 60),
                buildButtonField("SAVE", Colors.green, 20.0, () {
                  _editProfile();
                  Navigator.of(context).pop();
                }),
              ]),
            ],
          ),
        ));
  }

  // =================== Firestore interface =============
  void _editProfile() async {
    Map<String, dynamic>? userData;
    String? docID;
    await usersCollection.where("email", isEqualTo: userEmail).get().then(
      (res) {
        print("userData query successful");
        userData = res.docs.first.data();
        docID = res.docs.first.id;
      },
      onError: (e) => print("Error completing: $e"),
    );

    if (userEmail == null || userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching user, unable to edit profile"),
        ),
      );
      return;
    }

    // profile image
    String? photoUrl = await StorageMethods()
        .uploadPicToStorage('profilePictures', _image!, false);

    // if empty, remains the same, else take the controller variable
    userData!["imageUrl"] = _image == null ? userData!["imageUrl"] : photoUrl;

    userData!["first_name"] = _firstnameController.text.isEmpty
        ? userData!["first_name"]
        : _firstnameController.text;
    userData!["last_name"] = _lastnameController.text.isEmpty
        ? userData!["last_name"]
        : _lastnameController.text;
    userData!["username"] = _usernameController.text.isEmpty
        ? userData!["username"]
        : _usernameController.text;
    userData!["about"] =
        _bioController.text.isEmpty ? userData!["about"] : _bioController.text;

    usersCollection
        .doc(docID)
        .update(userData!)
        .then((value) => print('Edited Profile'))
        .catchError((err) => print('Failed to edit profile: $err'));
  }

  // ================ Widgets =============================
  TextFormField buildFormField(String labelText, dynamic hintText,
      bool isPassword, TextEditingController controller) {
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
          labelText: labelText,
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
}
