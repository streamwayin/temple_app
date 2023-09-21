import 'dart:convert';

class UserModel {
  String name;
  String uid;
  String email;
  String phoneNo;
  UserModel({
    this.name = '',
    this.uid = '',
    this.email = '',
    this.phoneNo = '',
  });

  UserModel copyWith({
    String? name,
    String? uid,
    String? email,
    String? phoneNo,
  }) {
    return UserModel(
        name: name ?? this.name,
        uid: uid ?? this.uid,
        email: email ?? this.email,
        phoneNo: phoneNo ?? this.phoneNo);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'phoneNo': phoneNo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      phoneNo: map['phoneNo']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
