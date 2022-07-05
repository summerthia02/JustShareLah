import 'package:flutter/widgets.dart';
import 'package:justsharelah_v1/firebase/auth_methods.dart';

import 'package:justsharelah_v1/models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserData get getUser => _user!;

  Future<void> refreshUser() async {
    UserData user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
