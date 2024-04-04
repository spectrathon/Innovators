import 'package:euse/screens/search_screen.dart';
import 'package:flutter/material.dart';

import '../constanst.dart';

class SearchContainer extends StatefulWidget {
  SearchContainer({required this.onChanged, this.tappable = true});
  Function(String) onChanged;
  bool tappable;

  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(4.0),
      height: 50,
      decoration: BoxDecoration(color: kSearchBarBackgroundColor, borderRadius: BorderRadius.circular(12),),
      child: TextFormField(
        onTap: widget.tappable ? () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen())) : () {},
        onChanged: (value){
          widget.onChanged(value);
        },
        decoration: InputDecoration(hintText: 'Search here', prefixIcon: Icon(Icons.search, color: kGreyText,), border: InputBorder.none),
      ),
    );
  }
}
