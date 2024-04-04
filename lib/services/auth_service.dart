import 'dart:convert';

import 'package:euse/classes/alert.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constanst.dart';
class AuthService{

  BuildContext context;
  AuthService({required this.context});

  Future<bool> signUp(name, email, password, phone) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    try{
      String url = "$kUrl/sign-up";
      http.Response res = await http.post(Uri.parse(url), body: jsonEncode({
        "email": email,
        "password" : password,
        "name" : name,
        "uid" : uid,
        "phone": phone
      }), headers: {"Content-Type": "application/json"});

      final data = jsonDecode(res.body);
      print(data);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('name', data['name']);
      await pref.setString('email', data['email']);
      await pref.setString('token', data['token']);
      await pref.setString('role', data['role']);
      await pref.setString('phone', data['phone']);
      await pref.setString('uid', data['uid']);
      await pref.setString('id', data['_id']);
      Provider.of<UserPro>(context, listen: false).setUserFromMap(data);

      if(res.statusCode == 200)
        return true;
      else{
        Alert(context, jsonDecode(res.body));
        return false;
      }
    }catch(e){
      Alert(context, e);
      return false;
    }
  }

  Future<bool> signIn(email, password) async {
    String uid = DateTime.now().millisecondsSinceEpoch.toString();
    try{
      String url = "$kUrl/sign-in";
      http.Response res = await http.post(Uri.parse(url), body: jsonEncode({
        "email": email,
        "password" : password,
      }), headers: {"Content-Type": "application/json"});

      final data = jsonDecode(res.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('name', data['name']);
      await pref.setString('email', data['email']);
      await pref.setString('role', data['role']);
      await pref.setString('phone', data['phone']);
      await pref.setString('uid', data['uid']);
      await pref.setString('id', data['_id']);
      print(jsonDecode(res.body));
      SharedPreferences pref2 = await SharedPreferences.getInstance();
      data['token'] = await pref2.getString('token') ?? '';
      Provider.of<UserPro>(context, listen: false).setUserFromMap(data);

      if(res.statusCode == 200)
        return true;
      else{
        Alert(context, jsonDecode(res.body));
        return false;
      }

    }catch(e){
      Alert(context, e);
      return false;
    }
  }

}