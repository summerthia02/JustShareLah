// import 'package:flutter/material.dart';
// import 'package:justsharelah_v1/utils/constants.dart';

// class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
//   @override
//   void onUnauthenticated() {
//     if (mounted) {
//       Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//     }
//   }

//   @override
//   void onAuthenticated(Session session) {
//     if (mounted) {
//       Navigator.of(context)
//           .pushNamedAndRemoveUntil('/feed', (route) => false);
//     }
//   }

//   @override
//   void onPasswordRecovery(Session session) {}

//   @override
//   void onErrorAuthenticating(String message) {
//     context.showErrorSnackBar(message: message);
//   }
// }