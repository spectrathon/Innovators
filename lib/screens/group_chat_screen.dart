import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/gchat_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../services/group_chat_service.dart';
import '../widgets/group_chat_bubble.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController textController = TextEditingController();
  GChatModel? gm;
  String? uid, name;
  List<GChatModel> msgList = [];
  UserModel? um;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    um = Provider.of<UserPro>(context, listen: false).um;
    uid = um!.uid;
    name = um!.name;
    print(name);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white.withOpacity(0.8),
            )),
        title: Text(
          'Community Chat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Group').doc('Chats').collection('Messages').snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(color: kPrimaryColor,),
                        );
                      }else {
                        final msgs = snapshot.data!.docs;
                        msgList.clear();
                        for(var msg in msgs){
                          msgList.add(
                            GChatModel(name: msg['name'], uid: msg['uid'], time: msg['time'], text: msg['text'])
                          );
                        }
                        return ListView(
                          children: msgList.map((e){

                            return GroupChatBubble(text: e.text, name: e.name, time: e.time, uid: e.uid);
                          }).toList(),
                        );
                      }
                    }),
              )),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Container(
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
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
                        if (textController.text.isNotEmpty) {
                          // scrollController.animateTo(scrollController.position
                          //     .maxScrollExtent,
                          //     duration: Duration(milliseconds: 300),
                          //     curve: Curves.easeOut);
                          //sendMsg();
                          String time =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          gm = GChatModel(text: textController.text, time: time, uid: uid!, name: name!);
                          msgList.add(gm!);
                          await GroupChatService(context: context).sendMsg(gm!);
                        }
                        textController.clear();
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
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
