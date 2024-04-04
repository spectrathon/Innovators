import 'package:latlong2/latlong.dart';

class DonateModel{
  String title, des, address, uid, time;
  LatLng? latlng;  List<dynamic> urls;


  DonateModel({required this.title, required this.address, required this.latlng, required this.des, required this.uid, required this.time, required this.urls});
}