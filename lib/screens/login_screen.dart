import 'package:euse/classes/alert.dart';
import 'package:euse/constanst.dart';
import 'package:euse/screens/nav_screen.dart';
import 'package:euse/screens/register_screen.dart';
import 'package:euse/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/SingleTextField.dart';
import '../widgets/auth_anim.dart';
import '../widgets/login_top.dart';
import 'custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isNumber = true;
  String? password;
  String? email, phone;

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
                LoginTop(size: size, text: 'Welcome back, Rounak Naik',),
                SizedBox(height: 8.0,),
                AuthAnim(height: size.height * 0.3, text: 'svgs/login.svg'),
                SizedBox(height: 12.0,),
                Text('Enter your mobile number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                SizedBox(height: 16,),
                SingleTextField(size: size, hintText: 'Enter Number/Email', onChanged: (value){
                  if(value.toString().contains('@')){
                    setState(() {
                      email = value;
                      isNumber = false;
                    });
                  }
                  else
                    setState(() {
                      phone = value;
                      isNumber = true;
                    });
                } ),
                SizedBox(height: !isNumber ? 12.0 : 0,),
                Visibility(
                  visible: !isNumber,
                  child: SingleTextField(size: size, hintText: 'Enter Password', onChanged: (value){
                    setState(() {
                      password = value;
                    });
                  }, secured: true, ),
                ),
                SizedBox(height: 8.0,),
                isNumber ? Align(child: InkWell(onTap: (){

                }, child: Text('Change Number ?', style: kSmallText,)), alignment: AlignmentDirectional.centerEnd,)
                : Align(child: InkWell(onTap: (){

                }, child: Text('Reset Password ?', style: kSmallText,)), alignment: AlignmentDirectional.centerEnd,),
                SizedBox(height: 8.0,),
                CustomButton(height: size.height * 0.06, text: 'Login', onTap: () async {
                  if(!isNumber){
                    final res = await AuthService(context: context).signIn(email, password);
                    if(res)
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NavScreen()));
                  }else{
                    Alert(context, 'Phone number sign in unavailable for now!');
                  }
                 },),
                SizedBox(height: 32.0,),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: kDividerColor,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 8,),
                      Text('Or Login with', style: kSmallText),
                      SizedBox(width: 8,),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: kDividerColor,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google.png', height: 30,),
                    SizedBox(width: 8,),
                    Text(
                      'Google', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                RichText(text: TextSpan(
                  children: [
                    TextSpan(text: 'Haven\'t registered yet ?', style: kSmallText),
                    TextSpan(text: ' Register here', style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold), recognizer: TapGestureRecognizer()..onTap = (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                    }),
                  ]
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

