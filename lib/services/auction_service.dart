import 'dart:convert';
import 'dart:io';

import 'package:euse/classes/map_to_model.dart';
import 'package:euse/models/auction_model.dart';
import 'package:euse/models/bid_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../classes/alert.dart';
import '../constanst.dart';
import '../providers/user_provider.dart';

class AuctionService {
  BuildContext context;
  AuctionService({required this.context});

  Future<List<String>> uploadImages(List<File> files) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask? ut;
    List<String> urls = [];

    for (var file in files) {
      ut = storage
          .ref()
          .child('Auctions')
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

  Future<bool> postAuction(AuctionModel am) async {
    try {
      String url = "$kUrl/post-auction";

      http.Response res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'title': am.title,
            'des': am.des,
            'numberOfUnits': am.numberOfUnits,
            'currentPrice': am.currentPrice,
            'aid': am.aid,
            'startingPrice': am.startingPrice,
            'uid': am.uid,
            'urls': am.urls,
            'bidList': am.bidList.map((e){

              return {
                'name' : e.name,
                'bidPrice' : e.bidPrice,
                'uid' : e.uid,
              };
            }).toList(),
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

  Future<List<AuctionModel>> getProds() async {
    // try {
      UserModel um = Provider.of<UserPro>(context, listen: false).um;
      List<AuctionModel> list = [];
      String url = "$kUrl/get-auction-prods";

      http.Response res = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"},);
      List data = jsonDecode(res.body);
      for(var prod in data){
        AuctionModel am = MapToModel().auctionModel(prod);
        list.add(am);
      }
      return list;
    // } catch (e) {
    //   Alert(context, e);
    //   return [];
    // }
  }
}
