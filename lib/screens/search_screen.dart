import 'package:euse/screens/view_product_screen.dart';
import 'package:euse/services/search_service.dart';
import 'package:euse/widgets/product_card.dart';
import 'package:euse/widgets/search_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constanst.dart';
import '../models/waste_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchTxt = '';
  List<WasteModel> wmList = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        wmList = await SearchService(context: context).search(searchTxt);
        setState(() {});
      }),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SearchContainer(
                onChanged: (value) async {
                  searchTxt = value;
                  wmList =
                      await SearchService(context: context).search(searchTxt.trim());
                  setState(() {});
                },
                tappable: false,
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: wmList.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: ProductCard(wm: e, height: size.height * 0.25),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewProduct(wm: e))),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
