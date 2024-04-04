import 'package:euse/screens/auction_screen.dart';
import 'package:euse/screens/view_auction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constanst.dart';
import '../models/auction_model.dart';
import '../services/auction_service.dart';
import 'custom_button.dart';

class AuctionNav extends StatefulWidget {
  const AuctionNav({super.key});

  @override
  State<AuctionNav> createState() => _AuctionNavState();
}

class _AuctionNavState extends State<AuctionNav> {
  List<AuctionModel> amList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProds();
  }

  getProds() async {
    amList = await AuctionService(context: context).getProds();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Auctions Available',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
                child: ListView(
                  children: amList.map((e) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAuctionScreen(item: e)));
                        },
                        child: Dismissible(
                          behavior: HitTestBehavior.opaque,
                          confirmDismiss: (direction) async {
                            // showDel(e);
                            // if(direction == DismissDirection.startToEnd){
                            //   await Timer(Duration(seconds: 2), () {
                            //     print('ada');
                            //   });
                            //   print('rea');
                            //   return true;
                            // }
                            return false;
                          },
                          key: GlobalKey(),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: size.height * 0.2,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              child: Image.network(e.urls[0]),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Expanded(
                                          child: Container(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.title,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                              ),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              Expanded(child: SingleChildScrollView(child: Text(e.des,))),
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                            ],
                                          ),),
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 1.0,),
                                  Divider(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  SizedBox(height: 1.0,),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Material(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: Color(0xD7D7D7E5)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Starting price: ', style: TextStyle(fontSize: 12),),
                                                    Text('\$${e.startingPrice}', style: TextStyle(fontSize: 16),),
                                                  ],
                                                ),
                                              ),
                                              elevation: 1.0,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          SizedBox(width: 8.0,),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Color(0xD7D7D7E5),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('Current price: ', style: TextStyle(fontSize: 12),),
                                                  Text('\$${e.currentPrice}', style: TextStyle(fontSize: 16, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AuctionScreen()));
        },
        child: SvgPicture.asset(
          'svgs/auction.svg',
          height: 45,
        ),
      ),
    );
  }
}
