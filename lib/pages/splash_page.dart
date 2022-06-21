import 'dart:async';

import 'package:flutter/material.dart';

const String loggedInKey = 'LoggedIn';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final itemWidth = size.width * 0.4;
    final itemHeight = itemWidth * (size.width / size.height);
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/logo_lco.png',
                width: itemWidth,
                height: itemHeight,
              ),
            ),
          ),
          Center(
              child: Text(
            "Flutter Firebase Auth",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24,
                fontWeight: FontWeight.w700),
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/tag.png',
                width: itemWidth,
                height: itemHeight,
              ),
            ),
          )
        ]),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacementNamed(
        context,
        '/auth',
      );
    });
  }
}
// import 'package:flutter/material.dart';
// import 'package:justsharelah_v1/components/auth_state.dart';

// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);

//   @override
//   _SplashPageState createState() => _SplashPageState();
// }

// class _SplashPageState extends AuthState<SplashPage> {
//   @override
//   void initState() {
//     recoverSupabaseSession();
//     super.initState();
//   }
// flutter 
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }