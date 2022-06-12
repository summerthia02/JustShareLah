class FormValidation {
  static String? formFieldEmpty(String? text) {
    return text!.isEmpty ? "This field cannot be empty" : null;
  }
}
