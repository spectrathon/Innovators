import 'dart:convert';

import 'package:euse/classes/alert.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constanst.dart';

class UserService{

  BuildContext context;
  UserService({required this.context});
  getUser(token) async {
    try{
        String url = "$kUrl/get-user";
        http.Response res = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json", 'x-auth-token' : token});

        final data = jsonDecode(res.body);
        print(data);

        Provider.of<UserPro>(context, listen: false).setUserFromMap(data);
    }catch(e){
      Alert(context, e);
    }
  }
//flutter: {token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1MmE5OTU1OWNkZTIwNzljNzBiYzM4OCIsImlhdCI6MTY5NzI5MDU4MX0.bcGeAuf1v-wkU5_L7YkUT3LH1-O9THwQo-5utosretk, name: rounak, uid: 1697290580126, role: user, email: rairi@gmail.com, password: $2a$08$3goZQehp9as5rEuBbcwnou/EGY4nWlRWb93RNBCw5AAndJBpgfdXC, phone: , _id: 652a99559cde2079c70bc388}
}