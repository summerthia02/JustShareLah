// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase/supabase.dart';
// import 'package:justsharelah_v1/components/auth_state.dart';
// import 'package:justsharelah_v1/utils/constants.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends AuthState<LoginPage> {
//   bool _isLoading = false;
//   late final TextEditingController _emailController;
//   late final TextEditingController _passwordController;

//   Future<void> _signIn() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final response = await supabase.auth.signIn(
//         email: _emailController.text,
//         options: AuthOptions(
//             redirectTo: kIsWeb
//                 ? null
//                 : 'io.supabase.flutterquickstart://login-callback/'));
//     final error = response.error;
//     if (error != null) {
//       context.showErrorSnackBar(message: error.message);
//     } else {
//       context.showSnackBar(message: 'Check your email for login link!');
//       _emailController.clear();
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // TODO: Do we need an appbar?
//       // appBar: AppBar(title: const Text('Welcome')),
//       body: Container(
//         padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             const SizedBox(height: 150),
//             const Text('Welcome to'),
//             const Text('JustShareLah!'),
//             const SizedBox(height: 32),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text('To get started:\n'
//                   '- Enter with your email below and click Send Magic Link\n'
//                   '- Click the link sent to your email inbox to access your account'),
//             ),
//             const SizedBox(height: 18),
//             TextFormField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//               validator: (String? value) {
//                 if (value!.isEmpty || !value.contains('@')) {
//                   return 'Email is not valid';
//                 }
//               },
//             ),
//             const SizedBox(height: 18),
//             TextFormField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               validator: (String? value) {
//                 if (value!.isEmpty) {
//                       return 'Invalid password';
//                 }
//               },
//             ),
//             const SizedBox(height: 18),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _signIn,
//                     child: Text(_isLoading ? 'Loading' : 'Send Link'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
