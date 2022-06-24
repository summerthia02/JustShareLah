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
  final List<String> reviews;
  final String shareCredits;

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
    required this.reviews,
    required this.shareCredits
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
      listings: [],
      reviews: [],
      shareCredits: "Loading",
    );
  }
}
