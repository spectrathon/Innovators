import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../models/chat_model.dart';
import '../models/gchat_model.dart';

class GroupChatService{

  BuildContext context;
  GroupChatService({required this.context});
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future sendMsg(GChatModel gm) async {
    try{
      await firestore.collection('Group').doc('Chats').collection('Messages').doc(gm.time).set(
        {
          'name': gm.name,
          'uid': gm.uid,
          'text': gm.text,
          'time': gm.time,
        }
      );
      print('Msg SENT!');
    }catch(e){
      Alert(context, e);
    }
  }
}