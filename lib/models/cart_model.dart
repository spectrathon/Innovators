import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class CartModel{

  String title, des, uid, address, buyerUid;
  double amountPerUnit, total;
  int numberOfUnits;
  List<dynamic> urls;
  LatLng? latlng;

  CartModel({
    required this.title,
    required this.uid,
    required this.amountPerUnit,
    required this.des,
    required this.numberOfUnits,
    required this.total,
    required this.urls,
    required this.address,
    required this.buyerUid,
    required this.latlng,
});

  WasteModel CartToWaste(){

    return  WasteModel(title: title, uid: uid, amountPerUnit: amountPerUnit, des: des, numberOfUnits: numberOfUnits, total: total, urls: urls, address: address, latlng: latlng);
  }
}