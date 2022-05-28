// import 'package:flutter/material.dart';
// import 'package:supabase/supabase.dart';
// import 'package:justsharelah_v1/core/toast.dart';

// const String supabaseUrl = "your supabase url goes here ";
// const String token =
//     "your supabase token goes here";

// class SupabaseManager {
//   final client = SupabaseClient(supabaseUrl, token);


//   Future<void> signUpUser(context, {String? email, String? password}) async {
//     debugPrint("email:$email password:$password");
//     final result = await client.auth.signUp(email!, password!);

//     debugPrint(result.data!.toJson().toString());

//     if (result.data != null) {
//       showToastMessage('Registration Success', isError: false);
//       Navigator.pushReplacementNamed(context, 'login');
//       showToastMessage('Success', isError: false);
//     } else if (result.error?.message != null) {
//       showToastMessage('Error:${result.error!.message.toString()}',
//           isError: true);
//     }
//   }

//   Future<void> signInUser(context, {String? email, String? password}) async {
//     debugPrint("email:$email password:$password");
//     final result = await client.auth.signIn(email: email!, password: password!);
//     debugPrint(result.data!.toJson().toString());

//     if (result.data != null) {
//       showToastMessage('Login Success', isError: false);
//       Navigator.pushReplacementNamed(context, '/home');
//       showToastMessage('Success', isError: false);
//     } else if (result.error?.message != null) {
//       showToastMessage('Error:${result.error!.message.toString()}',
//           isError: true);
//     }
//   }


//   Future<void> logout (context)async{
//     await client.auth.signOut();
//     Navigator.pushReplacementNamed(context, 'login');
//   }
// }