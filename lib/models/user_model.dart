// class UserModel {
//   UserModel({
//     required this.uid,
//     required this.userName,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.imageUrl,
//   });

//   String uid;
//   String userName;
//   String firstName;
//   String lastName;
//   String email;
//   String imageUrl;

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
//   factory UserModel.empty() => const UserModel(
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
