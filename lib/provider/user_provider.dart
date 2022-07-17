import 'package:flutter/widgets.dart';
import 'package:justsharelah_v1/firebase/auth_methods.dart';

import 'package:justsharelah_v1/models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;

  UserData get getUser => _user!;

  Future<void> refreshUser() async {
    UserData user = await AuthMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
