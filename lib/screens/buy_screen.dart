import 'package:euse/constanst.dart';
import 'package:euse/screens/view_product_screen.dart';
import 'package:flutter/material.dart';

import '../models/waste_model.dart';
import '../services/sell_service.dart';
import '../widgets/product_card.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {

  bool isLoading = true;
  List<WasteModel> wmList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProds();
  }

  getProds() async {
    try {
      wmList = await SellService(context: context).getProds();
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: isLoading ? Center(
            child: CircularProgressIndicator(color: kPrimaryColor,),
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(child: Icon(Icons.arrow_back_ios_new_outlined, color: kGreyText,), onTap:(){
                          Navigator.pop(context);
                        }),
                        SizedBox(width: 8.0,),
                        Text('Available E-Waste\'s!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(height: 8.0,),
                    Text('Below are some E-Waste\'s available in your locality', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),
              Expanded(
                child: ListView(
                    children: wmList.map((e){
                      return InkWell(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: ProductCard(wm: e, height: size.height * 0.3),
                      ), onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProduct(wm: e)));
                      },);
                    }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
