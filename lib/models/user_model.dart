class UserModel {
  String? uid;
  String? email;
  String? userName;
  String? firstName;
  String? lastName;

  UserModel(
      {this.uid, this.email, this.userName, this.firstName, this.lastName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
