import 'dart:convert';

import 'package:euse/classes/alert.dart';
import 'package:euse/classes/map_to_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constanst.dart';
import '../models/cart_model.dart';

class BotService{

  BuildContext context;
  BotService({required this.context});

  Future prompt(String msg) async {
    print('reached');
    try {
      String url = "$kUrl/prompt";
      http.Response res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {
                'msg' : msg,
              }));
      print(jsonDecode(res.body));
      if(res.statusCode == 200)
        return jsonDecode(res.body);
      return 'No Answer';
    } catch (e) {
      Alert(context, e);
      return 'No Answer';
    }
  }

}