import 'package:flutter/material.dart';

class UserModel {
  String name, token, email, id, uid, role, phone;

  UserModel({
    required this.email,
    required this.uid,
    required this.name,
    required this.token,
    required this.phone,
    required this.id,
    required this.role,
  });

}
