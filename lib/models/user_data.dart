import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? about;
  final String? imageUrl;
  final List<dynamic> listings;
  final List<dynamic> reviews;
  final String shareCredits;

  UserData(
      {required this.uid,
      required this.userName,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.about,
      required this.imageUrl,
      required this.listings,
      required this.reviews,
      required this.shareCredits});

  static UserData defaultUserData() {
    return UserData(
      uid: "Loading",
      userName: "Loading",
      firstName: "Loading",
      lastName: "Loading",
      email: "Loading",
      phoneNumber: "Loading",
      about: "Loading",

      imageUrl: "https://www.computerhope.com/jargon/g/guest-user.jpg",
      listings: [],
      reviews: [],
      shareCredits: "Loading",
    );
  }

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserData(
      userName: snapshot["userName"],
      uid: snapshot["uid"],
      firstName: snapshot["firstName"],
      lastName: snapshot["lastName"],
      phoneNumber: snapshot["phoneNumber"],
      about: snapshot["about"],
      email: snapshot["email"],
      imageUrl: snapshot["imageUrl"],
      listings: snapshot["listings"],
      reviews: snapshot["reviews"],
      shareCredits: snapshot["shareCredits"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "about": about,
        "email": email,
        "imageUrl": imageUrl,
        "listings": listings,
        "reviews": reviews,
        "shareCredits": shareCredits,
      };
}
