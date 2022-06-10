import 'dart:convert';

import 'package:flutter/material.dart';

/// Data model for a feed user's extra data.
@immutable
class JslUser {
  /// Data model for a feed user's extra data.
  const JslUser({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.profilePhoto,
    required this.profilePhotoResized,
    required this.profilePhotoThumbnail,
  });

  /// Converts a Map to this.
  factory JslUser.fromMap(Map<String, dynamic> map) {
    return JslUser(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      userName: map['full_name'] as String,
      profilePhoto: map['profile_photo'] as String?,
      profilePhotoResized: map['profile_photo_resized'] as String?,
      profilePhotoThumbnail: map['profile_photo_thumbnail'] as String?,
    );
  }

  /// Converts json to this.
  factory JslUser.fromJson(String source) =>
      JslUser.fromMap(json.decode(source) as Map<String, dynamic>);

  /// User's first name
  final String firstName;

  /// User's last name
  final String lastName;

  /// User's userName
  final String userName;

  /// URL to user's profile photo.
  final String? profilePhoto;

  /// A 500x500 version of the [profilePhoto].
  final String? profilePhotoResized;

  /// A small thumbnail version of the [profilePhoto].
  final String? profilePhotoThumbnail;

  /// Convenient method to replace certain fields.
  JslUser copyWith({
    String? firstName,
    String? lastName,
    String? userName,
    String? profilePhoto,
    String? profilePhotoResized,
    String? profilePhotoThumbnail,
  }) {
    return JslUser(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      profilePhotoResized: profilePhotoResized ?? this.profilePhotoResized,
      profilePhotoThumbnail:
          profilePhotoThumbnail ?? this.profilePhotoThumbnail,
    );
  }

  /// Converts this model to a Map.
  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'profile_photo': profilePhoto,
      'profile_photo_resized': profilePhotoResized,
      'profile_photo_thumbnail': profilePhotoThumbnail,
    };
  }

  /// Converts this class to json.
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''UserData(firstName: $firstName, lastName: $lastName, userName: $userName, profilePhoto: $profilePhoto, profilePhotoResized: $profilePhotoResized, profilePhotoThumbnail: $profilePhotoThumbnail)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is JslUser &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.userName == userName &&
        other.profilePhoto == profilePhoto &&
        other.profilePhotoResized == profilePhotoResized &&
        other.profilePhotoThumbnail == profilePhotoThumbnail;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        userName.hashCode ^
        profilePhoto.hashCode ^
        profilePhotoResized.hashCode ^
        profilePhotoThumbnail.hashCode;
  }
}
