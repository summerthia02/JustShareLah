import 'package:flutter_test/flutter_test.dart';
import 'package:justsharelah_v1/utils/form_validation.dart';

void main() {
  setUp(() {});

  group('FormValidation: Email tests', () {
    test('valid email doesnt produce error text', () {
      String testVal = "test@gmail.com";
      expect(FormValidation.validEmail(testVal), null);
    });

    test('invalid email produces error text (no @)', () {
      String testVal = "testgmail.com";
      expect(FormValidation.validEmail(testVal), "Please enter a valid email");
    });

    test('invalid email produces error text (no .com)', () {
      String testVal = "test@gmail";
      expect(FormValidation.validEmail(testVal), "Please enter a valid email");
    });

    test('invalid email produces error text (no @ and .com)', () {
      String testVal = "testgmail";
      expect(FormValidation.validEmail(testVal), "Please enter a valid email");
    });

    test('invalid email produces error text (empty string)', () {
      String testVal = "";
      expect(FormValidation.validEmail(testVal), "This field cannot be empty");
    });
  });

  group('FormValidation: Enforce chars', () {
    test(
        'input text is empty and numofChars required is 0; no error text produced',
        () {
      String testVal = "";
      int numOfChars = 0;
      expect(FormValidation.enforceNumOfChars(testVal, numOfChars), null);
    });

    test(
        'input text is empty and numofChars required is 4; error text produced',
        () {
      String testVal = "";
      int numOfChars = 4;
      expect(FormValidation.enforceNumOfChars(testVal, numOfChars),
          "This field must have at least $numOfChars characters");
    });

    test(
        'input text is of length 4 and numofChars required is 4; no error text produced',
        () {
      String testVal = "test";
      int numOfChars = 4;
      expect(FormValidation.enforceNumOfChars(testVal, numOfChars), null);
    });

    test('numofChars required is negative; no error text produced', () {
      String testVal = "test";
      int numOfChars = -1;
      expect(FormValidation.enforceNumOfChars(testVal, numOfChars), null);
    });

    test('numofChars required is negative; no error text produced', () {
      String testVal = "";
      int numOfChars = -1;
      expect(FormValidation.enforceNumOfChars(testVal, numOfChars), null);
    });
  });

  group('FormValidation: Form field empty', () {
    test('input text is empty; error text produced', () {
      String testVal = "";
      expect(FormValidation.formFieldEmpty(testVal), "This field cannot be empty");
    });

    test('input text is non-empty; no error text produced', () {
      String testVal = "test";
      expect(FormValidation.formFieldEmpty(testVal), null);
    });
  });

}
