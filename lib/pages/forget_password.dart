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
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Forgot Password',
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 60.0,
                    ),
                    Text(
                      'Enter your email\nWe will send you instructions to reset your password',
                        textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
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
