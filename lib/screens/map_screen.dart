import 'package:euse/services/map_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/alert.dart';
import '../constanst.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng latLng = LatLng(15.2993, 74.1240);
  LatLng centerLatLng = LatLng(15.2993, 74.1240);
  List<Marker> markerList = [
    // Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(15.409, 73.797),
    //     builder: (ctx) => primaryMarker
    // ),
    // Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(15.465, 73.805),
    //     builder: (ctx) => primaryMarker
    // ),
    // Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(15.489, 73.814),
    //     builder: (ctx) => primaryMarker
    // ),
    // Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(15.366, 73.898),
    //     builder: (ctx) => primaryMarker
    // ),
    // Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(15.378, 73.860),
    //     builder: (ctx) => primaryMarker
    // ),
    // Marker(
    //     width: 80.0,
    //     height: 80.0,
    //     point: LatLng(15.450, 73.859),
    //     builder: (ctx) => primaryMarker
    // ),
  ];
  List<LatLng> polylineCoordinates = [];
  MapController mapController = MapController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarkers();
  }

  getMarkers() async {
    markerList = await MapServices(context: context).getWasteLocation();
    markerList.add(
      Marker(point: LatLng(15.5294337, 73.7788561), builder: (context){
       return InkWell(child: primaryMarker, onTap: (){
         print('pressed');
         launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=15.5294337,%2073.7788561'));
       },);
      })
    );
    markerList.add(
      Marker(point: LatLng(15.5493084,73.7664658), builder: (context){
       return primaryMarker;
      },)
    );
    markerList.add(
      Marker(point: LatLng(15.2694225, 73.9840739), builder: (context){
       return Icon(Icons.location_on, color: Colors.blue, size: 50);
      })
    );
    markerList.add(
      Marker(point: LatLng(15.5294337,73.7788561), builder: (context){
       return Icon(Icons.location_on, color: Colors.blue, size: 50);
      })
    );
    setState(() {
      centerLatLng = markerList.isEmpty ? LatLng(15.2993, 74.1240) : markerList[0].point;
    });
    mapController.move(centerLatLng, 12);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: centerLatLng, // Default center (San Francisco)
                  zoom: 12.0,
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
                    markers: markerList,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
