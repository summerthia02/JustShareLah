import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar()
            .buildAppBar(const Text("Edit Profile"), context, '/feed'),
        body: Container(
          padding: EdgeInsets.only(top: 24, left: 20),
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: kHeadingText,
              ),
              const SizedBox(
                height: 20,
              ),
              const ProfileImage(),
              const SizedBox(
                height: 20,
              ),
              // edit email
              buildFormField("Email", "Edit your Email", false),

              const SizedBox(
                height: 20,
              ),
              buildFormField("First Name", "Edit your First Name", false),
              const SizedBox(
                height: 20,
              ),
              buildFormField("Last Name", "Edit your Last Name", false),

              const SizedBox(
                height: 20,
              ),
              buildFormField("User Name", "Edit your UserName", false),

              const SizedBox(
                height: 20,
              ),
              buildFormField("Email ", "Edit your Email ", false),

              const SizedBox(
                height: 20,
              ),
              buildFormField("Password", "Edit your Password", true),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                buildButtonField("CANCEL", Colors.red, 20.0),
                const SizedBox(width: 60),
                buildButtonField("SAVE", Colors.green, 30.0),
              ]),
            ],
          ),
        ));
  }

  ElevatedButton buildButtonField(String text, Color color, double length) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
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

  TextFormField buildFormField(
      String labelText, String hintText, bool isPassword) {
    return TextFormField(
      obscureText: isPassword ? showPassword : false,
      textAlign: TextAlign.center,
      decoration: kTextFormFieldDecoration.copyWith(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
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
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2.3,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2))
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    image: NetworkImage(
                        "https://www.pngall.com/wp-content/uploads/5/Profile-Male-PNG.png"))),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                shape: BoxShape.circle,
                color: Colors.cyan,
              ),
              child: Icon(Icons.edit, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
