import 'dart:ffi';
import 'dart:html';

class UserData {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? about;
  final String? imageUrl;
  final List<String> listings;

  UserData({
    required this.uid,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.about,
    required this.imageUrl,
    required this.listings,
  });

  static UserData loadingUserData() {
    return UserData(
      uid: "Loading",
      userName: "Loading",
      firstName: "Loading",
      lastName: "Loading",
      email: "Loading",
      phoneNumber: "Loading",
      about: "Loading",
      imageUrl: "Loading",
      listings: []
    );
  }
}
