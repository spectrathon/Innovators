import 'dart:async';

import 'package:euse/screens/login_screen.dart';
import 'package:euse/screens/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  changeScreen() async {
    Timer(Duration(seconds: 2), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = await pref.getString('token');
      if(token == null)
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      else
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
