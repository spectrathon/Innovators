import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../constanst.dart';

class CarouselCard extends StatefulWidget {
   CarouselCard({required this.items});
   List<Widget> items;

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CarouselSlider(items: widget.items, options: CarouselOptions(
            viewportFraction: 1
        )),
      ),
      height: size.height * 0.2,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
