//TODO: USE FLUTTER VALIDATORS PACKAGE

import 'package:email_validator/email_validator.dart';

class FormValidation {
  static String? formFieldEmpty(String? text) {
    return text!.isEmpty ? "This field cannot be empty" : null;
  }

  static String? enforceNumOfChars(String? text, int numOfChars) {
    return text!.length < numOfChars
      ? "This field must have at least $numOfChars characters"
      : null;
  }

  static String? validEmail(String? email) {
    return email!.isEmpty
    ? "This field cannot be empty"
    : !EmailValidator.validate(email)
    ? "Please enter a valid email"
    : null;
  }
}
