import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../models/chat_model.dart';
import '../models/user_model.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {

  @override
  State<ChatScreen> createState() => _ChatScreenState();

  ChatScreen({required this.um, required this.wm});
  UserModel um;
  WasteModel wm;

}

class _ChatScreenState extends State<ChatScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  String msg  = '', senderUid = '', recUid = '';
  ChatModel? cm;
  List<ChatModel> msgList = [];

  @override
  void initState() {
    // TODO: implement initState
    recUid = widget.wm.uid;
    senderUid = widget.um.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kSearchBarBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSearchBarBackgroundColor,
        title: Text(widget.um.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("Users").doc(widget.um.uid).collection("Messages").doc(recUid).collection("Chats").snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.hasData){
                    var msgs = snapshot.data?.docs;

                    List<ChatBubble> texts = [];
                    for(var msg in msgs!){
                      // cm = ChatModel(msg["text"], msg["time"], msg["isMe"], msg["senderUid"], msg["myUid"]);
                      texts.add(ChatBubble(text: msg["text"], senderUid: msg["senderUid"], time: msg["time"], recUid: msg['recUid'],));
                    }

                    return Expanded(
                      flex: 10,
                      child: ListView.builder(
                        // controller: scrollController,
                        itemCount: texts.length + 1,
                        itemBuilder: (context, index){
                          if(index == texts.length){
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                            );
                          }
                          else{
                            return texts[index];
                          }
                        },
                      ),
                    );
                  }
                  else{
                    return Text("");
                  }

                },
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
                          cm = ChatModel(text: msg, time: time, recUid: recUid, senderUid: senderUid);
                          msgList.add(cm!);
                          await ChatService(context: context).sendMsg(cm!);
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
