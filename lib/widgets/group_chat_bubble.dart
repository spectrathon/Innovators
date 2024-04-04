import 'package:euse/classes/date_time_parser.dart';
import 'package:euse/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class GroupChatBubble extends StatefulWidget {

  GroupChatBubble({required this.text, required this.name, required this.time, required this.uid});
  late String text;
  late String time;
  late String name;
  late String uid;

  @override
  State<GroupChatBubble> createState() => _GroupChatBubbleState();
}

class _GroupChatBubbleState extends State<GroupChatBubble> {
  bool isMe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserModel um = Provider.of<UserPro>(context, listen: false).um;
    String myUid = um.uid;
    print(um.name);
    isMe = (widget.uid == myUid);
  }

  @override
  Widget build(BuildContext context) {
    String time = DateTimeParser(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.time)).toString()).getFormattedTime();
    widget.time = time;
    return Align(
      alignment: isMe ? AlignmentDirectional.topEnd : AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 2,
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.name, style: TextStyle(fontSize: 10),),
                      SizedBox(width: 8.0,),
                      Text(widget.time, style: TextStyle(fontSize: 10),),
                    ],
                  ),
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
