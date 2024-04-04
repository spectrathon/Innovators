import 'package:euse/models/donate_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';

import '../constanst.dart';

class DonateProductCard extends StatefulWidget {
  DonateProductCard({required this.dm, required this.height, this.width = 0, this.titleFontSize = 18});
  DonateModel dm;
  double height, width, titleFontSize;
  @override
  State<DonateProductCard> createState() => _DonateProductCardState();
}

class _DonateProductCardState extends State<DonateProductCard> {
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
                      image: DecorationImage(image: NetworkImage(widget.dm.urls[0],)),
                    ),
                  ),
                  // child: Image.network(
                  //   widget.dm.urls[0],
                  //   fit: BoxFit.cover,
                  // ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Align(child: Text('${widget.dm.title}', style: TextStyle(color: Colors.black, fontSize: widget.titleFontSize, fontWeight: FontWeight.w500),), alignment: AlignmentDirectional.centerStart,),
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
