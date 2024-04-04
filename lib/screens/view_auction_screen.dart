import 'dart:io';

import 'package:euse/models/auction_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/widgets/carousel_card.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

import '../constanst.dart';
import '../models/bid_model.dart';
import '../providers/user_provider.dart';
import 'custom_button.dart';

class ViewAuctionScreen extends StatefulWidget {

  ViewAuctionScreen({required this.item});
  AuctionModel item;

  @override
  State<ViewAuctionScreen> createState() => _ViewAuctionScreenState();
}

class _ViewAuctionScreenState extends State<ViewAuctionScreen> {

  UserModel? um;
  int total = 0;
  List<BidModel> bidList =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    um = Provider.of<UserPro>(context, listen: false).um;
    total = widget.item.currentPrice;
    widget.item.bidList.forEach((e) {
      bidList.add(BidModel(uid: e.uid, bidPrice: e.bidPrice, name: e.name));
    });
    // bidList = bidList.reversed.toList();
    connect();
  }
  IO.Socket? socket;

  connect(){

      socket = IO.io(kUrl, <String, dynamic>{
        "transports" : ['websocket'],
        'autoConnect' : false
      });

    socket!.connect();
    socket!.onConnect((_){
      print('Frontend connnected!');
      socket!.emit("auction", widget.item.aid);
      socket!.on("getBid", (data){
        print("data : ${data}");
        // if(!mounted){
          setState(() {
            bidList.add(BidModel(uid: data['uid'], bidPrice: data['bidPrice'], name: data['name']));
            widget.item.currentPrice += 100;
            print("CURRENT PRICE: ${widget.item.currentPrice}");
            total += 100;
          });
        // }
        // else{
        //   widget.item.currentPrice += 100;
        //   bidList.add(BidModel(uid: um!.uid, bidPrice: total+100, name: um!.name));
        //   total += 100;
        // }
      });
    });
  }

  sendData(){
    socket!.emit('bid', {
      'name': um!.name,
      'uid': um!.uid,
      'bidPrice': total + 100,
    });
  }

  @override
  void dispose() {
    // _timer.cancel();
    socket!.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Set<BidModel> set = bidList.toSet();
    // bidList = set.toList();
    bidList = bidList.toSet().toList();
    bidList.sort((a, b) {

      return b.bidPrice.compareTo(a.bidPrice);
    });

    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(child: Icon(Icons.arrow_back_ios_new_outlined), onTap: (){
                Navigator.pop(context);
              },),
              SizedBox(height: 8.0,),
              Expanded(
                flex: 2,
                child: CarouselCard(items: widget.item.urls.map((e){
                  return Image.network(e);
                }).toList()),
              ),
              SizedBox(
                width: 8.0,
              ),
              SizedBox(height: 8.0,),
              Text(
                widget.item.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(widget.item.des,),
              SizedBox(
                height: 4.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              SizedBox(height: 1.0,),
              Divider(
                color: Colors.black,
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
                                Text('Starting price: '),
                                SizedBox(height: 8.0,),
                                Text('\$${widget.item.startingPrice}', style: TextStyle(fontSize: 24),),
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
                              Text('Current price: '),
                              SizedBox(height: 8.0,),
                              Text('\$${widget.item.currentPrice}', style: TextStyle(fontSize: 24, color: kPrimaryColor, fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0,),
              Expanded(
                flex: 2,
                child: ListView(
                  shrinkWrap: true,
                  children: bidList.map((e){

                    return Card(
                      child: ListTile(
                        title: Text('Last bid: '),
                        subtitle: Text('\$${e.bidPrice} (${e.name})', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 8.0,),
              CustomButton(text: 'BID \$${total+100}', onTap: (){
                sendData();
              }),
            ],
          ),
        ),
      ),
    );
  }
}