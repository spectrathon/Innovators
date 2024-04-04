import 'package:flutter/material.dart';

import '../constanst.dart';

class Alert{

  BuildContext context;
  final text;
  Alert(this.context, this.text){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text'), backgroundColor: kErrorColor,),);
  }
}