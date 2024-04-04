import 'package:flutter/material.dart';

import '../constanst.dart';

class RegisterTop extends StatelessWidget {
  RegisterTop({
    required this.size,
    required this.text,
  });

  final Size size;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Register',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 4.0,
              ),
              Icon(
                Icons.person_outline_outlined,
                size: 35,
              ),
            ],
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Hey, Welcome ',
                style: TextStyle(
                  fontSize: 16,
                  color: kGreyText,
                ),
              ),
              text.isEmpty
                  ? TextSpan(
                      text: '!',
                      style: TextStyle(
                        fontSize: 16,
                        color: kGreyText,
                      ),
                    )
                  : TextSpan(
                      text: '${text}!',
                      style: TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}
