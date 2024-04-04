import 'package:euse/classes/date_time_parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ChatBubble extends StatefulWidget {

  ChatBubble({required this.text, required this.senderUid, required this.time, required this.recUid});
  late String text;
  late String time;
  late String senderUid;
  late String recUid;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool isMe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String myUid = Provider.of<UserPro>(context, listen: false).um.uid;
    isMe = (widget.senderUid == myUid);
  }

  @override
  Widget build(BuildContext context) {
    try {
      widget.time = DateTimeParser(
          DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time))
              .toString()).getFormattedTime();
    }catch(e){
      widget.time = '';
    }
    return Align(
      alignment: isMe ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.only(
            topRight: isMe ? Radius.circular(0) : Radius.circular(10),
            topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, right: isMe ? 10 : 15, left: isMe ? 15 : 10),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(widget.time, style: TextStyle(fontSize: 10),),
                  SizedBox(height: 8,),
                  Text(widget.text, style: TextStyle(fontSize: 15),),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: isMe ? Colors.greenAccent : Colors.white,
              borderRadius: BorderRadius.only(
                topRight: isMe ? Radius.circular(0) : Radius.circular(10),
                topLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
