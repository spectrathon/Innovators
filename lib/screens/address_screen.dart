import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:latlong2/latlong.dart';

import '../classes/alert.dart';
import '../constanst.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({required this.sourceLoc});
  LatLng? sourceLoc;

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  LatLng? goingTo;
  LatLng latLng = LatLng(15.2993, 74.1240);
  List<LatLng> polylineCoordinates = [];
  MapController mapController = MapController();
  TextEditingController searchController = TextEditingController();
  List<Polyline> polylines = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.sourceLoc != null)
      searchController.text = '${widget.sourceLoc!.latitude.toStringAsFixed(3)}_${widget.sourceLoc!.longitude.toStringAsFixed(3)}';
    else
    searchController.text = '';
    // setDirection();
  }

  // setDirection() async {
  //   try {
  //     polylines = await GetRoute().getDirections(
  //         widget.leavinglatlng!.latitude, widget.leavinglatlng!.longitude,
  //         goingTo!.latitude, goingTo!.longitude);
  //     setState(() {
  //
  //     });
  //   }catch(e){
  //     Alert(context, e);
  //   }
  // }

  // PolylinePoints polylinePoints = PolylinePoints();

  // void _getPolyline(LatLng goingLtlng) async {
  //   try {
  //
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       googleApiKey,
  //       PointLatLng(widget.leavinglatlng!.latitude, widget.leavinglatlng!.longitude),
  //       PointLatLng(goingLtlng.latitude, goingLtlng.longitude),
  //       travelMode: TravelMode.driving,
  //     );
  //     if (result.points.isNotEmpty) {
  //       result.points.forEach((PointLatLng point) {
  //         print(point.latitude);
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       });
  //     } else {
  //       print(result.errorMessage);
  //     }
  //   }catch(e){
  //     print(e);
  //   }
  //   _addPolyLine(polylineCoordinates);
  // }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.location_on,
          color: Colors.white,
        ),
        onPressed: () {
          if(searchController.text.isEmpty){
            if(widget.sourceLoc != null)
              searchController.text = '${widget.sourceLoc!.latitude.toStringAsFixed(3)}_${widget.sourceLoc!.longitude.toStringAsFixed(3)}';
          }
          Navigator.pop(context, {
            'ltlg' : widget.sourceLoc,
            'location' : searchController.text
          });
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: GooglePlaceAutoCompleteTextField(
                  textEditingController: searchController,
                  googleAPIKey: googleApiKey,
                  inputDecoration: InputDecoration(hintText: 'Search location'),
                  debounceTime: 800 ,
                  countries: ["in","fr"],// optional by default null is set
                  isLatLngRequired:true,// if you required coordinates from place detail
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    // this method will return latlng with place detail
                    print("placeDetails" + prediction.lng.toString());
                    LatLng newLatLng = LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!));
                    setState(() {
                      widget.sourceLoc = newLatLng;
                      mapController.move(widget.sourceLoc!, 17);
                      // _getPolyline(goingTo!);
                    });
                  }, // this callback is called when isLatLngRequired is true
                  itemClick: (Prediction prediction) {
                    searchController.text=prediction.description!;
                    searchController.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(child: Text("${prediction.description??""}"))
                        ],
                      ),
                    );
                  }
              ),
            ),
            Expanded(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: widget.sourceLoc, // Default center (San Francisco)
                  zoom: 12.0,
                  onTap: (pos, ltlng){
                    setState(() {
                      widget.sourceLoc = ltlng;
                      searchController.text = '${ltlng.latitude.toStringAsFixed(3)}_${ltlng.longitude.toStringAsFixed(3)}';
                      // ltlg = LatLng(ltlg.latitude, ltlg.longitude);
                    });
                  }, // Call _handleTap when the map is tapped
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      if (widget.sourceLoc != null)
                      Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.sourceLoc!,
                          builder: (ctx) => primaryMarker
                      ),
                    ],
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
