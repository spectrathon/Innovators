import 'package:flutter/material.dart';

import '../constanst.dart';

class CustomCard extends StatefulWidget {
  CustomCard();

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(right: 16.0),
      height: size.height * 0.18,
      width: size.width * 0.4,
      decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
    );
  }
}
