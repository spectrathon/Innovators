import 'package:flutter/material.dart';

import '../constanst.dart';

class LoginTop extends StatelessWidget{
  LoginTop({
    required this.size,
    required this.text,
    this.title = 'Login',
  });

  final Size size;
  String text, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
              SizedBox(width: 4.0,),
              Icon(Icons.person_outline_outlined, size: 35,),
            ],
          ),
          Text(text, style: TextStyle(fontSize: 16, color: kGreyText),),
        ],
      ),
    );
  }
}
