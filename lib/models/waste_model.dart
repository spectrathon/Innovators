import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class WasteModel {
  String title, des, uid, address;
  double amountPerUnit, total;
  int numberOfUnits;
  List<dynamic> urls;
  LatLng? latlng;

  WasteModel({
    required this.title,
    required this.uid,
    required this.amountPerUnit,
    required this.des,
    required this.numberOfUnits,
    required this.total,
    required this.urls,
    required this.address,
    this.latlng,
  });
}
