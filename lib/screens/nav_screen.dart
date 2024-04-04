import 'package:euse/constanst.dart';
import 'package:euse/screens/account_screen.dart';
import 'package:euse/screens/auction_nav.dart';
import 'package:euse/screens/nav_group_chat.dart';
import 'package:euse/screens/home_screen.dart';
import 'package:euse/screens/map_screen.dart';
import 'package:euse/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavScreen extends StatefulWidget {
  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int currentIndex = 0;
  List<Widget> screens = [];

  @override
  void initState() {
    // TODO: implement initState
    screens = [
      HomeScreen(),
      MapScreen(),
      AuctionNav(),
      NavGroupChat(),
      AccountScreen(),
    ];

    getUser();
    super.initState();
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = await pref.getString('token');
    await UserService(context: context).getUser(token);
    // UserModel um = await
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
             Icons.home_filled,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance,
            ),
            label: 'Auction',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups_rounded,
            ),
            label: 'More',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Account',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (value){
          setState(() {
            currentIndex = value;
          });},
      ),
    );
  }
}
