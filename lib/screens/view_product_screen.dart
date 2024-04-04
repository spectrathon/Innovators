import 'package:carousel_slider/carousel_slider.dart';
import 'package:euse/classes/alert.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/cart_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/screens/cart_screen.dart';
import 'package:euse/screens/chat_screen.dart';
import 'package:euse/services/bot_service.dart';
import 'package:euse/services/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class ViewProduct extends StatefulWidget {
  ViewProduct({required this.wm});
  WasteModel wm;

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  late String currentImg;
  CarouselController carouselController = CarouselController();
  MapController mapController = MapController();
  bool addedToCart = false;
  UserModel? um;
  String msg = '';
  bool impactLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentImg = widget.wm.urls[0];
    um = Provider.of<UserPro>(context, listen: false).um;
    print(widget.wm.latlng!.longitude);
    checkCart();
    getImpact();
  }

  getImpact() async {
    // String prompt = '''
    // What positive impact will I make if I recycle/reuse ${widget.wm.numberOfUnits} ${widget.wm.title}. Tell me in numbers.
    // Answer should be under 30-40 words with bullet points.
    // Tell in future tense. Also add a small motivating one line at the end.
    // ''';
    String prompt = '''
    What are my benefits of buying only ${widget.wm.numberOfUnits} ${widget.wm.title} as E-Waste as an Individual person. Tell me in numbers. 
    What are the rare earth metals present in that particular E-waste and the quantity in gram of them in that E-WASTE and the price for that rare metal in brackets in INR.
    Tell in future tense. Also add a small motivating one line at the end to motivate me to buy that E-Waste.
    Please AVOID SPECIAL CHARACTERS OR TOKENS like **. 
    
    The response should be in the format provide below:
    Benefits of Buying 2 keyboards as E-Waste:
    1. Environmental Impact: 2-3 points
    2. Resources Recovery/rare earth metals present in 2 Keyboard: 2-3 points
    3. Motivation line
    
    Please AVOID SPECIAL CHARACTERS OR TOKENS like **.
    Special Characters like ** should not be present in the response.
    The final response should be WELL FORMATTED
    The final response should NOT container this chracter - **
    ''';
    String text = await BotService(context: context).prompt(prompt);
    setState(() {
      msg = text;
      impactLoading = false;
    });
  }

  checkCart() async {
    addedToCart = await CartService(context: context).prodExistsInCart(um!.uid, widget.wm.title, widget.wm.des);
    setState(() {
      addedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(wm: widget.wm, um: um!,)));
        },
        child: Icon(Icons.chat, color: Colors.white,),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      // floatingActionButton: !addedToCart ? FloatingActionButton(
      //   onPressed: () async{
      //   setState(() {
      //     addedToCart = true;
      //   });
      //   await CartService(context: context).addToCart(
      //       CartModel(title: widget.wm.title, uid: widget.wm.uid, amountPerUnit: widget.wm.amountPerUnit, des: widget.wm.des, numberOfUnits: widget.wm.numberOfUnits, total: widget.wm.total, urls: widget.wm.urls, address: widget.wm.address, buyerUid: um!.uid, latlng: LatLng(widget.wm.latlng!.latitude, widget.wm.latlng!.longitude))
      //   );
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart!'), backgroundColor: kPrimaryColor,),);
      // }, child: Icon(Icons.add_shopping_cart, color: Colors.white,), backgroundColor: kPrimaryColor,) : FloatingActionButton(onPressed: () async{
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
      // }, child: Icon(Icons.shopping_cart, color: Colors.white,), backgroundColor: kPrimaryColor,),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: kGreyText,
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          '${widget.wm.title}',
                          style: TextStyle(fontSize: 28, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            width: size.width * 0.1,
                            height: size.height * 0.4,
                            child: Center(
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Container(
                                  decoration: BoxDecoration(color: kGreyText.withOpacity(0.4), borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        carouselController.previousPage();
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                          child: Container(
                            height: size.height * 0.4,
                            child: CarouselSlider(
                                carouselController: carouselController,
                                items: widget.wm.urls.map((e) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: currentImg == e ? 0 : 16.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Image.network(
                                          e,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  onPageChanged: (value, reason) {
                                    setState(() {
                                      print(value);
                                      currentImg = widget.wm.urls[value];
                                    });
                                  },
                                  viewportFraction: 1,
                                )),
                          ),
                        ),
                        Container(
                            width: size.width * 0.1,
                            height: size.height * 0.4,
                            child: Center(
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: InkWell(
                                  onTap: (){
                                    carouselController.nextPage();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: kGreyText.withOpacity(0.4), borderRadius: BorderRadius.circular(100)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),

                      ],
                    ),
                    Text(
                      '${widget.wm.des}',
                      style: TextStyle(color: kGreyText, fontSize: 16),
                    ),
                    SizedBox(height: 8.0,),
                    Divider(color: kGreyText, thickness: 0.5,),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Number of units: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w500, fontSize: 16),),
                        TextSpan(text: '${widget.wm.numberOfUnits}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),),
                      ],
                    ),),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Amount per unit: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w500, fontSize: 16),),
                        TextSpan(text: '${widget.wm.amountPerUnit} ₹', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),),
                      ],
                    ),),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Total amount: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w500, fontSize: 16),),
                        TextSpan(text: '${widget.wm.numberOfUnits * widget.wm.amountPerUnit} ₹', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),),
                      ],
                    ),),
                    SizedBox(height: 8.0,),
                    Divider(color: kGreyText, thickness: 0.5,),
                    SizedBox(height: 8.0,),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 15,
                          child: Icon(Icons.location_on, color: Colors.white, size: 18,),
                        ),
                        SizedBox(width: 8.0,),
                        Text('Near vikas workshop, Goa', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w600, fontSize: 16,),),
                      ],
                    ),
                    // RichText(text: TextSpan(
                    //   children: [
                    //     TextSpan(text: 'Address: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w500, fontSize: 16),),
                    //     TextSpan(text: 'Near vikas workshop, Goa', style: TextStyle(color: kGreyText, fontWeight: FontWeight.w600, fontSize: 16,),),
                    //   ],
                    // ),),
                    SizedBox(height: 16.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: size.height * 0.4,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: kPrimaryColor),
                        child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: widget.wm.latlng, // Default center (San Francisco)
                          zoom: 15.0,
                          onTap: (pos, ltlng) {
                            setState(() {});
                          }, // Call _handleTap when the map is tapped
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: widget.wm.latlng!,
                                  builder: (ctx) => primaryMarker
                              ),
                            ],
                          ),
                        ],
                      ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Visibility(
                        visible: !impactLoading,
                        child: Text('Benefits of buying: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                    SizedBox(height: 8.0,),
                    Visibility(
                      visible: !impactLoading,
                      child: Container(
                        child: Text('${msg}', style: TextStyle(fontSize: 16),),
                      ),
                    ),
                    Visibility(
                      visible: !impactLoading,
                      child: Container(
                        height: 200,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  // onTap: (){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(wm: widget.wm, um: um!,)));
                  // },
                    onTap: addedToCart ? (){} : () async{
                      setState(() {
                        addedToCart = true;
                      });
                      await CartService(context: context).addToCart(
                          CartModel(title: widget.wm.title, uid: widget.wm.uid, amountPerUnit: widget.wm.amountPerUnit, des: widget.wm.des, numberOfUnits: widget.wm.numberOfUnits, total: widget.wm.total, urls: widget.wm.urls, address: widget.wm.address, buyerUid: um!.uid, latlng: LatLng(widget.wm.latlng!.latitude, widget.wm.latlng!.longitude))
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart!'), backgroundColor: kPrimaryColor,),);
                    },
                  child: AnimatedContainer(
                    width: addedToCart ? 150 : 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          blurRadius: 7,
                          offset: Offset(0, 3)// Elevation level
                        ),
                      ]
                    ),
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(addedToCart ? Icons.shopping_cart_outlined : Icons.add_shopping_cart_outlined, color: Colors.white,),
                          addedToCart ? Text('Added to cart!', style: TextStyle(color: Colors.white, fontSize: 14),) : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Visibility(
              //   visible: addedToCart,
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Container(
              //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: kPrimaryColor,),
              //       height: size.height * 0.08,
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           children: [
              //             Text('This item is added to cart', style: TextStyle(color: Colors.white, fontSize: 18),),
              //             Spacer(),
              //             InkWell(
              //               onTap: (){
              //                 Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
              //               },
              //               child: Container(
              //                width: 100,
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text('View Cart', style: TextStyle(color: Colors.white, fontSize: 16)),
              //                 ),
              //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white)),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
