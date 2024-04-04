import 'dart:convert';

import 'package:euse/classes/alert.dart';
import 'package:euse/classes/map_to_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constanst.dart';
import '../models/cart_model.dart';

class CartService{

  BuildContext context;
  CartService({required this.context});

  Future addToCart(CartModel cm) async {
    try {
      String url = "$kUrl/add-to-cart";
      http.Response res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'title': cm.title,
            'des': cm.des,
            'amountPerUnit': cm.amountPerUnit,
            'numberOfUnits': cm.numberOfUnits,
            'total': cm.total,
            'uid': cm.uid,
            'urls': cm.urls,
            'address' : cm.address,
            'latlng' : {
              'latitude' : cm.latlng!.latitude,
              'longitude' : cm.latlng!.longitude
            },
            'buyerUid' : cm.buyerUid,
          }));
      final data = jsonDecode(res.body);
      print(data);
      if(res.statusCode == 200)
        return true;
      return false;
    } catch (e) {
      Alert(context, e);
      return false;
    }
  }

  Future<List<CartModel>> getCartProds(uid) async {
    List<CartModel> list = [];
    try{
      String url = "$kUrl/get-cart-products";
      http.Response res = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: jsonEncode({
        'buyerUid' : uid
      }));

      final prods = jsonDecode(res.body);
      for(var prod in prods){
        list.add(MapToModel().cartModel(prod));
      }

      return list;
    }catch(e){
      Alert(context, e);
      return [];
    }
  }

  Future<bool> prodExistsInCart(uid, title, des) async {
    try{
      String url = "$kUrl/check-cart";
      http.Response res = await http.post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: jsonEncode({
        'uid' : uid,
        'title': title,
        'des': des,
      }));

      final prods = jsonDecode(res.body);
      print(prods);
      return prods;
    }catch(e){
      Alert(context, e);
      return false;
    }
  }
}