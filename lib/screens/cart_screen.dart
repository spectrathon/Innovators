import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euse/constanst.dart';
import 'package:euse/models/cart_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:euse/screens/view_product_screen.dart';
import 'package:euse/screens/custom_button.dart';
import 'package:euse/services/cart_service.dart';
import 'package:euse/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../models/waste_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<WasteModel> products = [];
  UserModel? um;
  double total = 0;
  List<CartModel> cList = [];

  @override
  void initState() {
    // TODO: implement initState
    um = Provider.of<UserPro>(context, listen: false).um;
    print(um!.uid);
    super.initState();
    getProds();
  }

  getProds() async {
    cList = await CartService(context: context).getCartProds(um!.uid);
    setState(() {
      cList.forEach((element) {
        total += element.total;
      });
    });
  }

  showDel(product) async {

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Are you sure you want to delete it?'),
        actions: [
          ElevatedButton(onPressed: () async {
            Navigator.pop(context);
            try {
              setState(() {
                cList.remove(product);
                // medHisList.remove(med);
              });
              // await firestore.collection('Patients').doc(widget.uid).collection(
              //     'Medical History').doc(med).delete();
              // print('deleted');

            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete: ${e}')));
            }
          }, child: Text('Delete'), style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.redAccent),),),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
        ],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: ListView(
                  shrinkWrap: true,
                  children: cList.map((e) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProduct(wm: e.CartToWaste())));
                        },
                        child: Dismissible(
                          behavior: HitTestBehavior.opaque,
                          confirmDismiss: (direction) async {
                            showDel(e);
                            // if(direction == DismissDirection.startToEnd){
                            //   await Timer(Duration(seconds: 2), () {
                            //     print('ada');
                            //   });
                            //   print('rea');
                            //   return true;
                            // }
                            return false;
                          },
                          key: GlobalKey(),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: size.height * 0.1,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      child: Image.network(e.urls[0]),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(e.title, style: TextStyle(fontWeight: FontWeight.bold),),
                                        SizedBox(
                                          height: 4.0,
                                        ),
                                        Text(e.des),
                                      ],
                                    )),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text("\$${e.total.toString()}", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Container(
                      child: Column(
                        children: [
                          Text('Items worth: '),
                          Text('\$${total}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),),
                    Container(
                      width: 100,
                      child: CustomButton(text: 'BUY', onTap: (){

                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
