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
import '../models/donate_model.dart';
import '../providers/user_provider.dart';

class DonateService {
  BuildContext context;
  DonateService({required this.context});

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

  Future<bool> postDonate(DonateModel dm) async {
    try {
        String url = "$kUrl/post-donate";
      print('ADDRESS: ${dm.address}');

      http.Response res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'title': dm.title,
            'des': dm.des,
            'time': dm.time,
            'uid': dm.uid,
            'urls': dm.urls,
            'address' : dm.address,
            'latlng' : {
              'latitude' : dm.latlng!.latitude,
              'longitude' : dm.latlng!.longitude
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

  Future<List<DonateModel>> getDonateProds() async {
    try {
      UserModel um = Provider.of<UserPro>(context, listen: false).um;
      List<DonateModel> list = [];
      String url = "$kUrl/get-donate-products";

      http.Response res = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"},);
      List data = jsonDecode(res.body);
      print(data);
      for(var prod in data){
        DonateModel dm = MapToModel().donateModel(prod);
        if(dm.uid != um.uid)
        list.add(dm);
      }
      return list;
    } catch (e) {
      print(e);
      Alert(context, e);
      return [];
    }
  }
}
