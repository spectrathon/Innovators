import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:euse/classes/alert.dart';
import 'package:euse/models/auction_model.dart';
import 'package:euse/models/bid_model.dart';
import 'package:euse/services/auction_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../constanst.dart';
import '../models/user_model.dart';
import '../models/waste_model.dart';
import '../providers/user_provider.dart';
import '../services/sell_service.dart';
import '../widgets/SingleTextField.dart';
import 'address_screen.dart';
import 'custom_button.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {

  WasteModel? wm;
  String? title, des;
  double? total = 0.0, amountPerUnit;
  int? numberOfUnits = 1, startingPrice = 0;
  List<File> files = [];
  List<AuctionModel> amList = [];
  UserModel? um;
  File? currentImg;
  LatLng latLng = LatLng(15.2993, 74.1240);
  String address = '';
  bool isLoading = false;
  TextEditingController addressCont = TextEditingController();

  pickImages() async {
    List<XFile> xFiles = await ImagePicker().pickMultiImage();
    if(xFiles != null){
      for(var file in xFiles){
        setState(() {
          files.add(File(file.path));
        });
      }
      setState(() {
        currentImg = files[0];
      });
    }
  }

  auctionWaste() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<String> urls = await AuctionService(context: context).uploadImages(
          files);
      AuctionModel am = AuctionModel(title: title!,
          uid: um!.uid,
          startingPrice: startingPrice!,
          des: des!,
          numberOfUnits: numberOfUnits!,
          currentPrice: startingPrice!,
          urls: urls,
          bidList: [

          ], aid: DateTime.now().millisecondsSinceEpoch.toString());

      await AuctionService(context: context).postAuction(am);
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }catch(e){
      Alert(context, e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    um = Provider.of<UserPro>(context, listen: false).um;
    getProds();
    super.initState();
  }

  getProds() async {
    amList = await AuctionService(context: context).getProds();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Auction your E-Waste!', style: TextStyle(color: kGreyText, fontSize: 28),),
                SizedBox(height: 16,),
                files.isEmpty ? InkWell(
                  onTap: (){
                    pickImages();
                  },
                  child: Container(
                    height: size.height * 0.35,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(12),),
                  ),
                ) : Container(
                  height: size.height * 0.35,
                  child: CarouselSlider(items: files.map((e){

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: currentImg == e ? 0 : 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(),
                          child: Image.file(e, fit: BoxFit.cover,),
                        ),
                      ),
                    );
                  }).toList(), options: CarouselOptions(
                    onPageChanged: (value, reason){
                      print(value);
                      setState(() {
                        currentImg = files[value];
                      });
                    },
                    viewportFraction: 0.55,
                  )),
                ),
                SizedBox(height: 16,),
                SingleTextField(size: size, hintText: 'Title', onChanged: (value){
                  setState(() {
                    title = value;
                  });
                }, icon: Icon(Icons.title), value: title ?? '',),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Description about the E-waste', onChanged: (value){
                  setState(() {
                    des = value;
                  });
                }, icon: Icon(Icons.text_snippet_outlined), value: des ?? '',),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Number of units ?', onChanged: (value){
                  try {
                    setState(() {
                      numberOfUnits = int.parse(value);
                      // calcTotal();
                    });
                  }catch(e){
                    print(e);
                  }
                }, icon: Icon(Icons.format_list_numbered), type: TextInputType.number, value: (numberOfUnits.toString() == 'null') ? '' : numberOfUnits.toString(),),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Starting price', onChanged: (value){
                  try {
                    setState(() {
                      startingPrice = int.parse(value);
                    });
                  }catch(e){
                    print(e);
                  }
                }, icon: Icon(Icons.price_check), type: TextInputType.number, value:  (amountPerUnit.toString() == 'null') ? '' : amountPerUnit.toString()),
                SizedBox(height: 8,),
                CustomButton(height: size.height * 0.07, text: 'AUCTION', onTap: () async {
                  print(startingPrice);
                  if(!isLoading)
                    auctionWaste();
                }, isLoading: isLoading, loadingWidget: CircularProgressIndicator(color: Colors.white,),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
