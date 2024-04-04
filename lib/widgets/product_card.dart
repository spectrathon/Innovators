import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';

import '../constanst.dart';

class ProductCard extends StatefulWidget {
  ProductCard({required this.wm, required this.height, this.width = 0, this.titleFontSize = 18, this.priceFontSize = 15});
  WasteModel wm;
  double height, width, titleFontSize, priceFontSize;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
                      image: DecorationImage(image: NetworkImage(widget.wm.urls[0],)),
                    ),
                  ),
                  // child: Image.network(
                  //   widget.wm.urls[0],
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
                        Expanded(child: Text('${widget.wm.title}', style: TextStyle(color: Colors.black, fontSize: widget.titleFontSize, fontWeight: FontWeight.w500),)),
                        Container(
                          height: 50,
                          width: 1,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        SizedBox(width: 8.0,),
                        Text('₹${widget.wm.total}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: widget.priceFontSize),),
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
