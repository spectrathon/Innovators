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

class ChatService{

  BuildContext context;
  ChatService({required this.context});
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future sendMsg(ChatModel cm) async {
    try{
      await firestore.collection('Users').doc(cm.senderUid).collection('Messages').doc(cm.recUid).collection('Chats').doc(cm.time).set(
        {
          'text' : cm.text,
          'time' : cm.time,
          'senderUid' : cm.senderUid,
          'recUid' : cm.recUid,
        }
      );
      await firestore.collection('Users').doc(cm.recUid).collection('Messages').doc(cm.senderUid).collection('Chats').doc(cm.time).set(
          {
            'text' : cm.text,
            'time' : cm.time,
            'senderUid' : cm.senderUid,
            'recUid' : cm.recUid,
          }
      );
      print('Msg SENT!');
    }catch(e){
      Alert(context, e);
    }
  }
}