class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String imageUrl;

  User({
    required this.uid,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
  });
}



//   factory User.fromJson(Map<String, dynamic> json) => User(
//         uid: json['uid'] ?? "",
//         userName: json['userName'] ?? "",
//         firstName: json['firstName'] ?? "",
//         lastName: json['lastName'] ?? "",
//         email: json['email'] ?? "",
//         imageUrl: json['imageUrl'] ?? "",
//       );

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'uid': uid,
//         'userName': userName,
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'imageUrl': imageUrl,
//       };
//   factory User.empty() => const User(
//         uid: "",
//         userName: "",
//         firstName: "",
//         lastName: "",
//         email: "",
//         imageUrl: "",
//       );

//   List<Object?> get props =>
//       [uid, userName, firstName, lastName, email, imageUrl];
// }
