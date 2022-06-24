import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:justsharelah_v1/utils/const_templates.dart';
import 'package:justsharelah_v1/pages/profile_page.dart';
import 'package:justsharelah_v1/utils/appbar.dart';
import 'package:justsharelah_v1/utils/bottom_nav_bar.dart';
import 'package:justsharelah_v1/utils/profile_image.dart';

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
              buildFormField("Bio ", "Edit your Bio ", false),

              const SizedBox(
                height: 20,
              ),
              buildFormField("Password", "Edit your Password", true),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                buildButtonField(
                    "CANCEL", Colors.red, 20.0, context, ProfilePage),
                const SizedBox(width: 60),
                buildButtonField(
                    "SAVE", Colors.green, 30.0, context, ProfilePage),
              ]),
            ],
          ),
        ));
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
