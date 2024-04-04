import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';

import '../constanst.dart';
import '../models/auction_model.dart';

class AuctionProductCard extends StatefulWidget {
  AuctionProductCard({required this.am, required this.height, this.width = 0, this.titleFontSize = 18, this.priceFontSize = 15});
  AuctionModel am;
  double height, width, titleFontSize, priceFontSize;
  @override
  State<AuctionProductCard> createState() => _AuctionProductCardState();
}

class _AuctionProductCardState extends State<AuctionProductCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: widget.width,
            height: widget.height,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(widget.am.urls[0],)),
                    ),
                  ),
                  // child: Image.network(
                  //   widget.am.urls[0],
                  //   fit: BoxFit.cover,
                  // ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: Text('${widget.am.title}', style: TextStyle(color: Colors.black, fontSize: widget.titleFontSize, fontWeight: FontWeight.w500),)),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        SizedBox(width: 8.0,),
                        Text('₹${widget.am.currentPrice}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: widget.priceFontSize),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
