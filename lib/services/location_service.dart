import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../classes/alert.dart';

class LocationService{

  BuildContext context;
  LocationService({required this.context});

  Future<LatLng> getCurrentLoc() async {

    try {
      bool isServiceEnabled;
      LocationPermission permission;

      isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        Alert(context, 'Location service disabled!');
        throw ('Location service disabled!');
      } else {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          // await Geolocator.requestPermission();
          throw ('Location Permission denied!');
        } else if (permission == LocationPermission.deniedForever) {
          Alert(context, 'Location Permission Permanently disabled!');
          throw ('Location Permission Permanently disabled!');
        } else {
          Position pos  = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          // latitude = pos.latitude;
          // longitude = pos.longitude;
          // Alert(context, '$latitude $longitude');
          return LatLng(pos.latitude, pos.longitude);
        }
      }
    } catch (e) {
        // Alert(context, e);
      print(e);
        return LatLng(15.2993, 74.1240);
    }
  }

}