//TODO: USE FLUTTER VALIDATORS PACKAGE

class FormValidation {
  static String? formFieldEmpty(String? text) {
    return text!.isEmpty ? "This field cannot be empty" : null;
  }

  static String? enforceNumOfChars(String? text, int numOfChars) {
    return text!.length < numOfChars
      ? "This field must have at least $numOfChars characters"
      : null;
  }
}
