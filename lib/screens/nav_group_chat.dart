import 'package:euse/constanst.dart';
import 'package:euse/screens/bot_screen.dart';
import 'package:euse/screens/donate_post_screen.dart';
import 'package:euse/screens/equiz_screen.dart';
import 'package:euse/screens/group_chat_screen.dart';
import 'package:euse/screens/sell_screen.dart';
import 'package:euse/screens/view_cart_screen.dart';
import 'package:euse/screens/view_donate_screen.dart';
import 'package:flutter/material.dart';

class NavGroupChat extends StatefulWidget {
  NavGroupChat({super.key});

  @override
  State<NavGroupChat> createState() => _NavGroupChatState();
}

class _NavGroupChatState extends State<NavGroupChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupChatScreen()));
                },
                child: Card(
                    child: ListTile(
                  leading: Icon(Icons.groups_rounded),
                  title: Text('Chat'),
                  subtitle: Text('Welcome to our community!'),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: kGreyText,
                  ),
                )),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellScreen()));
                },
                child: Card(
                    child: ListTile(
                      leading: Icon(Icons.sell),
                      title: Text(
                          'Sell E-Waste'
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: kGreyText,
                      ),
                      subtitle: Text('Sell your E-Waste'),
                    ),),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DonatePostScreen()));
                },
                child: Card(
                    child: ListTile(
                      leading: Icon(Icons.handshake),
                      title: Text(
                          'Donate E-Waste'
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: kGreyText,
                      ),
                      subtitle: Text('Donate your E-Waste'),
                    )),
              ),
              //Provides a platform for Selling, Donating and Auctioning E-Waste. It motivates users to buy/sell E-Waste.
              //Educates users about the growing Waste Management problems.
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EQuizScreen()));
                },
                child: Card(
                  child: ListTile(
                    leading: Image.asset('assets/quiz.png', height: 24, width: 24,),
                    title: Text(
                        'E-Quiz'
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: kGreyText,
                    ),
                    subtitle: Text('Learn and earn rewards!'),
                  ),),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BotScreen()));
                },
                child: Card(
                  child: ListTile(
                    leading: Image.asset('assets/robot.png', height: 24, width: 24,),
                    title: Text(
                        'E-Bot'
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: kGreyText,
                    ),
                    subtitle: Text('Out AI bot is here to help!'),
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
