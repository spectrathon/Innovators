import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/services/bot_service.dart';
import 'package:euse/widgets/chat_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../constanst.dart';
import '../models/chat_model.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {


  TextEditingController textController =TextEditingController();
  String msg = '';
  ChatModel? cm;
  List<ChatModel> msgList = [];
  String senderUid = '';
  late Timer timer;
  bool loading = true;

  getAns(msg) async {
    String text = await BotService(context: context).prompt(msg);
    msgList.add(ChatModel(text: text, time: '0', recUid: 'recUid', senderUid: 'bot'));
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  
  startTimer() async {
    timer = Timer(Duration(seconds: 2), () { 
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    senderUid = Provider.of<UserPro>(context).um.uid;

    return Scaffold(
      backgroundColor: kSearchBarBackgroundColor,
      appBar: loading ? null : AppBar(
        backgroundColor: kSearchBarBackgroundColor,
        title: Text('E-Bot'),
        actions: [
          Hero(child: LottieBuilder.asset('anim/robot_anim2.json', height: 80, width: 80,), tag: 'tag',),
          SizedBox(width: 10,)
        ],
      ),
      body: loading ? Center(
        child: Hero(child: LottieBuilder.asset('anim/robot_anim2.json'), tag: 'tag',),
      ) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: ListView(
                  children: msgList.map((e){

                    return ChatBubble(text: e.text, senderUid: e.senderUid, time: '0', recUid: e.recUid);
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8,),
                        child: Container(
                          child: TextField(
                            controller: textController,
                            onChanged: (value){
                              setState(() {
                                msg = value;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              hintText: 'Type your message here...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () async {
                        if(msg.isNotEmpty) {
                          // scrollController.animateTo(scrollController.position
                          //     .maxScrollExtent,
                          //     duration: Duration(milliseconds: 300),
                          //     curve: Curves.easeOut);
                          //sendMsg();
                          setState(() {
                            textController.clear();
                          });
                          String time = DateTime.now().millisecondsSinceEpoch.toString();
                          cm = ChatModel(text: msg, time: '0', recUid: 'recUid', senderUid: senderUid);
                          msgList.add(cm!);
                          getAns(msg);
                          // await ChatService(context: context).sendMsg(cm!);
                          setState(() {
                            msg = '';
                          });
                        }
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 10, offset: Offset(0, 5), spreadRadius: 0, color: kGreyText)]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.send, color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
