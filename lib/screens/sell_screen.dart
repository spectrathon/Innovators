import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/waste_model.dart';
import '../providers/user_provider.dart';
import 'address_screen.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {

  WasteModel? wm;
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
  String jsonName = '';
  String jsonDes = '';
  double jsonPrice = 0.0;
  double jsonTotalPrice = 0.0;
  int jsonUnit = 0;
  bool aiLoading = false;

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

  // pickImages() async {
  //   final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if(xfile != null){
  //
  //    getImageData(xfile);
  //   }
  // }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List uint8list = await file.readAsBytes();
    return uint8list;
  }

  Future<String?> getImageData(List<Uint8List> uList) async {
    final gemini = Gemini.instance;

    try {

      final can = await gemini.textAndImage(text:
"""
Pretend to be an E-Waste Specialist.
Detect the e-waste item shown in the image
and write a detailed product description to be sold on an e-waste selling website.

YOU MUST return a json string having the following data:

1. name - Name of the product/e-waste
2. description - specifications of the product/e-waste (Example: color, brand name, status of product etc)
3. Price - Predict the price of the E-waste in Indian Market and give the answer (Predict in INR)
4. Unit - Count the number of that particular item in the image.
5. totalPrice will be unit * price

ONLY RETURN A JSON STRING at the end
NO OTHER CHARACTERS OR TOKENS, ONLY A JSON STRING

The JSON object template is given below:


{
"name": 'Keyboard,
"description": "It is a black keyboard of ABC Company.",
"price": "35",
"unit": 2,
"totalPrice": "70"
}


I REPEAT, ONLY RETURN A JSON STRING NO OTHER CHARACTERS OR TOKENS THE RESPONSE, RESPOND IN THE FORMAT OF THE TEMPLATE GIVEN
""",
          images: uList);
      String result = can!.content!.parts!.first.text ?? '';
      print(result);

      return result;
    }catch(e){
      print('Exception: $e');

      return null;
    }
  }

  pickImages() async {
    List<Uint8List> uList = [];
    List<XFile> xFiles = await ImagePicker().pickMultiImage();
    setState(() {
      aiLoading = true;
    });
    if(xFiles != null){
      for(var file in xFiles){
        setState(() {
          files.add(File(file.path));
        });
      }
      setState(() {
        currentImg = files[0];
      });
      for(var file in xFiles){
        uList.add(await fileToUint8List(File(file.path)));
        setState(() {
        });
      }
      Map data;
      String? res = await getImageData(uList);
      try {
        print(res!.trim());
        data = json.decode(res.trim());
      }catch(e) {
        print('json parse error $e');
        List list = res!.split('json');
        String fin = list.last.split('`').first;
        data = jsonDecode(fin.trim());
        print('REVISED DATA: \n$data');
        // data = {
        //   "name": "Extension Cord",
        //   "description": "It is a white extension cord of Anchor Company.",
        //   "price": "150",
        //   "unit": 1,
        //   "totalPrice": "150",
        // };
      }

      try {
        setState(() {
          jsonTotalPrice = double.parse(data['totalPrice']);
          jsonName = data['name'];
          jsonDes = data['description'];
          jsonPrice = double.parse(data['price']);
          jsonUnit = data['unit'];
          print(jsonTotalPrice);
        });
      }catch(e){
        print('asd $e');
      }
      setState(() {
        aiLoading = false;
      });
    }else{
      setState(() {
        aiLoading = false;
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
    // try {
    print('reache2d');
    List<String> urls = await SellService(context: context).uploadImages(files);
    print(urls[0]);
    print('reache2d3');

    print(titleController.text);
    print(um!.uid);
    print(ammPerUnitController.text);
    print(desController.text);
      wm = WasteModel(title: titleController.text,
          uid: um!.uid,
          amountPerUnit: double.parse(ammPerUnitController.text),
          des: desController.text,
          numberOfUnits: numberOfUnits!,
          total: double.parse(totalPriceController.text),
          urls: urls,
          address: address,
          latlng: latLng);
    try {

      print(wm!.latlng);
      print(wm!.title);
      print(wm!.uid);
      print(wm!.des);
      print(wm!.numberOfUnits);
      print(wm!.total);
      print(wm!.address);
      print(wm!.urls[0]);
    }catch(e){
      print(e);
    }
    bool res = await SellService(context: context).postWaste(wm!);
    setState(() {
      isLoading = false;
    });
    if (res)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavScreen()));
      // }catch(e){
      setState(() {
        isLoading = false;
      });
      // Alert(context, 'All fields are mandatory! $e');
      // print(e);
    // }
  }

  TextEditingController totalPriceController = TextEditingController();
  TextEditingController ammPerUnitController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController titleController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // totalPriceController.dispose();
    // titleController.dispose();
    // desController.dispose();
    // titleController.dispose();
    // ammPerUnitController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: aiLoading ? Center(
        child: LottieBuilder.asset('anim/recycle.json', height: size.height * 0.3,),
      ) : SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sell E-Waste!', style: TextStyle(color: kGreyText, fontSize: 28),),
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
                jsonName.isEmpty ? Container() : InkWell(child: Chip(label: Text('Generate using AI'), avatar: Icon(Icons.star, color: kPrimaryColor,),), onTap: (){
                  setState(() {
                    titleController.text = jsonName;
                    title = titleController.text;
                    desController.text = jsonDes;
                    des = desController.text;
                    totalPriceController.text = jsonTotalPrice.toString();
                    total = jsonTotalPrice;
                    ammPerUnitController.text = jsonPrice.toString();
                    amountPerUnit = jsonPrice;
                    unitController.text = jsonUnit.toString();
                    numberOfUnits = jsonUnit;
                  });
                }, ),
                SizedBox(height: 16,),
                SingleTextField(size: size, hintText: 'Title', onChanged: (value){
                  setState(() {
                    title = value;
                    titleController.text = value;
                  });
                }, icon: Icon(Icons.title), value: title ?? '', controller: titleController,),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Description about the E-waste', onChanged: (value){
                  setState(() {
                    des = value;
                    desController.text = value;
                  });
                }, icon: Icon(Icons.text_snippet_outlined), value: des ?? '', controller: desController,),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Number of units ?', onChanged: (value){
                  try {
                    setState(() {
                      numberOfUnits = int.parse(value);
                      unitController.text = numberOfUnits.toString();
                      calcTotal();
                    });
                  }catch(e){
                    print('ersdror: $e');
                  }
                }, icon: Icon(Icons.format_list_numbered), type: TextInputType.number, value: (numberOfUnits.toString() == 'null') ? '' : numberOfUnits.toString(), controller: unitController,),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Amount per unit', onChanged: (value){
                  try {
                    setState(() {
                      amountPerUnit = double.parse(value);
                      ammPerUnitController.text = value;
                      calcTotal();
                    });
                  }catch(e){
                    print('error: $e');
                  }
                }, icon: Icon(Icons.price_check), type: TextInputType.number, value:  (amountPerUnit.toString() == 'null') ? '' : amountPerUnit.toString(), controller: ammPerUnitController,),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Total Amount', onChanged: (value){
                  try {
                    setState(() {
                      total = double.parse(value);
                      totalPriceController.text = total.toString();
                    });
                  }catch(e){
                    print('error:as $e');
                  }
                }, icon: Icon(Icons.money), type: TextInputType.number, controller: totalPriceController,),
                SizedBox(height: 8,),
                SingleTextField(size: size, hintText: 'Add address', onChanged: (value){
                  try {
                    setState(() {
                      address = value;
                      // total = double.parse(value);
                    });
                  }catch(e){
                    print('adsd $e');
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
                CustomButton(height: size.height * 0.07, text: 'SELL', onTap: () async {
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
