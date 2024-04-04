import 'package:euse/classes/map_to_model.dart';
import 'package:euse/models/user_model.dart';
import 'package:flutter/material.dart';

class UserPro extends ChangeNotifier{

  UserModel _um = UserModel(email: '', uid: '', name: '', token: '', phone: '', id: '', role: '');

  UserModel get um => _um;

  setUserFromMap(data){
    _um = MapToModel().userModel(data);
    notifyListeners();
  }

  setUser(UserModel user){
    _um = user;
    notifyListeners();
  }

}