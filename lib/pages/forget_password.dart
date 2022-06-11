// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:justsharelah_v1/utils/constants.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.cyan,
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Forgot Password',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60.0,
                    ),
                    Container(
                      width: 3000,
                      child: Text(
                        'Enter your email we will send instruction to reset your password',
                        style: kBodyText,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: false,
                      textAlign: TextAlign.center,
                      decoration: kTextFormFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Send')),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
