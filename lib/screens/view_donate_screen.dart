import 'package:euse/constanst.dart';
import 'package:euse/screens/view_product_screen.dart';
import 'package:euse/services/donate_service.dart';
import 'package:euse/widgets/donate_product_card.dart';
import 'package:flutter/material.dart';

import '../models/donate_model.dart';
import '../models/waste_model.dart';
import '../services/sell_service.dart';
import '../widgets/product_card.dart';

class  ViewDonateScreen extends StatefulWidget {
  const ViewDonateScreen({super.key});

  @override
  State<ViewDonateScreen> createState() => _ViewDonateScreenState();
}

class _ViewDonateScreenState extends State<ViewDonateScreen> {

  bool isLoading = true;
  List<DonateModel> dmList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProds();
  }

  getProds() async {
    try {
      dmList = await DonateService(context: context).getDonateProds();
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
                        Text('Donated E-Waste\'s!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(height: 8.0,),
                    Text('Below are some Donated E-Waste\'s available in your locality', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),
              Expanded(
                child: ListView(
                    children: dmList.map((e){
                      return InkWell(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: DonateProductCard(dm: e, height: size.height * 0.3),
                      ), onTap: (){

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProduct(wm: e)));
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
