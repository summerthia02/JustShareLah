import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:justsharelah_v1/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // widget testing
  testWidgets("full app test", (tester) async {
    app.main();

    // app state to stay the same
    await tester.pumpAndSettle();

    // create finders for email, password and login

    final emailFormField = find.byKey(Key("Email"));
    final passwordFormField = find.byKey(Key("Password"));

    final loginButton = find.byKey(Key("LogIn"));

    // enter text for email and password
    await tester.enterText(emailFormField, "summer@gmail.com");
    await tester.enterText(passwordFormField, "summertest");
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
  });
}
