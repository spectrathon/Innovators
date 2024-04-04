import 'dart:async';
import 'dart:convert';

import 'package:euse/screens/login_screen.dart';
import 'package:euse/screens/register_top.dart';
import 'package:euse/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constanst.dart';
import '../widgets/SingleTextField.dart';
import '../widgets/auth_anim.dart';
import '../widgets/login_top.dart';
import 'custom_button.dart';
import 'nav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  String regText = '';
  bool passVis = true;
  String? password, email;
  String phone = '', name = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RegisterTop(size: size, text: '$name',),
                SizedBox(height: 8.0,),
                AuthAnim(height: size.height * 0.25, text: 'svgs/register.svg'),
                SizedBox(height: 12.0,),
                Text('Enter your details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 16,),
                SingleTextField(size: size, hintText: 'Enter Name', onChanged: (value){
                  setState(() {
                    name = value;
                  });
                }, icon: Icon(Icons.person, color: kGreyText,),),
                SizedBox(height: 12.0,),
                SingleTextField(size: size, hintText: 'Enter Email', onChanged: (value){
                    email = value;
                }, icon: Icon(Icons.email, color: kGreyText,),),
                SizedBox(height: 12.0,),
                SingleTextField(size: size, hintText: 'Enter Password', onChanged: (value){
                  password = value;
                }, icon: Icon(Icons.password, color: kGreyText,), suffixIcon: InkWell(child: Icon(!passVis ? Icons.lock_open_rounded : Icons.lock_outline), onTap: (){
                  setState(() {
                    passVis = !passVis;
                  });
                },), secured: passVis),
                SizedBox(height: 24.0,),
                CustomButton(height: size.height * 0.06, text: 'Register', onTap: () async {
                  final res = await AuthService(context: context).signUp(name, email, password, phone);
                  if(res)
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NavScreen()));
                  },),
                SizedBox(height: 32,),
                RichText(text: TextSpan(
                    children: [
                      TextSpan(text: 'Have an account ?', style: kSmallText),
                      TextSpan(text: ' Login here', style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()..onTap = (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      }),
                    ],
                )),
                SizedBox(height: 24,),
                Text('@EUSE', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
