import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:euse/classes/alert.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/screens/custom_button.dart';
import 'package:euse/screens/home_screen.dart';
import 'package:euse/screens/nav_screen.dart';
import 'package:euse/services/location_service.dart';
import 'package:euse/services/sell_service.dart';
import 'package:euse/widgets/SingleTextField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/donate_model.dart';
import '../models/waste_model.dart';
import '../providers/user_provider.dart';
import '../services/donate_service.dart';
import 'address_screen.dart';

class DonatePostScreen extends StatefulWidget {
  const DonatePostScreen({super.key});

  @override
  State<DonatePostScreen> createState() => _DonatePostScreenState();
}

class _DonatePostScreenState extends State<DonatePostScreen> {


  DonateModel? dm;
  String? title, des;
  double? total = 0, amountPerUnit;
  int? numberOfUnits = 1;
  List<File> files = [];
  UserModel? um;
  File? currentImg;
  LatLng latLng = LatLng(15.2993, 74.1240);
  String address = '';
  bool isLoading = false;
  TextEditingController addressCont = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    um = Provider.of<UserPro>(context, listen: false).um;
    getLoc();
  }

  getLoc() async {
    latLng = await LocationService(context: context).getCurrentLoc();
  }

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

  calcTotal(){
    setState(() {
      total = numberOfUnits! * amountPerUnit!;
      print(total);
    });
  }

  postWaste() async {
    setState(() {
      isLoading = true;
    });
    try {
      print("Ada");
      List<String> urls = await SellService(context: context).uploadImages(files);
      // print(urls[0]);

      dm = DonateModel(title: title!,
          uid: um!.uid,
          des: des!,
          urls: urls, address: address, latlng: latLng, time: DateTime.now().millisecondsSinceEpoch.toString());

      bool res = await DonateService(context: context).postDonate(dm!);
      setState(() {
        isLoading = false;
      });
      if(res)
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavScreen()));
    }catch(e){
      setState(() {
        isLoading = false;
      });
      Alert(context, 'All fields are mandatory! $e');
      print(e);
    }
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
                Text('Donate E-Waste!', style: TextStyle(color: kGreyText, fontSize: 28),),
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
                SingleTextField(size: size, hintText: 'Add address', onChanged: (value){
                  try {
                    setState(() {
                      address = value;
                      // total = double.parse(value);
                    });
                  }catch(e){
                    print(e);
                  }
                }, icon: Icon(Icons.map_outlined), suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(child: InkWell(child: Icon(Icons.add_location_alt, color: Colors.white,), onTap: () async {
                    final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddressScreen(sourceLoc: latLng,)));
                    setState(() {
                      addressCont.text = data['location'];
                      address = addressCont.text;
                      print(data['location']);
                      latLng = data['ltlg'];
                    });
                  },), decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(12)),),
                ), controller: addressCont,),
                SizedBox(height: 8.0,),
                CustomButton(height: size.height * 0.07, text: 'DONATE', onTap: () async {
                  if(!isLoading)
                    postWaste();
                }, isLoading: isLoading, loadingWidget: CircularProgressIndicator(color: Colors.white,),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
