import 'dart:typed_data';

class User {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String telephone;
  final String profileImage;
  Uint8List? profileImageByte;
  final String address;
  final String city;
  final String province;
  final String country;

  User({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    required this.profileImage,
    this.profileImageByte,
    required this.address,
    required this.city,
    required this.province,
    required this.country,
  });
}
