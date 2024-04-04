import 'dart:convert';
import 'dart:io';

import 'package:euse/classes/map_to_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../classes/alert.dart';
import '../constanst.dart';
import '../providers/user_provider.dart';

class SellService {
  BuildContext context;
  SellService({required this.context});

  Future<List<String>> uploadImages(List<File> files) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask? ut;
    List<String> urls = [];
    for (var file in files) {
      print(file.path);
      ut = storage
          .ref()
          .child('Posts')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file);
      final snapshot = await (ut.whenComplete(() {}));
      print("reached!");
      String url = await (snapshot.ref.getDownloadURL());
      print(url);

      urls.add(url);
    }
    return urls;
  }

  Future<bool> postWaste(WasteModel wm) async {
    try {
      String url = "$kUrl/post-waste";
      print('ADDRESS: ${wm.address}');

      http.Response res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'title': wm.title,
            'des': wm.des,
            'amountPerUnit': wm.amountPerUnit,
            'numberOfUnits': wm.numberOfUnits,
            'total': wm.total,
            'uid': wm.uid,
            'urls': wm.urls,
            'address' : wm.address,
            'latlng' : {
              'latitude' : wm.latlng!.latitude,
              'longitude' : wm.latlng!.longitude
            }
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

  Future<List<WasteModel>> getProds() async {
    try {
      UserModel um = Provider.of<UserPro>(context, listen: false).um;
      List<WasteModel> list = [];
      String url = "$kUrl/get-products";

      http.Response res = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"},);
      List data = jsonDecode(res.body);
      print(data);
      for(var prod in data){
        WasteModel wm = MapToModel().wasteModel(prod);
        if(wm.uid != um.uid)
        list.add(wm);
      }
      return list;
    } catch (e) {
      Alert(context, e);
      return [];
    }
  }
  Future<List<WasteModel>> getMyProds(String uid) async {
    try {
      List<WasteModel> list = [];
      String url = "$kUrl/get-products";

      http.Response res = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"},);
      List data = jsonDecode(res.body);
      for(var prod in data){
        WasteModel wm = MapToModel().wasteModel(prod);
        if(wm.uid == uid)
        list.add(wm);
      }
      return list;
    } catch (e) {
      Alert(context, e);
      return [];
    }
  }
}
