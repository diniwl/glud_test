import 'package:flutter/material.dart';

class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? username;
  String? status;

  UserModel({this.uid, this.email, this.fullName, this.username, this.status});

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      username: map['username'],
      status: map['status'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'username': username,
      'status': status,

    };
  }
}