import 'package:euse/models/auction_model.dart';
import 'package:euse/models/bid_model.dart';
import 'package:euse/models/cart_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../models/donate_model.dart';
import '../models/user_model.dart';

class MapToModel {

  userModel(data) {
    return UserModel(
        email: data['email'],
        uid: data['uid'],
        name: data['name'],
        token: data['token'],
        phone: data['phone'],
        id: data['_id'],
        role: data['role']);
  }

  wasteModel(data) {
    return WasteModel(title: data['title'],
        uid: data['uid'],
        amountPerUnit: double.parse(data['amountPerUnit'].toString()),
        des: data['des'],
        numberOfUnits: data['numberOfUnits'],
        total: double.parse(data['total'].toString()),
        urls: data['urls'], address: data['address'], latlng: LatLng(data['latlng']['latitude'], data['latlng']['longitude']));
  }

  donateModel(data) {
    return DonateModel(title: data['title'],
        uid: data['uid'],
        time: data['time'],
        des: data['des'],
        urls: data['urls'],address: data['address'], latlng: LatLng(data['latlng']['latitude'], data['latlng']['longitude']));
  }

  cartModel(data) {
    return CartModel(title: data['title'],
        uid: data['uid'],
        amountPerUnit: double.parse(data['amountPerUnit'].toString()),
        des: data['des'],
        numberOfUnits: data['numberOfUnits'],
        total: double.parse(data['total'].toString()),
        urls: data['urls'], address: data['address'], latlng: LatLng(data['latlng']['latitude'], data['latlng']['longitude'],), buyerUid: data['buyerUid']);
  }

  auctionModel(data) {
    final list = data['bidList'];
    // List<BidModel> bidList = list.map((e){
    //   return BidModel(uid: e['uid'], bidPrice: int.parse(e['bidPrice']), name: e['name']);
    // }).toList() as List<BidModel>;
    return AuctionModel(title: data['title'],
        uid: data['uid'],
        currentPrice: int.parse(data['currentPrice'].toString()),
        startingPrice: int.parse(data['startingPrice'].toString()),
        des: data['des'],
        numberOfUnits: data['numberOfUnits'],
        bidList: list.map((e){
          return BidModel(uid: e['uid'], bidPrice: e['bidPrice'], name: e['name']);
        }).toList(),
        urls: data['urls'], aid: data['aid'],);
  }
}