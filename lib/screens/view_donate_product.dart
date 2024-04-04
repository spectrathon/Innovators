import 'package:carousel_slider/carousel_slider.dart';
import 'package:euse/classes/alert.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/cart_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/screens/cart_screen.dart';
import 'package:euse/screens/chat_screen.dart';
import 'package:euse/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/donate_model.dart';
import '../models/user_model.dart';
import '../services/bot_service.dart';

class ViewDonateProduct extends StatefulWidget {
  ViewDonateProduct({required this.dm});
  DonateModel dm;

  @override
  State<ViewDonateProduct> createState() => _ViewDonateProductState();
}

class _ViewDonateProductState extends State<ViewDonateProduct> {
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
    currentImg = widget.dm.urls[0];
    um = Provider.of<UserPro>(context, listen: false).um;
    print(widget.dm.latlng!.longitude);
    getImpact();
    // checkCart();
  }

  getImpact() async {
    String prompt = '''
    What positive impact will I make if I recycled ${widget.dm.title}. Tell me in numbers. 
    Answer should be under 30-40 words with bullet points. 
    Tell in future tense. Also add a small motivating one line at the end.
    ''';
    String text = await BotService(context: context).prompt(prompt);
    setState(() {
      msg = text;
      impactLoading = false;
    });
  }

  // checkCart() async {
  //   addedToCart = await CartService(context: context).prodExistsInCart(um!.uid, widget.dm.title, widget.dm.des);
  //   setState(() {
  //     addedToCart;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(dm: widget.dm, um: um!,)));
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
      //       CartModel(title: widget.dm.title, uid: widget.dm.uid, amountPerUnit: widget.dm.amountPerUnit, des: widget.dm.des, numberOfUnits: widget.dm.numberOfUnits, total: widget.dm.total, urls: widget.dm.urls, address: widget.dm.address, buyerUid: um!.uid, latlng: LatLng(widget.dm.latlng!.latitude, widget.dm.latlng!.longitude))
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
                          '${widget.dm.title}',
                          style: TextStyle(fontSize: 32, color: Colors.black),
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
                                  decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.4), borderRadius: BorderRadius.circular(100)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        carouselController.previousPage();
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        color: Colors.white,
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
                                items: widget.dm.urls.map((e) {
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
                                      currentImg = widget.dm.urls[value];
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
                                    decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.4), borderRadius: BorderRadius.circular(100)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),

                      ],
                    ),
                    Text(
                      '${widget.dm.des}',
                      style: TextStyle(color: kGreyText, fontSize: 18),
                    ),
                    SizedBox(height: 8.0,),
                    Divider(color: kGreyText,),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Number of units: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.bold, fontSize: 18),),
                        TextSpan(text: '8', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    ),),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Amount per unit: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.bold, fontSize: 18),),
                        TextSpan(text: '180 ₹', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    ),),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Total amount: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.bold, fontSize: 18),),
                        TextSpan(text: '8800 ₹', style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    ),),
                    SizedBox(height: 8.0,),
                    Divider(color: kGreyText,),
                    SizedBox(height: 8.0,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Address: ', style: TextStyle(color: kGreyText, fontWeight: FontWeight.bold, fontSize: 18),),
                        TextSpan(text: 'Near vikas workshop, Goa', style: TextStyle(color: kGreyText, fontWeight: FontWeight.bold, fontSize: 20,),),
                      ],
                    ),),
                    SizedBox(height: 16.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: size.height * 0.4,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: kPrimaryColor),
                        child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: widget.dm.latlng, // Default center (San Francisco)
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
                                  point: widget.dm.latlng!,
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
                        child: Text('Impact you will make', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                    SizedBox(height: 8.0,),
                    Visibility(
                      visible: !impactLoading,
                      child: Container(
                        child: Text('${msg}', style: TextStyle(fontSize: 16),),
                        height: 300,
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   child: InkWell(
              //     // onTap: (){
              //     //   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(dm: widget.dm, um: um!,)));
              //     // },
              //       onTap: addedToCart ? (){} : () async{
              //         setState(() {
              //           addedToCart = true;
              //         });
              //         await CartService(context: context).addToCart(
              //             CartModel(title: widget.dm.title, uid: widget.dm.uid, des: widget.dm.des, time: widget.dm.time , urls: widget.dm.urls, address: widget.dm.address, buyerUid: um!.uid, latlng: LatLng(widget.dm.latlng!.latitude, widget.dm.latlng!.longitude))
              //         );
              //         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart!'), backgroundColor: kPrimaryColor,),);
              //       },
              //     child: AnimatedContainer(
              //       width: addedToCart ? 150 : 56,
              //       height: 56,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(12),
              //         color: kPrimaryColor,
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.grey, // Shadow color
              //             blurRadius: 7,
              //             offset: Offset(0, 3)// Elevation level
              //           ),
              //         ]
              //       ),
              //       duration: Duration(milliseconds: 500),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             Icon(addedToCart ? Icons.shopping_cart_outlined : Icons.add_shopping_cart_outlined, color: Colors.white,),
              //             addedToCart ? Text('Added to cart!', style: TextStyle(color: Colors.white, fontSize: 14),) : Container(),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
