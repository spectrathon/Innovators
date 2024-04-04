import 'dart:convert';

import 'package:euse/classes/alert.dart';
import 'package:euse/constanst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapServices{

  BuildContext context;

  MapServices({required this.context});


  Future<List<Marker>> getWasteLocation() async {

    List<Marker> markers = [];
    try {
      String url = '$kUrl/get-waste-location';

      http.Response res = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final wastes = jsonDecode(res.body);
      for(var waste in wastes){
        markers.add(
          Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(waste['latlng']['latitude'], waste['latlng']['longitude']),
              builder: (ctx) => primaryMarker
          ),
        );
      }
      return markers;
    }catch(e){
      Alert(context, '${e}');
      return markers;
    }
  }
}