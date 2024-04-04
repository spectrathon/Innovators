import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthAnim extends StatelessWidget {
  AuthAnim({
    required this.height,
    required this.text
  });

  double height;
  String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height,
      child: SvgPicture.asset(text,),
    );
  }
}