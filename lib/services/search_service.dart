import 'dart:convert';

import 'package:euse/classes/alert.dart';
import 'package:euse/classes/map_to_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:euse/models/waste_model.dart';
import 'package:euse/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constanst.dart';
import '../models/cart_model.dart';

class SearchService{

  BuildContext context;
  SearchService({required this.context});

  Future<List<WasteModel>> search(String searchTxt) async {
    List<WasteModel> list = [];
    String url = "$kUrl/search?title=$searchTxt";
    http.Response res = await http.get(Uri.parse(url),
      headers: {"Content-Type": "application/json"},);

    final datas = jsonDecode(res.body);
    for(var data in datas){
      list.add(MapToModel().wasteModel(data));
      print(MapToModel().wasteModel(data));
    }
    return list;
  }
}